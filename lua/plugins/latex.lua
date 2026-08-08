return {
	{
		'lervag/vimtex',
		lazy = false,
		init = function()
			vim.g.vimtex_view_automatic = 0
			vim.g.vimtex_compiler_method = 'latexmk'
		end,
	},
}
