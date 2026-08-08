return {
	'stevearc/oil.nvim',
	lazy = false,
	dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
	opts = {
		default_file_explorer = true,
		delete_to_trash = true,
		skip_confirm_for_simple_edits = true,
		watch_for_changes = true,
		columns = { 'icon' },
		keymaps = {
			['<leader>.'] = 'actions.toggle_hidden',
		},
		confirmation = { border = 'rounded' },
		preview_win = { update_on_cursor_moved = true },
		view_options = { show_hidden = false, natural_order = 'fast' },
	},
}
