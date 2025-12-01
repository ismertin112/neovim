-- Entry point for Neovim configuration
-- Sets leader keys, loads core settings, and bootstraps plugins.

if vim.loader and vim.loader.enable then
  vim.loader.enable()
end

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("core.options")
require("core.autocmds")
require("core.lazy")
require("core.keymaps")
