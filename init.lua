-- Лидер-клавиша (пробел)
vim.g.mapleader = " "
_G.vim = vim

-- Подключаем Lazy.nvim (менеджер плагинов)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Загружаем плагины
require("lazy").setup("plugins")

-- Автоформат перед сохранением
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		vim.lsp.buf.format({ timeout_ms = 2000 })
	end,
})

-- Основные настройки
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.mouse = "a"
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.api.nvim_set_option("pumblend", 15) -- Полупрозрачность меню автодополнения
vim.api.nvim_set_option("winblend", 15) -- Полупрозрачность всплывающих окон
vim.o.hlsearch = true
vim.cmd("highlight Search guifg=#ffffff guibg=#ff007c gui=bold")
vim.cmd("highlight IncSearch guifg=#ffffff guibg=#ff007c gui=bold")
vim.o.number = true -- Показывать номера строк
vim.o.relativenumber = false -- ❌ Отключаем относительную нумерацию
-- GitLab CI
vim.api.nvim_create_autocmd("BufRead", {
	pattern = ".gitlab-ci.yml",
	command = "set filetype=yaml.gitlab",
})

-- Ansible (все файлы playbook-*)
vim.api.nvim_create_autocmd("BufRead", {
	pattern = "playbook*.yml",
	command = "set filetype=yaml.ansible",
})

-- Kubernetes (если файл внутри `k8s/`)
vim.api.nvim_create_autocmd("BufRead", {
	pattern = "k8s/*.yml",
	command = "set filetype=yaml.kubernetes",
})

-- Docker Compose (если файл называется `docker-compose.yml`)
vim.api.nvim_create_autocmd("BufRead", {
	pattern = "docker-compose.yml",
	command = "set filetype=yaml.docker-compose",
})

vim.cmd([[
  augroup CursorLine
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd InsertEnter * highlight CursorLine guibg=#313244
    autocmd InsertLeave * highlight CursorLine guibg=#1e1e2e
  augroup END
]])

vim.opt.guicursor = "n-v-c:block,i-ci:ver25,r-cr:hor20,o:hor50"

vim.cmd("highlight WinSeparator guifg=#ff007c gui=bold")
vim.o.fillchars = "vert:┃"
local border = "rounded"
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	command = "if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif",
})

-- Улучшенная навигация
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Файловый менеджер" })
vim.keymap.set("n", "<leader>r", "<cmd>NvimTreeRefresh<CR>", { desc = "Обновить дерево" })
vim.keymap.set("n", "<leader>n", "<cmd>NvimTreeFindFile<CR>", { desc = "Показать текущий файл" })

-- Сохранение файла
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR>", { desc = "Сохранить файл" })

-- Улучшенный поиск (Telescope)
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Поиск файлов" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Глобальный поиск" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Буферы" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Помощь" })

-- Git интеграция
vim.keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Git commits" })
vim.keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Git branches" })

-- Markdown Preview
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreview<CR>", { desc = "📜 Markdown Preview" })

-- Терминал (ToggleTerm)
vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm<CR>", { desc = "📌 Открыть терминал" })

-- Ошибки и диагностика (Trouble)
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<CR>", { desc = "🚨 Открыть Trouble" })

-- Перезагрузка Neovim
vim.keymap.set("n", "<leader>rr", "<cmd>source $MYVIMRC<CR>", { desc = "🔄 Перезагрузить конфиг" })
local map = vim.keymap.set

-- 📂 Работа с проектами
map("n", "<leader>pp", "<cmd>Telescope project<CR>", { desc = "📂 Открыть проекты" })

-- 🔍 GIT
map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "🔍 Открыть DiffView" })
-- 📌 Терминал
map("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "📌 Открыть терминал" })
map("t", "<Esc>", "<C-\\><C-n>", { desc = "🚪 Выйти из терминала" })

-- 🚀 Поиск
map("n", "<leader>sp", "<cmd>Telescope live_grep<CR>", { desc = "🔍 Поиск текста в проекте" })
map("n", "<leader>sf", "<cmd>Telescope find_files<CR>", { desc = "📂 Поиск файлов" })

-- 🚨 Уведомления
map("n", "<leader>un", "<cmd>Noice history<CR>", { desc = "📜 История уведомлений" })
vim.keymap.set(
	"v",
	"<leader>re",
	":Refactor extract<CR>",
	{ desc = "🛠 Вынести в новую функцию" }
)
vim.keymap.set("v", "<leader>rv", ":Refactor extract_var<CR>", { desc = "📌 Вынести в переменную" })
vim.keymap.set("n", "<leader>o", "<cmd>SymbolsOutline<CR>", { desc = "📑 Открыть Symbols Outline" })
vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "⚡ Code Action" })
vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "📜 Hover Documentation" })
vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", { desc = "🔍 Go To Definition" })
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<CR>", { desc = "🚨 Открыть Trouble" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true }) -- Влево
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true }) -- Вниз
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true }) -- Вверх
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true }) -- Вправо

vim.api.nvim_set_keymap("n", "<leader>gp", ":!glab ci list<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gr", ":!glab ci run<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gs", ":!glab ci status<CR>", { noremap = true, silent = true })

-- 📌 Symbols Outline (структура кода)
vim.keymap.set(
	"n",
	"<leader>o",
	":SymbolsOutline<CR>",
	{ noremap = true, silent = true, desc = "📑 Открыть Symbols Outline" }
)

-- 🔥 Комментирование (Comment.nvim)
vim.keymap.set("n", "<leader>/", "gcc", { noremap = false, desc = "Закомментировать строку" })
vim.keymap.set(
	"v",
	"<leader>/",
	"gc",
	{ noremap = false, desc = "Закомментировать выделение" }
)

-- 🚀 Noice (история уведомлений)
vim.keymap.set(
	"n",
	"<leader>un",
	":Noice history<CR>",
	{ noremap = true, silent = true, desc = "📜 История уведомлений" }
)
