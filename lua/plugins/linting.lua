-- lua/plugins/linting.lua
return {
	"mfussenegger/nvim-lint",
	-- Загружаем плагин чуть раньше, чтобы автокоманды успели зарегистрироваться
	event = { "BufReadPost", "BufNewFile" }, -- Изменено с BufReadPre на BufReadPost
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			python = { "ruff" },
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			go = { "revive" }, -- Убедитесь, что revive установлен через Mason
			sh = { "shellcheck" },
			bash = { "shellcheck" },
			terraform = { "tflint" },
			yaml = { "yamllint" }, -- Убедитесь, что yamllint установлен
			markdown = { "markdownlint" }, -- Убедитесь, что markdownlint установлен
			ansible = { "ansible-lint" }, -- Убедитесь, что ansible-lint установлен
			-- Добавьте другие
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		-- Запускаем линтинг при входе в буфер и после записи.
		-- Убраны TextChanged и InsertLeave для избежания проблем с fast events.
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
			group = lint_augroup,
			pattern = "*", -- Применять ко всем файлам
			desc = "Run nvim-lint",
			callback = function(args)
				-- Используем vim.schedule() для безопасного вызова lint.try_lint()
				-- вне быстрого контекста событий.
				vim.schedule(function()
					-- Проверка buf_is_valid здесь не нужна, vim.schedule позаботится о контексте
					-- и если буфер закроется до выполнения, lint.try_lint скорее всего сам справится.
					lint.try_lint(nil, { bufnr = args.buf })
				end)
			end,
		})

		-- Опционально: бинд для ручного запуска
		vim.keymap.set("n", "<leader>ll", function()
			lint.try_lint()
		end, { desc = "Trigger linting" })
	end,
}
