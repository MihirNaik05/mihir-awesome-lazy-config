return {
	'tpope/vim-fugitive',
	cmd = { 'Git', 'Gstatus', 'Gdiffsplit', 'Gblame', 'Gclog', 'Gedit' },
	keys = {
		{ '<leader>gg', '<cmd>Git<CR>', desc = 'Git (fugitive)' },
		{ '<leader>gc', '<cmd>Git commit<CR>', desc = 'Git commit' },
		{ '<leader>gp', '<cmd>Git push<CR>', desc = 'Git push' },
		{ '<leader>gl', '<cmd>Gclog<CR>', desc = 'Git log' },
	},
}