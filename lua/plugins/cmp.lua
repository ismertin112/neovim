-- lua/plugins/cmp.lua
return {
	-- 1. nvim-cmp (ядро автодополнения)
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter", -- Загружать при входе в режим вставки
		dependencies = {
			-- Источники completions
			"hrsh7th/cmp-nvim-lsp", -- LSP
			"hrsh7th/cmp-nvim-lsp-signature-help", -- Подсказки сигнатур функций LSP
			"hrsh7th/cmp-buffer", -- Текущий буфер
			"hrsh7th/cmp-path", -- Пути файловой системы
			"hrsh7th/cmp-cmdline", -- Командная строка nvim (:, /)
			"saadparwaiz1/cmp_luasnip", -- Сниппеты LuaSnip
			"hrsh7th/cmp-nvim-lua", -- Код Lua в nvim (для конфигов)
			-- "hrsh7th/cmp-emoji",          -- (Опционально) Emoji

			-- Движок сниппетов
			{
				"L3MON4D3/LuaSnip",
				dependencies = { "rafamadriz/friendly-snippets" }, -- Зависимость для стандартных сниппетов
				opts = { history = true, updateevents = "TextChanged,TextChangedI" }, -- Настройки LuaSnip
				config = function(_, opts)
					require("luasnip").setup(opts)
					-- Загружаем стандартные сниппеты
					require("luasnip.loaders.from_vscode").lazy_load()
					require("luasnip.loaders.from_vscode").lazy_load({
						paths = vim.g.vscode_snippets_path or "",
					}) -- Пользовательские если есть

					-- Можно добавить свои кастомные пути
					require("luasnip.loaders.from_lua").lazy_load({
						paths = { vim.fn.stdpath("config") .. "/lua/custom/snippets" },
					}) -- Пример пути

					-- Бинды для <Tab> (если используете в режиме Visual/Select для сниппетов)
					vim.keymap.set({ "i", "s" }, "<Tab>", function()
						if require("luasnip").expand_or_jumpable() then
							require("luasnip").expand_or_jump()
						else
							-- Можно вставить Tab или использовать для cmp, если нужно
							return "<Tab>"
						end
					end, { silent = true, expr = true })

					vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
						if require("luasnip").jumpable(-1) then
							require("luasnip").jump(-1)
						end
					end, { silent = true })
				end,
			},

			-- Внешний вид (иконки)
			{
				"onsails/lspkind.nvim",
				opts = {
					mode = "symbol_text", -- Рекомендуемый режим: иконка + текст
					maxwidth = 50, -- Макс ширина для текста рядом с иконкой
					ellipsis_char = "...",
					-- Можно настроить символы: preset = 'codicons' / 'devicons' / 'default'
					-- preset = 'codicons',
					-- Или указать свои символы: symbol_map = { Codeium = "", ... }
				},
			},

			-- Codeium (если решите использовать, раскомментируйте и настройте)
			-- {
			--   "Exafunction/codeium.nvim",
			--   cmd = "Codeium", -- Загружать по команде
			--   build = ":Codeium Auth", -- Команда для авторизации после установки/обновления
			--   opts = { -- Можно передать опции в setup
			--     -- Например, отключить авто-триггер, если хотите вызывать вручную
			--     -- enable_chat = true, -- Если нужна функция чата
			--   }
			-- },
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			-- Настройка икон для разных типов completion items
			local source_mapping = {
				buffer = "[BUF]",
				nvim_lsp = "[LSP]",
				luasnip = "[SNIP]",
				nvim_lua = "[LUA]",
				path = "[PATH]",
				cmdline = "[CMD]",
				-- codeium = "[AI]", -- Если будете использовать
			}

			cmp.setup({
				completion = {
					completeopt = "menu,menuone,noinsert", -- Рекомендуется для предпросмотра без вставки
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item(), -- Вместо Shift-Tab
					["<C-j>"] = cmp.mapping.select_next_item(), -- Вместо Tab
					["<C-b>"] = cmp.mapping.scroll_docs(-4), -- Прокрутка документации вверх
					["<C-f>"] = cmp.mapping.scroll_docs(4), -- Прокрутка документации вниз
					["<C-Space>"] = cmp.mapping.complete(), -- Показать completions
					["<C-e>"] = cmp.mapping.abort(), -- Закрыть completions
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Подтвердить выбор

					-- Tab-based navigation and snippet expansion (optional, choose one style)
					-- Этот бинд `<Tab>` конфликтует с биндом LuaSnip выше, выберите что-то одно
					-- или интегрируйте их логику более сложно.
					-- ["<Tab>"] = cmp.mapping(function(fallback)
					--   if cmp.visible() then
					--     cmp.select_next_item()
					--   elseif luasnip.expand_or_jumpable() then
					--     luasnip.expand_or_jump()
					--   else
					--     fallback() -- Обычный Tab
					--   end
					-- end, { "i", "s" }),
					-- ["<S-Tab>"] = cmp.mapping(function(fallback)
					--   if cmp.visible() then
					--     cmp.select_prev_item()
					--   elseif luasnip.jumpable(-1) then
					--     luasnip.jump(-1)
					--   else
					--     fallback() -- Обычный Shift-Tab
					--   end
					-- end, { "i", "s" }),
				}),

				-- Источники для автодополнения (порядок важен!)
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" }, -- Подсказка сигнатуры
					{ name = "luasnip" },
					-- { name = "codeium" }, -- Раскомментируйте, если включите Codeium
					{ name = "buffer", keyword_length = 3 }, -- Искать в буфере после 3 символов
					{ name = "path" },
				}),

				-- Настройка внешнего вида окна автодополнения
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},

				-- Форматирование элементов (иконки + текст)
				formatting = {
					-- Deprecated: fields = { "kind", "abbr", "menu" }, -- Устарело
					format = function(entry, vim_item)
						-- Используем lspkind для иконок LSP
						if vim_item.kind ~= "" and vim_item.kind ~= nil then -- Проверка, что kind не пустой
							vim_item.kind = lspkind.presets.default[vim_item.kind] or vim_item.kind
						end

						-- Добавляем префикс источника (e.g., [LSP], [SNIP])
						vim_item.menu = source_mapping[entry.source.name] or entry.source.name

						-- Опционально: обрезать длинные строки
						-- local max_width = 50
						-- if string.len(vim_item.abbr) > max_width then
						--   vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 3) .. '...'
						-- end

						return vim_item
					end,
				},

				-- Экспериментальные возможности (опционально)
				experimental = {
					-- ghost_text = true, -- Показывает выбранный элемент "призраком" в тексте
				},
			})

			-- Настройка автодополнения для командной строки (cmdline)
			cmp.setup.cmdline({ "/", "?" }, { -- Для поиска
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" }, -- Искать в буфере
				},
			})
			cmp.setup.cmdline(":", { -- Для команд
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" }, -- Пути
				}, {
					{ name = "cmdline" }, -- Команды nvim
				}),
			})
		end,
	},

	-- Зависимости nvim-cmp (уже перечислены выше, но можно выделить для ясности)
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-nvim-lsp-signature-help",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	"saadparwaiz1/cmp_luasnip",
	"hrsh7th/cmp-nvim-lua",
	"L3MON4D3/LuaSnip",
	"rafamadriz/friendly-snippets", -- Зависимость LuaSnip
	"onsails/lspkind.nvim",
	-- "Exafunction/codeium.nvim", -- Зависимость, если используется
}
