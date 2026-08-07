vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", function() require("oil").open() end, { desc = "Oil (files)" })
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Oil parent directory" })
vim.keymap.set("i", "jk", "<Esc>")

