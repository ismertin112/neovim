return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" }, -- Запускать перед записью буфера (для format-on-save)
	cmd = { "ConformInfo" },
	opts = {
		-- Настройте ваши форматтеры здесь
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "black", "isort" },
			go = { "goimports", "gofmt" }, -- <--- Добавлено для Go
			javascript = { "prettierd", "prettier" },
			typescript = { "prettierd", "prettier" },
			javascriptreact = { "prettierd", "prettier" },
			typescriptreact = { "prettierd", "prettier" },
			html = { "prettierd", "prettier" },
			css = { "prettierd", "prettier" },
			scss = { "prettierd", "prettier" },
			json = { "prettierd", "prettier" },
			yaml = { "prettierd", "prettier" },
			toml = { "taplo" }, -- <--- Добавлено для TOML (см. ниже)
			markdown = { "prettierd", "prettier" },
			sh = { "shfmt" },
			bash = { "shfmt" },
			-- ["_"] = { "trim_whitespace" }, -- Можно оставить для всех файлов
		},
		-- Настройка форматирования при сохранении
		format_on_save = {
			-- Используйте timeout_ms для предотвращения зависаний при долгом форматировании
			timeout_ms = 500,
			-- Используйте lsp_fallback = true, если хотите использовать LSP форматирование,
			-- если conform не нашел форматтер для данного типа файла
			lsp_fallback = true,
		},

		-- Можно добавить кастомные форматтеры, если их нет по умолчанию
		-- formatters = {
		--   my_formatter = {
		--     cmd = "my_cmd",
		--     args = {"--stdin"},
		--     stdin = true,
		--   }
		-- }
	},
	init = function()
		-- Опционально: добавить бинд для ручного форматирования
		-- Бинд будет добавлен в keymaps.lua, здесь только для примера
		-- vim.keymap.set({ "n", "v" }, "<leader>f", function()
		--   require("conform").format({ async = true, lsp_fallback = true })
		-- end, { desc = "Format buffer" })
	end,
}
