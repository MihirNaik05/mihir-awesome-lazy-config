return {
	'GCBallesteros/jupytext.nvim',
	lazy = false,
	build = function()
		local patch = vim.fn.stdpath('config') .. '/patches/jupytext-nil-metadata.patch'
		local dir = vim.fn.stdpath('data') .. '/lazy/jupytext.nvim'
		local check = vim.fn.system('git -C ' .. vim.fn.shellescape(dir) .. ' apply --check --whitespace=nowarn ' .. vim.fn.shellescape(patch))
		if check == '' then
			vim.fn.system('git -C ' .. vim.fn.shellescape(dir) .. ' apply --whitespace=nowarn ' .. vim.fn.shellescape(patch))
		end
	end,
	config = function()
		require('jupytext').setup({
			style = 'percent',
			output_extension = 'py',
			force_ft = 'python',
		})

		local imb = function(e)
			vim.schedule(function()
				local f = io.open(e.file, 'r')
				if not f then
					return
				end
				local ok, decoded = pcall(vim.json.decode, f:read('a'))
				f:close()
				if not ok or type(decoded) ~= 'table' then
					return
				end

				local kernel_name = nil
				if decoded.metadata and decoded.metadata.kernelspec then
					kernel_name = decoded.metadata.kernelspec.name
				end
				local kernels = vim.fn.MoltenAvailableKernels()
				if not kernel_name or not vim.tbl_contains(kernels, kernel_name) then
					kernel_name = nil
					local venv = os.getenv('VIRTUAL_ENV') or os.getenv('CONDA_PREFIX')
					if venv ~= nil then
						kernel_name = string.match(venv, '/.+/(.+)')
					end
				end
				if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
					vim.cmd(('MoltenInit %s'):format(kernel_name))
					vim.cmd('MoltenImportOutput')
				end
			end)
		end

		vim.api.nvim_create_autocmd('BufAdd', {
			pattern = { '*.ipynb' },
			callback = imb,
		})
		vim.api.nvim_create_autocmd('BufEnter', {
			pattern = { '*.ipynb' },
			callback = function(e)
				if vim.api.nvim_get_vvar('vim_did_enter') ~= 1 then
					imb(e)
				end
			end,
		})
		vim.api.nvim_create_autocmd('BufWritePost', {
			pattern = { '*.ipynb' },
			callback = function()
				if require('molten.status').initialized() == 'Molten' then
					vim.cmd('MoltenExportOutput!')
				end
			end,
		})
	end,
}
