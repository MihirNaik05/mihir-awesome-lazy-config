return {
	'nvim-treesitter/nvim-treesitter',
	lazy = false,
	build = ':TSUpdate',
	config = function()
		require('nvim-treesitter').install {
			'lua', 'vim', 'vimdoc',
			'javascript', 'typescript', 'tsx',
			'python', 'go', 'rust',
			'html', 'css', 'json', 'yaml', 'markdown', 'markdown_inline', 'latex', 'bash',
		}
		vim.api.nvim_create_autocmd('FileType', {
			callback = function()
				if vim.bo.filetype == 'tex' then
					return
				end
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
