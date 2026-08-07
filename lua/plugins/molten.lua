return {
	'benlubas/molten-nvim',
	build = ':UpdateRemotePlugins',
	config = function()
		vim.g.molten_virt_text_output = true
		vim.g.molten_virt_lines_off_by_1 = true
		vim.g.molten_wrap_output = true
		vim.g.molten_auto_open_output = false
		vim.g.molten_tick_rate = 200

		vim.keymap.set('n', '<leader>mi', ':MoltenInit<CR>', { silent = true, desc = 'Molten init kernel' })
		vim.keymap.set('n', '<leader>ml', ':MoltenEvaluateLine<CR>', { silent = true, desc = 'Molten run line' })
		vim.keymap.set('n', '<leader>mc', ':MoltenReevaluateCell<CR>', { silent = true, desc = 'Molten run cell' })
		vim.keymap.set('v', '<leader>mr', ':<C-u>MoltenEvaluateVisual<CR>gv', { silent = true, desc = 'Molten run visual' })
		vim.keymap.set('n', '<leader>me', ':MoltenEvaluateOperator<CR>', { silent = true, desc = 'Molten run operator' })
		vim.keymap.set('n', '<leader>md', ':MoltenDelete<CR>', { silent = true, desc = 'Molten delete cell' })
		vim.keymap.set('n', '<leader>mo', ':noautocmd MoltenEnterOutput<CR>', { silent = true, desc = 'Molten open output' })
		vim.keymap.set('n', '<leader>mh', ':MoltenHideOutput<CR>', { silent = true, desc = 'Molten hide output' })
	end,
}
