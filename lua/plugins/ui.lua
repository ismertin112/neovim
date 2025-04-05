return {
	-- 🎨 Тема Catppuccin

	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd("colorscheme tokyonight-moon") -- Или tokyonight-storm
		end,
	},

	-- 📊 Статусбар Lualine

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		config = function()
			require("lualine").setup({
				options = {
					theme = "auto",
					icons_enabled = true,
					section_separators = { left = "", right = "" },
					component_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "filename", "🐱 Nyan Cat 🐱" }, -- 🔥 Nyan Cat
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},

	-- 📂 Управление вкладками (Bufferline)
	{
		"akinsho/bufferline.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		config = function()
			require("bufferline").setup({
				options = {
					numbers = "ordinal",
					diagnostics = "nvim_lsp",
					separator_style = "slant",
					show_close_icon = false,
				},
			})
		end,
	},

	-- 🚀 Плавные анимации

	{
		"echasnovski/mini.animate",
		lazy = false,
		config = function()
			require("mini.animate").setup({
				scroll = { enable = false }, -- Без анимации скролла
				resize = { enable = true },
				cursor = { enable = true, duration = 50 },
			})
		end,
	},

	-- 🎭 Улучшенный UI выбора
	{
		"stevearc/dressing.nvim",
		lazy = false,
	},

	-- 🔔 Красивые уведомления
	{
		"rcarriga/nvim-notify",
		lazy = false,
		config = function()
			vim.notify = require("notify")
			require("notify").setup({
				background_colour = "#1e1e2e",
				stages = "fade_in_slide_out",
				timeout = 3000,
			})
		end,
	},

	-- 📢 Улучшенный UI команд
	{
		"folke/noice.nvim",
		lazy = false,
		dependencies = { "MunifTanjim/nui.nvim" },
		config = function()
			require("noice").setup({
				presets = {
					bottom_search = true,
					command_palette = true,
				},
			})
		end,
	},

	-- 🚀 Красивый стартовый экран

	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			-- ⚡ Аниме ASCII-арт (можно заменить)
			dashboard.section.header.val = {
				"⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀",
				"⠀⠀⠀⠀⠀⠀⠀⣠⡾⠛⠉⠀⠈⠙⢷⡀⠀⠀⠀⠀⠀",
				"⠀⠀⠀⠀⠀⠀⣼⠁⠀⠀⢀⡀⠀⠀⠘⣧⠀⠀⠀⠀",
				"⠀⠀⠀⠀⠀⠀⣿⠀⢀⡴⠋⠙⢦⠀⢠⣿⠀⠀⠀⠀",
				"⠀⠀⠀⠀⠀⠀⠻⡄⠘⣷⣄⣀⣾⠇⢠⡟⠀⠀⠀⠀",
				"⠀⠀⠀⠀⠀⠀⠀⠙⢦⡀⠉⠉⠀⣠⡞⠀⠀⠀⠀⠀",
				"⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠶⠶⠋⠀⠀⠀⠀⠀⠀⠀",
			}

			-- Кнопки
			dashboard.section.buttons.val = {
				dashboard.button("e", "📜 Новый файл", ":ene <BAR> startinsert <CR>"),
				dashboard.button("f", "🔍 Поиск файлов", ":Telescope find_files<CR>"),
				dashboard.button("r", "📂 Недавние файлы", ":Telescope oldfiles<CR>"),
				dashboard.button("q", "❌ Выйти", ":qa<CR>"),
			}

			alpha.setup(dashboard.opts)
		end,
	},

	-- 🔑 Подсказки для клавиш
	{
		"folke/which-key.nvim",
		lazy = false,
		config = function()
			require("which-key").setup()
		end,
	},
}
