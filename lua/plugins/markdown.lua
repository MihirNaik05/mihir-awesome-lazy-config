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
		cmd = { 'MarkdownPreview', 'MarkdownPreviewRefresh', 'MarkdownPreviewStop' },
		opts = {},
		keys = {
			{ '<leader>mp', '<cmd>MarkdownPreview<cr>', desc = 'Markdown preview' },
			{ '<leader>mr', '<cmd>MarkdownPreviewRefresh<cr>', desc = 'Markdown refresh' },
			{ '<leader>ms', '<cmd>MarkdownPreviewStop<cr>', desc = 'Markdown stop' },
		},
	},
}
