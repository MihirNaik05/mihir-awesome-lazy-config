return {
	-- mason: manage server/tool installation from :Mason
	{ 'mason-org/mason.nvim', cmd = 'Mason', build = ':MasonUpdate', opts = {} },

	-- auto-install + auto-enable servers
	{
		'mason-org/mason-lspconfig.nvim',
		opts = {
			ensure_installed = {
				'lua_ls', 'ts_ls', 'ruff', 'pyright', 'rust_analyzer', 'html', 'cssls', 'texlab',
			},
			automatic_enable = { exclude = { 'pyright' } },
		},
		dependencies = { 'mason-org/mason.nvim', 'neovim/nvim-lspconfig' },
	},

	-- lspconfig: server configs + goto keymaps
	{
		'neovim/nvim-lspconfig',
		event = { 'BufReadPre', 'BufNewFile' },
		config = function()
			vim.diagnostic.config({
				virtual_text = { prefix = '•', source = 'if_many' },
				float = { border = 'rounded', source = true },
				severity_sort = true,
				underline = true,
				signs = true,
			})

			vim.lsp.config('ruff', {
				init_options = {
					settings = {
						lint = {
							enable = true,
							select = { 'E', 'F', 'W' },
							ignore = { 'I' },
							preview = false,
						},
						format = { enable = true, preview = false },
						lineLength = 88,
					},
				},
			})

			vim.lsp.config('lua_ls', {
				settings = {
					Lua = {
						runtime = { version = 'LuaJIT' },
						diagnostics = { globals = { 'vim' } },
						workspace = { checkThirdParty = false },
					},
				},
			})

			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(args)
					local map = function(mode, lhs, rhs, o)
						o = o or {}
						o.buffer = args.buf
						vim.keymap.set(mode, lhs, rhs, o)
					end
					map('n', 'gd', vim.lsp.buf.definition, { desc = 'Goto Definition' })
					map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Goto Declaration' })
					map('n', 'gI', vim.lsp.buf.implementation, { desc = 'Goto Implementation' })
					map('n', 'gy', vim.lsp.buf.type_definition, { desc = 'Goto Type Definition' })
					map('n', 'gr', vim.lsp.buf.references, { desc = 'References' })
					map('n', 'K', vim.lsp.buf.hover, { desc = 'Hover' })
					map('n', 'gK', vim.lsp.buf.signature_help, { desc = 'Signature Help' })
					map('i', '<c-k>', vim.lsp.buf.signature_help)
					map('n', '<leader>dn', vim.diagnostic.goto_next, { desc = 'Next Diagnostic' })
					map('n', '<leader>dp', vim.diagnostic.goto_prev, { desc = 'Prev Diagnostic' })
					map('n', '<leader>dd', vim.diagnostic.open_float, { desc = 'Diagnostic Detail' })
					map('n', '<leader>f', vim.lsp.buf.format, { desc = 'Format Buffer' })
				end,
			})
		end,
	},
}



