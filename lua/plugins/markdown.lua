return {
	{
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
		ft = { 'markdown' },
		opts = {
			latex = { enabled = true },
		},
	},
	{
		'selimacerbas/markdown-preview.nvim',
		dependencies = { 'selimacerbas/live-server.nvim' },
		ft = { 'markdown' },
		opts = {},
	},
}
