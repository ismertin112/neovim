-- Entry point for Neovim configuration
-- Sets leader keys, loads core settings, and bootstraps plugins.

if vim.loader and vim.loader.enable then
  vim.loader.enable()
end

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

require("core.options")
require("core.autocmds")
require("core.lazy")
require("core.keymaps")
