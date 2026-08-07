return {
	'nvim-lualine/lualine.nvim',
	event = 'VeryLazy',
	opts = {
		options = {
			theme = {
				normal   = { a = { fg = '#221710', bg = '#ffc457' }, b = { fg = '#f4d9b3', bg = 'NONE' }, c = { fg = '#f4d9b3', bg = 'NONE' } },
				insert   = { a = { fg = '#221710', bg = '#e8a86b' }, b = { fg = '#f4d9b3', bg = 'NONE' }, c = { fg = '#f4d9b3', bg = 'NONE' } },
				visual   = { a = { fg = '#221710', bg = '#e0704a' }, b = { fg = '#f4d9b3', bg = 'NONE' }, c = { fg = '#f4d9b3', bg = 'NONE' } },
				replace  = { a = { fg = '#f4d9b3', bg = '#c74a00' }, b = { fg = '#f4d9b3', bg = 'NONE' }, c = { fg = '#f4d9b3', bg = 'NONE' } },
				command  = { a = { fg = '#221710', bg = '#ffc457' }, b = { fg = '#f4d9b3', bg = 'NONE' }, c = { fg = '#f4d9b3', bg = 'NONE' } },
				inactive = { a = { fg = '#b09a7c', bg = 'NONE' },      b = { fg = '#b09a7c', bg = 'NONE' }, c = { fg = '#b09a7c', bg = 'NONE' } },
			},
		},
		sections = {
			lualine_a = { 'mode' },
			lualine_b = { 'branch', 'diff', 'diagnostics' },
			lualine_c = { 'filename' },
			lualine_x = { 'filetype' },
		},
	},
}