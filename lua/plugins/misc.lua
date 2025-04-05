-- lua/plugins/misc.lua
-- Различные полезные плагины для улучшения качества жизни

return {
	-- 🔥 Комментирование кода (gc + клавиши)
	{
		"numToStr/Comment.nvim",
		event = "VeryLazy", -- Загружать не сразу, а когда nvim "успокоится"
		opts = {}, -- Используем opts для дефолтной конфигурации
	},

	-- 🔥 Автозакрытие скобок
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter", -- Загружать при первом входе в режим вставки
		opts = {}, -- Используем opts
		-- Дополнительная тонкая настройка, если нужна:
		-- config = function(_, opts)
		--   require("nvim-autopairs").setup(opts)
		--   -- Пример: добавить кастомное правило или отключить для Markdown
		--   local npairs = require("nvim-autopairs")
		--   local Rule = require("nvim-autopairs.rule")
		--   npairs.add_rules({
		--     Rule("$", "$", { "tex", "latex"}), -- Для LaTeX
		--   })
		--   -- Отключить в markdown, если мешает
		--   -- local cmp_autopairs = require('nvim-autopairs.completion.cmp')
		--   -- require('cmp').event:on('confirm_done', cmp_autopairs.on_confirm_done())
		-- end,
	},

	-- 🔥 Быстрое добавление/изменение/удаление парных символов/тегов
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Настройки по умолчанию обычно хороши
				-- keymaps = { -- стандартные бинды: ys, ds, cs
				--   insert = "<C-g>s",
				--   insert_line = "<C-g>S",
				--   normal = "ys",
				--   normal_cur = "yss",
				--   normal_line = "yS",
				--   normal_cur_line = "ySS",
				--   visual = "S",
				--   visual_line = "gS",
				--   delete = "ds",
				--   change = "cs",
				-- }
			})
		end,
	},

	-- 📌 Структура кода (функции, переменные) - Outline
	{
		"simrat39/symbols-outline.nvim",
		cmd = "SymbolsOutline", -- Загружать по команде :SymbolsOutline
		keys = { { "<leader>o", "<cmd>SymbolsOutline<CR>", desc = "Outline Symbols" } }, -- Пример бинда
		opts = {}, -- Используем opts
	},

	-- ✨ Визуальные линии отступов
	{
		"lukas-reineke/indent-blankline.nvim",
		-- Загружаем после основного UI, но до активного редактирования
		event = { "BufReadPost", "BufNewFile" },
		main = "ibl", -- Сокращенное имя для возможного API
		opts = {
			-- Можно настроить внешний вид, например, использовать символы или пробелы
			-- indent = { char = "│" },
			scope = { enabled = true, show_start = true, show_end = true },
			-- exclude = { filetypes = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" } },
		},
	},

	-- 📝 Подсветка TODO, FIXME, NOTE и т.д.
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = { "BufReadPost", "BufNewFile" }, -- Загружать при открытии файла
		opts = {
			-- keywords = { -- Можно кастомизировать ключевые слова и их вид
			--   FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "ISSUE" } },
			--   TODO = { icon = " ", color = "info" },
			--   HACK = { icon = " ", color = "warning" },
			--   WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
			--   PERF = { icon = "󰅒 ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
			--   NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
			-- }
			-- Можно добавить поиск через Telescope
			-- telescope = {},
		},
		-- Опционально: добавить бинды для поиска TODO через Telescope (если настроено)
		-- keys = {
		--   { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO comment" },
		--   { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous TODO comment" },
		--   { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Search TODOs (Telescope)" },
		-- }
	},

	-- 🚀 Улучшенные уведомления и UI команд (если нравится)
	{
		"folke/noice.nvim",
		event = "VeryLazy", -- Noice лучше загружать как можно раньше
		dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" }, -- nvim-notify рекомендуется
		config = function()
			-- Настройте nvim-notify перед noice, если хотите кастомный вид уведомлений
			-- require("notify").setup({ background_colour = "#000000" })

			require("noice").setup({
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **nvim-notify**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				presets = {
					bottom_search = true, -- Поиск внизу экрана? (может конфликтовать с другими плагинами)
					command_palette = true, -- Красивый UI для команд `:`
					long_message_to_split = true, -- Длинные сообщения в сплит
					inc_rename = false, -- Использовать встроенный inc_rename? (можно оставить false)
					lsp_doc_border = true, -- Рамка для LSP документации
				},
				-- Ваши кастомные настройки views
				-- views = {
				--   cmdline_popup = {
				--     position = { row = 5, col = "50%" },
				--     size = { width = 60, height = "auto" },
				--     border = { style = "rounded" },
				--   },
				-- },
				routes = { -- Тонкая настройка, что куда перенаправлять
					{
						filter = { event = "msg_show", kind = "", find = "written" },
						opts = { skip = true }, -- Не показывать "N lines written" через noice
					},
				},
			})
		end,
	},

	-- 🎨 Улучшенные диалоговые окна (например, `input()` и `select()`)
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy", -- Загружать достаточно рано, чтобы перехватить UI
		opts = {
			-- select = { -- Можно выбрать бекенд (если установлен telescope или fzf-lua)
			--   backend = { "telescope", "fzf_lua", "fzf", "builtin" },
			-- }
		},
	},
}
