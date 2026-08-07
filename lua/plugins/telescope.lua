return { 
	'nvim-telescope/telescope.nvim',
	version = '*',
	dependencies = {
		'nvim-lua/plenary.nvim',
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	},
	config = function()
		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader><leader>', builtin.find_files, {})
		vim.keymap.set('n', '<leader>sg', function()
			builtin.grep_string({ search = vim.fn.input('Grep > ') })
		end)
	end,
}
