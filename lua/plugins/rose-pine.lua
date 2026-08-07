-- lua/plugins/rose-pine.lua
return {
	'rose-pine/neovim',
	enabled = false, -- ignored; kept for reference
	name = 'rose-pine',
	priority = 1000,
	config = function()
		require('rose-pine').setup({
			variant = 'moon', -- 'auto' | 'main' | 'moon' | 'dawn'
		})
		vim.cmd('colorscheme rose-pine')
	end,
}
