return {
	'savq/melange-nvim',
	enabled = false,
	priority = 1000,
	config = function()
		vim.cmd.colorscheme('melange')
		vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })
		vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
	end,
}
