-- Core editor options
local opt = vim.opt

-- UI
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 6
opt.sidescrolloff = 8
opt.showmode = false
opt.splitbelow = true
opt.splitright = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Editing
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true
opt.autoindent = true
opt.smartcase = true
opt.ignorecase = true
opt.incsearch = true
opt.hlsearch = true
opt.clipboard = "unnamedplus"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.timeoutlen = 500
opt.updatetime = 300
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undodir"
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.conceallevel = 2
opt.pumheight = 12
opt.confirm = true

-- Files & encoding
opt.fileencoding = "utf-8"
opt.mouse = "a"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- Create undo directory if missing
pcall(vim.fn.mkdir, opt.undodir:get(), "p")

-- Compatibility shim for plugins still calling the deprecated
-- vim.lsp.buf_get_clients() helper. The function will be removed in
-- Neovim 0.12, so delegate calls to the modern replacement.
if vim.lsp and vim.lsp.get_clients then
  vim.lsp.buf_get_clients = function(...)
    return vim.lsp.get_clients(...)
  end
end
