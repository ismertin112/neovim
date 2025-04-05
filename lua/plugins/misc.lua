return {
	-- 🔥 Комментирование кода (gc + клавиши)
	{
		"numToStr/Comment.nvim",
		lazy = false,
		config = function()
			require("Comment").setup()
		end,
	},

	-- 🔥 Автозакрытие скобок
	{
		"windwp/nvim-autopairs",
		lazy = false,
		config = function()
			require("nvim-autopairs").setup({})
		end,
	},

	-- 📌 Структура кода (функции, переменные)
	{
		"simrat39/symbols-outline.nvim",
		lazy = false,
		config = function()
			require("symbols-outline").setup()
		end,
	},

	-- 🚀 Улучшенные уведомления и UI команд
	{
		"folke/noice.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		lazy = false,
		config = function()
			require("noice").setup({
				presets = {
					bottom_search = true, -- Поиск внизу экрана
					command_palette = true, -- Красивый UI для команд
				},
				views = {
					cmdline_popup = {
						position = { row = 5, col = "50%" },
						size = { width = 60, height = "auto" },
						border = { style = "rounded" },
					},
				},
			})
		end,
	},

	-- 🎨 Улучшенные диалоговые окна (например, `input()` и `select()`)
	{
		"stevearc/dressing.nvim",
		lazy = false,
	},
}
