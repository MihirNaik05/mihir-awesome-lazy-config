vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", function() require("oil").open() end, { desc = "Oil (files)" })
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Oil parent directory" })
vim.keymap.set("i", "jk", "<Esc>l")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

vim.keymap.set("n", "<C-s>", "<cmd>update<CR>", {silent = true})
vim.keymap.set("v", "<C-s>", "<cmd>update<CR>", {silent = true})
vim.keymap.set("i", "<C-s>", "<cmd>update<CR>", {silent = true})
