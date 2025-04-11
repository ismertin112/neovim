-- lua/plugins/ui.lua (Шаг 2: Тема + Иконки + Lualine + Bufferline)
return {

	-- ----------------------------------
	-- ОСНОВА: ТЕМА И ИКОНКИ
	-- ----------------------------------

	{
		"catppuccin/nvim",
		lazy = false,
		name = "catppuccin",
		priority = 1000,
		opts = {
			flavour = "mocha",
			term_colors = true,
			-- ЯВНО НЕ ВКЛЮЧАЕМ ИНТЕГРАЦИИ ЗДЕСЬ, ЧТОБЫ ИЗБЕЖАТЬ ОШИБОК
			integrations = {
				-- lualine = true, -- Закомментировано
				-- bufferline = true, -- Тоже НЕ включаем здесьminic
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin")
		end,
	},

	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
	},

	-- ----------------------------------
	-- СТАТУСНАЯ СТРОКА И ВКЛАДКИ
	-- ----------------------------------

	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-web-devicons" },
		opts = {
			options = {
				theme = "catppuccin", -- ... остальное как было ...
				icons_enabled = true,
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
				disabled_filetypes = { statusline = { "dashboard", "NvimTree", "alpha", "neotree" } },
				globalstatus = true,
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = { lualine_c = { { "filename", path = 1 } }, lualine_x = { "location" } },
			extensions = { "nvim-tree", "neo-tree", "lazy" },
		},
		config = function(_, opts)
			require("lualine").setup(opts)
		end,
	},

	-- [[ НОВЫЙ ПЛАГИН: BUFFERLINE ]]
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-web-devicons" },
		opts = {
			options = {
				-- Цвета должны наследоваться от темы Catppuccin автоматически
				-- или можно явно задать Catppuccin, если есть такая опция в bufferline
				numbers = "ordinal", -- Номера буферов (1st, 2nd, ...)
				diagnostics = "nvim_lsp", -- Показывать индикаторы диагностики LSP
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					if level ~= "error" and level ~= "warning" then
						return ""
					end
					local s = " "
					for e, n in pairs(diagnostics_dict) do
						local icon = level == "error" and " " or " "
						s = s .. n .. icon
					end
					return s
				end,
				separator_style = "slant", -- Популярный стиль
				show_buffer_close_icons = false,
				show_close_icon = false,
				-- Отступ для файлового дерева (если используете)
				offsets = {
					{ filetype = "NvimTree", text = "󰙅 Explorer", text_align = "left", separator = true },
					{ filetype = "neo-tree", text = "󰙅 Explorer", text_align = "left", separator = true },
				},
			},
		},
		config = function(_, opts)
			require("bufferline").setup(opts)
		end,
	},

	-- [[ НОВЫЙ ПЛАГИН: INDENT-BLANKLINE ]]
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "VeryLazy",
		main = "ibl", -- Ускоряем загрузку
		opts = {
			-- Настроим цвета вручную, т.к. интеграция пока выключена
			-- Можно получить цвета из Catppuccin:
			-- local colors = require("catppuccin.palettes").get_palette()
			indent = {
				char = "│", -- Символ линии отступа
				-- highlight = {"IblIndent", "Whitespace"}, -- Группы подсветки
			},
			scope = {
				enabled = true,
				show_start = true,
				show_end = false,
				-- highlight = "IblScope", -- Группа подсветки контекста
			},
			exclude = {
				filetypes = { "help", "alpha", "dashboard", "neo-tree", "nvim-tree", "lazy", "mason" },
				buftypes = { "terminal", "nofile" },
			},
		},
		config = function(_, opts)
			-- Настроим цвета вручную здесь
			local colors = require("catppuccin.palettes").get_palette()
			vim.api.nvim_set_hl(0, "IblIndent", { fg = colors.surface1 }) -- Цвет линий
			vim.api.nvim_set_hl(0, "IblScope", { fg = colors.mauve }) -- Цвет контекста scope
			require("ibl").setup(opts)
		end,
	},

	-- [[ НОВЫЙ ПЛАГИН: FOCUS.NVIM ]]
	{
		"nvim-focus/focus.nvim",
		version = "*",
		event = "VeryLazy",
		opts = {
			enable = true,
			autoresize = { enable = true, width_ratio = 0.7, height_ratio = 0.7 },
			split = { focus_new = true, resize_new = true },
			winopts = {
				-- Здесь можно добавить настройки для неактивных окон,
				-- но пока оставим стандартные (обычно затемнение фона)
			},
		},
		config = function(_, opts)
			require("focus").setup(opts)
		end,
	},
	-- ----------------------------------
	-- УЛУЧШЕНИЕ ИНТЕРФЕЙСА ВЗАИМОДЕЙСТВИЯ
	-- ----------------------------------

	-- [[ НОВЫЙ ПЛАГИН: DRESSING.NVIM ]]
	-- Назначение: Заменяет стандартные, довольно простые интерфейсы Neovim
	-- для выбора (`vim.ui.select`) и ввода (`vim.ui.input`) на более красивые
	-- и функциональные, используя бэкенды типа Telescope, FZF или улучшенный встроенный UI.
	-- Пример: Когда LSP предлагает вам выбрать Code Action, вместо простого текстового меню
	-- появится красивое окно (например, от Telescope), если он установлен.
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		opts = {
			select = {
				-- Порядок предпочтения бэкендов для vim.ui.select()
				-- Если установлен Telescope, будет использовать его. Иначе FZF, иначе встроенный.
				backend = { "telescope", "fzf", "builtin" },
				-- Настройки для конкретных бэкендов:
				telescope = { -- Опции для Telescope в качестве UI выбора
					-- theme = "dropdown", -- Можно задать тему Telescope, если хотите
				},
				builtin = { -- Опции для улучшенного встроенного UI
					relative = "editor", -- Расположение окна
					border = "rounded", -- Стиль рамки
					-- Другие опции для настройки внешнего вида...
				},
			},
			input = {
				-- Для vim.ui.input() обычно лучше оставить встроенный режим
				backend = { "builtin" },
				insert_only = false, -- Разрешить редактирование введенного текста в Normal режиме
				relative = "cursor", -- Позиция окна ввода
				border = "rounded",
				-- title_pos = "center", -- Позиция заголовка
			},
		},
		config = function(_, opts)
			require("dressing").setup(opts)
		end,
	},

	-- [[ НОВЫЙ ПЛАГИН: NVIM-NOTIFY ]]
	-- Назначение: Предоставляет красивую и настраиваемую замену для стандартных
	-- уведомлений Neovim (`vim.notify`). Показывает сообщения (например, от LSP,
	-- плагинов или ваши собственные) во всплывающих окнах с анимацией и таймаутом.
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim", "rcarriga/nvim-notify" },
		config = function()
			-- Настроим цвета вручную через highlight группы
			local colors = require("catppuccin.palettes").get_palette()
			vim.api.nvim_set_hl(0, "NotifyERRORBorder", { fg = colors.red })
			vim.api.nvim_set_hl(0, "NotifyWARNBorder", { fg = colors.yellow })
			vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = colors.sky })
			vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { fg = colors.overlay1 })
			vim.api.nvim_set_hl(0, "NotifyTRACEBorder", { fg = colors.teal })

			vim.api.nvim_set_hl(0, "NotifyERRORTitle", { fg = colors.red })
			vim.api.nvim_set_hl(0, "NotifyWARNTitle", { fg = colors.yellow })
			vim.api.nvim_set_hl(0, "NotifyINFOTitle", { fg = colors.sky })
			vim.api.nvim_set_hl(0, "NotifyDEBUGTitle", { fg = colors.overlay1 })
			vim.api.nvim_set_hl(0, "NotifyTRACETitle", { fg = colors.teal })

			vim.api.nvim_set_hl(0, "NotifyERRORIcon", { fg = colors.red })
			vim.api.nvim_set_hl(0, "NotifyWARNIcon", { fg = colors.yellow })
			vim.api.nvim_set_hl(0, "NotifyINFOIcon", { fg = colors.sky })
			vim.api.nvim_set_hl(0, "NotifyDEBUGIcon", { fg = colors.overlay1 })
			vim.api.nvim_set_hl(0, "NotifyTRACEIcon", { fg = colors.teal })

			-- Настройка самого плагина
			require("notify").setup({
				-- Цвета фона и текста обычно берутся из темы, но можно переопределить
				-- background_colour = colors.base,
				stages = "fade_in_slide_out", -- Анимация появления/исчезновения
				timeout = 3000, -- Время показа по умолчанию (в мс)
				max_height = function()
					return math.floor(vim.o.lines * 0.75)
				end,
				max_width = function()
					return math.floor(vim.o.columns * 0.75)
				end,
				render = "default", -- Стиль отображения: "default", "compact", "minimal"
				minimum_width = 50,
				-- Иконки для уровней уведомлений
				icons = {
					ERROR = "", -- fa-times-circle
					WARN = "", -- fa-exclamation-triangle
					INFO = "", -- fa-info-circle
					DEBUG = "", -- fa-bug
					TRACE = "✎", -- fa-pencil / alt: 
				},
			})
			-- Устанавливаем Notify как обработчик по умолчанию
			vim.notify = require("notify")
		end,
	},

	{
		"echasnovski/mini.clue",
		-- Используем VeryLazy, так как он, похоже, заработал
		event = "VeryLazy",
		-- lazy = false, -- Можно вернуть VeryLazy
		opts = function() -- Используем функцию для opts
			local MiniClue = require("mini.clue")
			return {
				triggers = {
					-- Ваши триггеры
					{ mode = "n", keys = "<leader>" },
					{ mode = "x", keys = "<leader>" },
					{ mode = "n", keys = "g" },
					{ mode = "n", keys = "z" },
					{ mode = "n", keys = "[" }, -- Добавляем другие триггеры, если нужны
					{ mode = "n", keys = "]" },
					-- { mode = 'n', keys = "'" },
					-- { mode = 'n', keys = "`" },
					-- { mode = 'n', keys = '"' },
				},
				clues = {
					-- [[ ВОЗВРАЩАЕМ ГЕНЕРАТОРЫ ]]
					-- Сначала ваши маппинги с desc (они подхватятся автоматически)

					-- Затем стандартные команды Vim
					MiniClue.gen_clues.builtin_completion(), -- Для <C-x> в insert mode
					MiniClue.gen_clues.g(),
					MiniClue.gen_clues.marks(),
					MiniClue.gen_clues.registers(),
					MiniClue.gen_clues.windows(), -- Команды <C-w> ...
					MiniClue.gen_clues.z(), -- Команды z...
				},
				window = {
					delay = 100, -- Можно вернуть меньшую задержку
					config = {
						border = "rounded",
						zindex = 100,
					},
				},
				hide_on_press = true,
				hide_on_move = true,
			}
		end,
		config = function(_, opts)
			require("mini.clue").setup(opts)
			print("mini.clue setup finished (with gen_clues).")
		end,
	},

	{
		"goolord/alpha-nvim",
		event = "VimEnter", -- Запускать только при входе в nvim без файлов
		dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
		config = function()
			-- Обернем все в pcall для надежности
			local ok, alpha_status = pcall(function()
				local alpha = require("alpha")
				local dashboard = require("alpha.themes.dashboard")

				-- Безопасно получаем палитру Catppuccin
				local colors = vim.deepcopy(require("catppuccin.palettes").get_palette())
				if not colors then
					vim.notify("[Alpha] Catppuccin palette not found, using fallback colors.", vim.log.levels.WARN)
					colors = {
						blue = "#89b4fa",
						sky = "#89dceb",
						mauve = "#cba6f7",
						flamingo = "#f0c6c6",
						text = "#cdd6f4",
						mantle = "#181825",
					}
				end

				-- Настраиваем группы подсветки
				vim.api.nvim_set_hl(0, "AlphaHeader", { fg = colors.blue, bold = true })
				vim.api.nvim_set_hl(0, "AlphaButtons", { fg = colors.sky })
				vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = colors.mauve })
				vim.api.nvim_set_hl(0, "AlphaFooter", { fg = colors.flamingo, italic = true })

				-- ASCII Арт (Замените на свой)
				dashboard.section.header.val = {
					[[                                                 ]],
					[[ ██╗  ██╗███████╗ ██████╗ ██╗   ██╗██╗███████╗███████╗ ]],
					[[ ██║  ██║██╔════╝██╔═══██╗██║   ██║██║██╔════╝██╔════╝ ]],
					[[ ███████║█████╗  ██║   ██║██║   ██║██║███████╗███████╗ ]],
					[[ ██╔══██║██╔══╝  ██║   ██║██║   ██║██║╚════██║╚════██║ ]],
					[[ ██║  ██║███████╗╚██████╔╝╚██████╔╝██║███████║███████║ ]],
					[[ ╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝╚══════╝╚══════╝ ]],
					[[                                  Version: ]]
						.. vim.version().major
						.. "."
						.. vim.version().minor,
					[[                                                 ]],
				}
				dashboard.section.header.opts.hl = "AlphaHeader"

				-- Кнопки
				dashboard.section.buttons.val = {
					dashboard.button("e", "󰙅  New File", ":ene <BAR> startinsert <CR>"),
					dashboard.button("f", "󰍉  Find File", ":Telescope find_files <CR>"),
					dashboard.button("g", "󰊄  Find Text", ":Telescope live_grep <CR>"),
					dashboard.button("r", "󰁯  Recent Files", ":Telescope oldfiles <CR>"),
					dashboard.button("c", "  Config", ":e $MYVIMRC <CR>"),
					dashboard.button("l", "󰒲  Lazy Sync", ":Lazy sync <CR>"),
					dashboard.button("q", "󰅚  Quit", ":qa<CR>"),
				}
				dashboard.section.buttons.opts.hl = "AlphaButtons"
				dashboard.section.buttons.opts.key_hl = "AlphaShortcut"
				dashboard.section.buttons.opts.keymap_opts = { noremap = true, silent = true }

				-- Подвал (с безопасным вызовом fortune)
				dashboard.section.footer.val = function()
					local footer_text = "Have a beautiful day!" -- Текст по умолчанию
					-- Убедитесь, что fortune установлен: sudo pacman -S fortune-mod
					local fortune_ok, fortune_output = pcall(io.popen, "fortune -s")
					if fortune_ok and fortune_output then
						local fortune_text = fortune_output:read("*a")
						fortune_output:close()
						if fortune_text then
							fortune_text = fortune_text:gsub("^%s+", ""):gsub("%s+$", ""):gsub("[\r\n]+", " ")
							if #fortune_text > 0 then
								footer_text = fortune_text
							end
						end
					else
						-- Не выводим ошибку, если fortune просто не установлен
						-- vim.notify("[Alpha] Failed to execute 'fortune -s'.", vim.log.levels.WARN)
					end
					return footer_text
				end
				dashboard.section.footer.opts.hl = "AlphaFooter"

				-- Применяем настройки
				alpha.setup(dashboard.opts)

				-- Автокоманда для ресайза
				vim.api.nvim_create_autocmd("VimResized", {
					pattern = "*",
					callback = function()
						if vim.bo.filetype == "alpha" then
							alpha.redraw()
						end
					end,
					group = vim.api.nvim_create_augroup("AlphaResize", { clear = true }),
				})
			end) -- Конец pcall

			if not ok then
				vim.notify("Error configuring alpha-nvim: " .. tostring(alpha_status), vim.log.levels.ERROR)
			else
			end
		end, -- Конец config функции
	},
}
