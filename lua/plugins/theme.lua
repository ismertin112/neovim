-- lua/plugins/theme.lua
return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000, -- Важно, чтобы тема загружалась одной из первых
		config = function()
			require("catppuccin").setup({
				-- ваши настройки catppuccin, если есть
				flavour = "macchiato", -- or latte, frappe, mocha
				-- ...
			})
			-- Загружаем тему ПОСЛЕ setup
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
