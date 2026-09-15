return {
	{
		'lervag/vimtex',
		lazy = false,
		init = function()
			vim.g.vimtex_view_automatic = 0
			vim.g.vimtex_compiler_method = 'latexmk'
		end,
		build = function()
			local patch = vim.fn.stdpath('config') .. '/patches/vimtex-compiler-clash-guard.patch'
			local dir = vim.fn.stdpath('data') .. '/lazy/vimtex'
			local check = vim.fn.system('git -C ' .. vim.fn.shellescape(dir) .. ' apply --check --whitespace=nowarn ' .. vim.fn.shellescape(patch))
			if check == '' then
				vim.fn.system('git -C ' .. vim.fn.shellescape(dir) .. ' apply --whitespace=nowarn ' .. vim.fn.shellescape(patch))
			end
		end,
	},
}
