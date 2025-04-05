return {
	{
		"nvimtools/none-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = false,
		config = function()
			local null_ls = require("null-ls")

			local sources = {
				-- 🔥 Форматтеры
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.prettier.with({
					filetypes = { "javascript", "typescript", "json", "yaml" },
				}),
				null_ls.builtins.formatting.terraform_fmt,
				null_ls.builtins.formatting.yamlfmt,
				null_ls.builtins.formatting.shfmt,
				null_ls.builtins.formatting.clang_format,
				null_ls.builtins.formatting.gofmt,
			}

			null_ls.setup({ sources = sources })

			-- 🛠 Автоформат при сохранении
			vim.api.nvim_create_autocmd("BufWritePre", {
				callback = function()
					vim.lsp.buf.format({ async = false })
				end,
			})
		end,
	},
}
