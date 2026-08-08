local M = {}

local RELOAD_DELAY = 500

local TDF_BIN = vim.fn.exepath('tdf')
if TDF_BIN == '' then
  local alt = vim.fn.expand('~/.cargo/bin/tdf')
  if vim.fn.executable(alt) == 1 then TDF_BIN = alt end
end

-- panes: tex root | md abs path -> { term_id, win_id, tab_id, mode = 'pdf'|'err' }
local panes = {}

-- root -> pdf mtime at last good build; used to detect recovered failures
local last_pdf_mtime = {}

local function pdf_mtime(pdf)
  return pdf and vim.fn.getftime(pdf) or -1
end

local function log(msg, level)
  vim.notify('tdf: ' .. msg, level or vim.log.levels.INFO)
end

local function ghostty_ok()
  if vim.fn.executable('osascript') ~= 1 then
    log('osascript not found; need macOS + Ghostty', vim.log.levels.WARN)
    return false
  end
  return true
end

local function apple(script)
  local out = vim.fn.system('osascript -e ' .. vim.fn.shellescape(script))
  if vim.v.shell_error ~= 0 then return false, out end
  return true, out:gsub('%s+$', '')
end

local function esc_as(s)
  return (s:gsub('\\', '\\\\'):gsub('"', '\\"'))
end

local function ghostty_split(cmd)
  local script = string.format([[
tell application "Ghostty"
  set cfg to new surface configuration
  set command of cfg to "%s"
  set frontWin to front window
  set mainTab to selected tab of frontWin
  set currentTerm to focused terminal of mainTab
  set newTerm to split currentTerm direction right with configuration cfg
  return (id of newTerm) & "|" & (id of frontWin) & "|" & (id of mainTab)
end tell]], esc_as(cmd))
  local ok, out = apple(script)
  if not ok then
    log('Ghostty split failed: ' .. out, vim.log.levels.ERROR)
    return nil
  end
  local t, w, tab = out:match('([^|]+)|([^|]+)|([^|]+)')
  return t and { term_id = t, win_id = w, tab_id = tab } or nil
end

local function ghostty_close(pane)
  if not pane then return end
  local script = string.format([[
tell application "Ghostty"
  try
    close (terminal id "%s" of tab id "%s" of window id "%s")
  end try
end tell]], pane.term_id, pane.tab_id, pane.win_id)
  apple(script)
end

local function ghostty_alive(pane)
  if not pane then return false end
  local script = string.format([[
tell application "Ghostty"
  try
    set t to (terminal id "%s" of tab id "%s" of window id "%s")
    return "alive"
  on error
    return "dead"
  end try
end tell]], pane.term_id, pane.tab_id, pane.win_id)
  local ok, out = apple(script)
  return ok and out == 'alive'
end

-- ---------------------------- LaTeX / vimtex ----------------------------

local function project_root() return vim.b.vimtex and vim.b.vimtex.root or nil end

local function get_pdf_path()
  local ok, out = pcall(vim.fn.eval, 'b:vimtex.viewer.out()')
  if ok and out ~= '' and vim.fn.filereadable(out) == 1 then return out end
  local p = vim.fn.expand('%:p:r') .. '.pdf'
  return vim.fn.filereadable(p) == 1 and p or nil
end

local function open_pdf_pane()
  if not ghostty_ok() then return end
  if TDF_BIN == '' then
    log('tdf binary not found; install via cargo', vim.log.levels.ERROR)
    return
  end
  local pdf = get_pdf_path()
  if not pdf then
    log('no compiled PDF yet')
    return
  end
  local root = project_root() or vim.fn.getcwd()
  last_pdf_mtime[root] = pdf_mtime(pdf)
  local st = panes[root]
  if st and st.mode == 'pdf' and ghostty_alive(st) then return end -- tdf hot-reloads
  ghostty_close(st)
  st = ghostty_split(TDF_BIN .. ' --reload-delay ' .. RELOAD_DELAY .. ' ' .. pdf)
  if st then
    st.mode = 'pdf'
    panes[root] = st
  end
end

local function open_err_pane()
  if not ghostty_ok() then return end
  local root = project_root() or vim.fn.getcwd()
  local pdf = get_pdf_path()
  local prev = last_pdf_mtime[root]
  if pdf and prev ~= nil and pdf_mtime(pdf) > prev then
    open_pdf_pane() -- latexmk recovered and wrote a fresh pdf; keep the preview
    return
  end
  local lines = {}
  for _, e in ipairs(vim.fn.getqflist()) do
    if e.type == nil or e.type == 'E' then
      local fname = e.filename
        or (e.bufnr and e.bufnr ~= 0 and vim.fn.bufname(e.bufnr) or '')
        or ''
      table.insert(lines, string.format('%s:%s:%s: %s', fname, e.lnum, e.col, e.text))
    end
  end
  if #lines == 0 then
    lines = { 'Compilation failed (no parseable errors). See :VimtexCompileOutput.' }
  end
  local tmp = vim.fn.tempname()
  local f = io.open(tmp, 'w')
  f:write(table.concat(lines, '\n'), '\n')
  f:close()

  local st = panes[root]
  ghostty_close(st)
  st = ghostty_split('less -R ' .. tmp)
  if st then
    st.mode = 'err'
    panes[root] = st
  end
end

local function toggle_pdf()
  local key = project_root() or vim.fn.getcwd()
  local st = panes[key]
  if st and st.mode == 'pdf' and ghostty_alive(st) then
    ghostty_close(st)
    panes[key] = nil
  else
    open_pdf_pane()
  end
end

local function compile_running()
  if not vim.b.vimtex then return false end
  local ok, running = pcall(vim.fn.eval, 'b:vimtex.compiler.is_running()')
  return ok and running == 1
end

local function auto_compile(bufnr)
  vim.defer_fn(function()
    vim.api.nvim_buf_call(bufnr, function()
      local tex = vim.b.vimtex and vim.b.vimtex.tex or ''
      if tex == '' then return end
      if vim.fn.executable('latexmk') ~= 1 then
        log('latexmk not found; skipping auto-compile', vim.log.levels.WARN)
        return
      end
      if compile_running() then return end
      vim.cmd('VimtexCompile')
    end)
  end, 300)
end

-- ---------------------------- Markdown / pandoc ----------------------------

local function md_cache_path(md)
  local dir = vim.fn.stdpath('cache') .. '/tdf-md'
  vim.fn.mkdir(dir, 'p')
  local key = md:gsub('[^%w%.%-]', '_')
  return dir .. '/' .. key .. '.pdf'
end

local function md_render(md, out, cb)
  if vim.fn.executable('pandoc') ~= 1 then
    log('pandoc not found', vim.log.levels.ERROR)
    return
  end
  local errbuf = {}
  vim.fn.jobstart({ 'pandoc', md, '-o', out, '--pdf-engine=pdflatex' }, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stderr = function(_, data)
      if data then vim.list_extend(errbuf, data) end
    end,
    on_exit = function(_, code)
      if code == 0 then
        if cb then cb() end
      else
        local msg = table.concat(errbuf, '\n'):match('[^\n]+') or 'pandoc failed'
        log(msg, vim.log.levels.ERROR)
      end
    end,
  })
end

local function tdf_md()
  if vim.bo.filetype ~= 'markdown' then
    log('not a markdown buffer', vim.log.levels.WARN)
    return
  end
  if not ghostty_ok() then return end
  local md = vim.fn.expand('%:p')
  local out = md_cache_path(md)
  local st = panes[md]
  if st and st.mode == 'pdf' and ghostty_alive(st) then
    md_render(md, out)
    return
  end
  md_render(md, out, function()
    ghostty_close(st)
    if TDF_BIN == '' then
      log('tdf binary not found; install via cargo', vim.log.levels.ERROR)
      return
    end
    st = ghostty_split(TDF_BIN .. ' --reload-delay ' .. RELOAD_DELAY .. ' ' .. out)
    if st then
      st.mode = 'pdf'
      panes[md] = st
    end
  end)
end

-- ---------------------------- setup ----------------------------

function M.setup()
  local grp = vim.api.nvim_create_augroup('TdfPreview', { clear = true })

  vim.api.nvim_create_autocmd('FileType', {
    group = grp, pattern = 'tex',
    callback = function(args) auto_compile(args.buf) end,
  })

  vim.api.nvim_create_autocmd('User', {
    group = grp, pattern = 'VimtexEventCompileSuccess',
    callback = open_pdf_pane,
  })
  vim.api.nvim_create_autocmd('User', {
    group = grp, pattern = 'VimtexEventCompileFailed',
    callback = open_err_pane,
  })

  vim.api.nvim_create_autocmd('FileType', {
    group = grp, pattern = { 'tex', 'bib' },
    callback = function()
      vim.keymap.set('n', '<localleader>lv', toggle_pdf,
        { buffer = true, desc = 'tdf: toggle tex PDF preview' })
    end,
  })

  vim.api.nvim_create_autocmd('BufWritePost', {
    group = grp, pattern = '*.md',
    callback = function(args)
      local md = vim.api.nvim_buf_get_name(args.buf)
      local st = panes[md]
      if st and st.mode == 'pdf' and ghostty_alive(st) then
        md_render(md, md_cache_path(md))
      end
    end,
  })

  vim.api.nvim_create_user_command('TdfOpen', open_pdf_pane, {})
  vim.api.nvim_create_user_command('TdfMd', tdf_md, {})
  vim.api.nvim_create_user_command('TdfKill', function()
    local key = vim.bo.filetype == 'markdown' and vim.fn.expand('%:p') or project_root()
    if key and panes[key] then
      ghostty_close(panes[key])
      panes[key] = nil
    end
  end, {})

  vim.keymap.set('n', '<leader>td', ':TdfMd<CR>', { desc = 'tdf: open markdown PDF preview' })
end

return M
