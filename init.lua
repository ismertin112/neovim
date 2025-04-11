-- init.luaini
-- Главный конфигурационный файл Neovim

-- [[ Отключение стандартных плагинов (если нужно) ]]
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
-- <<<<<<< ВАЖНО: Определение лидеров ДО lazy.nvim >>>>>>>>>
vim.g.mapleader = " " -- Пробел - самый популярный лидер
vim.g.maplocalleader = "\\" -- Бэкслэш для локального лидера (если нужен)

-- [[ 1. Базовые Настройки (Options) ]]
pcall(require, "core.options")

-- [[ 2. Менеджер Плагинов (lazy.nvim) ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local lazy_repo = "https://github.com/folke/lazy.nvim.git"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazy_repo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
	install = { colorscheme = { "catppuccin", "habamax" } }, -- Добавьте вашу тему
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

-- [[ 3. Горячие Клавиши (Keymaps) ]]
pcall(require, "core.keymaps") -- Загружаем ПОСЛЕ lazy.setup

-- [[ 4. Цветовая Схема (Colorscheme) ]]
-- Загрузка темы теперь должна происходить в конфигурации плагина темы (например, в plugins/theme.lua),
-- чтобы гарантировать, что плагин загружен до попытки установить тему.
-- Если вы не настраивали тему через lazy, можете оставить pcall(require, 'core.colorscheme')
-- pcall(require, 'core.colorscheme') -- Лучше делать в конфиге плагина темы

-- [[ 5. Автокоманды (Autocmds) ]]
-- pcall(require, 'core.autocmds')
