-- lua/plugins/neo-tree.lua
return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x", -- Используем стабильную ветку v3
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- Иконки файлов (обязательно!)
		"MunifTanjim/nui.nvim", -- Компонент UI
		-- Опционально для доп. интеграций:
		-- "3rd/image.nvim", -- Предпросмотр изображений
		-- "sindrets/diffview.nvim", -- Интеграция с Diffview
	},
	cmd = "Neotree", -- Загружать по команде
	keys = {
		-- Определяем кейбинд для открытия/закрытия прямо здесь
		{
			"<leader>e",
			function()
				require("neo-tree.command").execute({ toggle = true })
			end,
			desc = "NeoTree Toggle Filesystem",
			mode = "n",
		},
		-- Можно добавить другие бинды, например, для открытия с фокусом на текущем файле
		{
			"<leader>fe",
			function()
				require("neo-tree.command").execute({ toggle = true, reveal = true })
			end,
			desc = "NeoTree Reveal",
			mode = "n",
		},
		-- Или для открытия дерева буферов / git status
		-- { "<leader>fb", function() require("neo-tree.command").execute({ toggle = true, source = "buffers" }) end, desc = "NeoTree Buffers", mode="n"},
		-- { "<leader>fg", function() require("neo-tree.command").execute({ toggle = true, source = "git_status" }) end, desc = "NeoTree Git Status", mode="n"},
	},
	opts = {
		-- Настройки по умолчанию обычно хороши, но можно переопределить
		close_if_last_window = true, -- Закрывать neo-tree, если это последнее окно
		popup_border_style = "rounded",
		enable_git_status = true,
		enable_diagnostics = true,
		default_component_configs = { -- Настройка отображения
			indent = { indent_size = 2 },
			icon = { default = "?", folder_closed = "", folder_open = "" }, -- Пример иконок
			git_status = { symbols = { added = "A", modified = "M", deleted = "D", ... } },
		},
		window = {
			position = "left", -- Позиция (left, right, float)
			width = 30, -- Ширина панели
			mapping_options = {
				noremap = true,
				nowait = true,
			},
			mappings = { -- Кейбинды внутри окна neo-tree
				["<space>"] = false, -- Отключить стандартный бинд пробела (часто конфликтует)
				["<cr>"] = "open",
				["o"] = "open",
				["<esc>"] = "cancel", -- Закрыть окно по Esc
				["P"] = { "toggle_preview", config = { use_float = true } }, -- Предпросмотр во всплывающем окне
				["l"] = "focus_preview",
				["S"] = "open_split",
				["s"] = "open_vsplit",
				-- ["t"] = "open_tabnew", -- Открыть в новой вкладке
				["a"] = "add",
				["A"] = "add_directory",
				["d"] = "delete",
				["r"] = "rename",
				["y"] = "copy_to_clipboard",
				["x"] = "cut_to_clipboard",
				["p"] = "paste_from_clipboard",
				["c"] = "copy", -- Внутреннее копирование neo-tree
				["m"] = "move",
				["q"] = "close_window",
				["R"] = "refresh",
				["?"] = "show_help",
				["<"] = "prev_source", -- Переключиться на предыдущий источник (файлы/буферы/git)
				[">"] = "next_source", -- Переключиться на следующий источник
				["H"] = "toggle_hidden", -- Показать/скрыть скрытые файлы
				--["gf"] = "goto_parent_dir", -- Перейти в родительскую директорию
				-- ... добавьте свои или переопределите стандартные
			},
		},
		filesystem = { -- Настройки для источника filesystem
			filtered_items = {
				visible = false, -- Показывать скрытые файлы по умолчанию?
				hide_dotfiles = false,
				hide_gitignored = true,
				hide_hidden = false, -- Показывает файлы, скрытые самой ОС (не рекомендуется менять)
				-- hide_by_name = { ".git", "node_modules" }, -- Можно скрыть специфичные папки
				never_show = { ".DS_Store", "thumbs.db" },
			},
			follow_current_file = { -- Синхронизировать дерево с текущим файлом
				enabled = true,
				leave_dirs_open = false,
			},
			hijack_netrw_behavior = "open_current", -- Заменить стандартный netrw
		},
		-- Настройки для других источников (buffers, git_status), если они включены
		buffers = {
			follow_current_file = { enabled = true },
		},
		git_status = {
			symbols = { -- Стандартные символы git
				added = "A", -- У nvim-web-devicons свои символы, это просто для текста
				modified = "M",
				deleted = "D",
				renamed = "R",
				-- ... и т.д.
			},
		},
	},
}
