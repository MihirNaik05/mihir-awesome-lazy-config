-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.cmd.colorscheme('carbonfox')

vim.keymap.set('n','<leader>^','<Cmd>:!latexmk -pdf -pv<CR>')

