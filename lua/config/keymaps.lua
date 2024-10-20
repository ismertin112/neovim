-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

--Удаление предыдущего слова
keymap.set("n", "dw", "vb_d")

--Выделение всего слова
keymap.set("n", "<C-a>", "gg<S-v>G")

--перелистывание табов
keymap.set("n", "<C-m>", "<C-i>", opts)

keymap.set("n", "te", "tabedit", opts)
keymap.set("n", "<tab>", ":tabnext<Return>", opts)
keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
