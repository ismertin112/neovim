-- lua/plugins/lsp.lua
-- Этот файл объявляет плагины, связанные с LSP,
-- и плагины, улучшающие взаимодействие с LSP и отображение его данных.
-- Основная конфигурация самих LSP серверов находится в lua/plugins/mason.lua

return {
	-- 1. Зависимость для работы с JSON схемами (для yamlls, jsonls)
	{
		"b0o/SchemaStore.nvim",
		event = "VeryLazy", -- Загрузить, когда понадобится LSP серверу
	},

	-- 2. Сам LSP config (настройка в mason.lua)
	{
		"neovim/nvim-lspconfig",
		event = "VeryLazy", -- Загружаем не сразу
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp", -- Для capabilities
			"b0o/SchemaStore.nvim", -- Явная зависимость
			-- Добавляем зависимости для плагинов ниже, чтобы они загружались корректно
			"nvim-tree/nvim-web-devicons", -- Для иконок в trouble и navic
			"nvim-lua/plenary.nvim", -- Часто используется другими плагинами
		},
		-- КОНФИГУРАЦИЯ УДАЛЕНА - она теперь в mason.lua
		-- Но здесь можно определить глобальные настройки lspconfig, если нужно
		-- config = function()
		--   vim.diagnostic.config({ virtual_text = false }) -- Пример: отключить виртуальный текст для ошибок
		-- end,
	},

	-- 3. Улучшенный интерфейс для диагностики (ошибок, предупреждений)
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- Для иконок
		cmd = { "TroubleToggle", "Trouble" }, -- Загружать по команде
		opts = {
			position = "bottom", -- Позиция окна (bottom, left, right)
			height = 10, -- Высота для bottom
			width = 50, -- Ширина для left/right
			icons = true, -- Использовать иконки
			mode = "workspace_diagnostics", -- По умолчанию ошибки всего проекта
			use_diagnostic_signs = true, -- Использовать значки на полях (может конфликтовать с gitsigns)
			auto_close = false, -- Не закрывать автоматически
			auto_preview = true, -- Предпросмотр кода при навигации
		},
		-- !! Не забудьте добавить кейбинды в lua/core/keymaps.lua !!
		-- keys = {
		--   { "<leader>xx", "<cmd>TroubleToggle<cr>", desc = "Trouble Toggle" },
		--   { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
		--   { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
		--   { "gR", "<cmd>TroubleToggle lsp_references<cr>", desc = "LSP References (Trouble)" },
		-- }
	},

	-- 4. Контекст кода (breadcrumbs) в статус-баре (требует настройки lualine)
	{
		"SmiteshP/nvim-navic",
		dependencies = { "neovim/nvim-lspconfig", "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy", -- Загружать после LSP
		opts = {
			lsp = {
				auto_attach = true,
				preference = nil,
			},
			highlight = true,
			separator = " > ",
			depth_limit = 5,
			-- icons = require("core.icons").lsp, -- Используйте ваши иконки, если настроены
			click = true, -- Позволяет кликать по элементам (если поддерживается терминалом/UI)
		},
		-- !! Не забудьте добавить 'navic' в конфигурацию lualine (lua/plugins/lualine.lua) !!
		-- Пример для lualine:
		-- sections = { lualine_c = { {'filename'}, {'navic', color_correction='static'} } }
	},

	-- 5. Ненавязчивые уведомления о статусе LSP (загрузка, индексация)
	{
		"j-hui/fidget.nvim",
		-- Используйте 'legacy' для стабильной версии 1.x (рекомендуется).
		-- Если хотите новейшую версию 2.x (API может измениться), используйте tag = "v2.0.0" или branch = "main".
		tag = "legacy",
		event = "LspAttach", -- Загружать только когда LSP реально подключается
		opts = {
			-- Настройки внешнего вида и поведения
			text = {
				spinner = "dots", -- Стиль спиннера загрузки
			},
			window = {
				winblend = 0, -- Прозрачность окна уведомлений (0 = непрозрачное)
				relative = "editor", -- Позиционировать относительно редактора
			},
			-- Отключение некоторых LSP клиентов, если они слишком шумные
			-- client = { ignore = { "ruff_lsp", ... } }
		},
	},

	-- 6. Интерактивное переименование LSP символов
	{
		"smjonas/inc-rename.nvim",
		cmd = "IncRename", -- Загружать по команде :IncRename
		config = function()
			require("inc_rename").setup({
				-- input_buffer_type = "dressing", -- Использовать dressing.nvim для ввода (если установлен)
				preview_highlight_group = "Visual", -- Группа подсветки для предпросмотра
			})
			-- !! Не забудьте обновить кейбинд <leader>rn в lua/core/keymaps.lua !!
			-- Пример:
			-- vim.keymap.set("n", "<leader>rn", "<cmd>IncRename<CR>", { desc = "Incremental Rename" })
		end,
	},
} -- Конец return
