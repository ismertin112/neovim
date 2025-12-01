local lsp = require("config.lsp")
local python = require("lang.python")

return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = { ui = { border = "rounded" } },
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason.nvim" },
		cmd = { "MasonToolsInstall", "MasonToolsUpdate" },
		opts = {
			ensure_installed = { "ruff", "stylua", "prettier" },
			run_on_start = true,
			auto_update = true,
		},
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason.nvim" },
		opts = {
			ensure_installed = { "pyright", "ruff", "lua_ls" },
		},
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = { "mason.nvim", "mason-lspconfig.nvim", "folke/neodev.nvim" },
		event = { "BufReadPre", "BufNewFile" },

		config = function()
			require("neodev").setup({ library = { plugins = { "nvim-dap-ui" }, types = true } })

			local lspconfig = require("lspconfig")
			local mason_lspconfig = require("mason-lspconfig")
			local util = require("lspconfig.util")

			--------------------------------------------------------------------
			-- 1. Mason устанавливает серверы, но НЕ настраивает автоматически --
			--------------------------------------------------------------------

			mason_lspconfig.setup({
				ensure_installed = { "pyright", "ruff", "lua_ls" },
			})

			--------------------------------------------------------------------
			-- 2. Современная ручная конфигурация (вместо setup_handlers)      --
			--------------------------------------------------------------------

			local servers = {
				pyright = {
					settings = python.pyright_settings(),
				},

				ruff = {
					init_options = {
						settings = { args = {} },
					},
				},

				lua_ls = {
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							workspace = { checkThirdParty = false },
						},
					},
				},
			}

			-- Настраиваем каждый сервер вручную
			for name, opts in pairs(servers) do
				opts.capabilities = lsp.capabilities
				opts.on_attach = lsp.on_attach
				lspconfig[name].setup(opts)
			end

			--------------------------------------------------------------------
			-- 3. Terraform: используем системные бинарники                  --
			--------------------------------------------------------------------

			lspconfig.terraformls.setup({
				cmd = { "terraform-ls", "serve" }, -- brew install hashicorp/tap/terraform-ls
				filetypes = { "terraform", "terraform-vars", "hcl" },
				root_dir = util.root_pattern(".terraform", ".git"),
				capabilities = lsp.capabilities,
				on_attach = lsp.on_attach,
			})

			--------------------------------------------------------------------
			-- 4. TFLint (опционально)                                        --
			--------------------------------------------------------------------

			lspconfig.tflint.setup({
				cmd = { "tflint", "--langserver" },
				filetypes = { "terraform" },
				root_dir = util.root_pattern(".terraform", ".git"),
				capabilities = lsp.capabilities,
				on_attach = lsp.on_attach,
			})
		end,
	},
}
