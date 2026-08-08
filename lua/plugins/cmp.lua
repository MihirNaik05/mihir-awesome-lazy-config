return {
	{
		'hrsh7th/nvim-cmp',
		lazy = false,
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'kdheepak/cmp-latex-symbols',
		},
		config = function()
			local cmp = require('cmp')

			cmp.setup({
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-n>'] = cmp.mapping.select_next_item(),
					['<C-p>'] = cmp.mapping.select_prev_item(),
					['<CR>'] = cmp.mapping.confirm({ select = true }),
					['<C-e>'] = cmp.mapping.abort(),
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'buffer' },
					{ name = 'path' },
					{ name = 'latex_symbols' },
					{ name = 'latex' },
				}),
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
			})

			cmp.register_source('latex', require('cmp_sources.latex').new())

			cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({ { name = 'cmdline' } }, { { name = 'buffer' } }),
			})

			cmp.setup.cmdline('/', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({ { name = 'buffer' } }),
			})
		end,
	},
}
