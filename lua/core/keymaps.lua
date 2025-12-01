-- Global keymaps and which-key registrations
local map = vim.keymap.set
local wk = require("which-key")

map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search" })

-- Window management
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

wk.add({
  mode = { "n", "v" },
  { "<leader>e", group = "Explorer" },
  { "<leader>f", group = "Find" },
  { "<leader>g", group = "Git" },
  { "<leader>l", group = "LSP" },
  { "<leader>o", group = "Terminal" },
  { "<leader>q", group = "Session" },
  { "<leader>t", group = "Test" },
  { "<leader>a", group = "AI" },
  { "<leader>c", group = "Code" },
})
