return {
	'lewis6991/gitsigns.nvim',
	event = { 'BufReadPre', 'BufNewFile' },
	opts = {
		signs = {
			add = { text = '┃' },
			change = { text = '┃' },
			delete = { text = '_' },
			topdelete = { text = '‾' },
			changedelete = { text = '~' },
			untracked = { text = '┆' },
		},
		on_attach = function(bufnr)
			local gitsigns = require('gitsigns')
			local map = function(mode, l, r, o)
				o = o or {}
				o.buffer = bufnr
				vim.keymap.set(mode, l, r, o)
			end
			map('n', ']c', function() gitsigns.nav_hunk('next') end)
			map('n', '[c', function() gitsigns.nav_hunk('prev') end)
			map('n', '<leader>hs', gitsigns.stage_hunk)
			map('n', '<leader>hr', gitsigns.reset_hunk)
			map('n', '<leader>hp', gitsigns.preview_hunk)
			map('n', '<leader>hb', function() gitsigns.blame_line({ full = true }) end)
			map('n', '<leader>hd', gitsigns.diffthis)
			map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
		end,
	},
}