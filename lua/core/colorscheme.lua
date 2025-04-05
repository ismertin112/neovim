-- lua/core/colorscheme.lua
-- Загрузка цветовой схемы

-- Замените "catppuccin" на имя вашей темы, если она другая
local theme = "catppuccin"
-- Или можно использовать вариант для разных версий catppuccin:
-- local theme = "catppuccin-macchiato" -- или latte, frappe, mocha

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. theme)
if not status_ok then
	vim.notify("Цветовая схема " .. theme .. " не найдена!", vim.log.levels.WARN)
	-- Можно попробовать загрузить дефолтную тему в случае ошибки
	-- pcall(vim.cmd, "colorscheme default")
	return
end

print("Colorscheme " .. theme .. " loaded.")
