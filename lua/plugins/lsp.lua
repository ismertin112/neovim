return {
	{
		{
			"b0o/SchemaStore.nvim",
			lazy = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
		lazy = false,
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					-- 🖥️ Основные языки
					"bashls",
					"pyright",
					"jsonls",
					"yamlls",
					"lua_ls",
					"html",
					"cssls",
					"ts_ls",
					"clangd",
					"gopls",
					"marksman",
					"rust_analyzer",
					"taplo",

					-- 🏗️ DevOps и инфраструктура
					"terraformls",
					"tflint",
					"ansiblels",
					"helm_ls",
					"dockerls",
				},
			})

			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- 🟢 Запускаем `yamlls` отдельно перед циклом

			lspconfig.yamlls.setup({
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
				settings = {
					yaml = {
						schemaStore = { enable = false, url = "" },
						schemas = require("schemastore").yaml.schemas(),
						validate = true,
						format = { enable = true },
					},
				},
			})
			local servers = {
				-- 🖥️ Основные языки
				"bashls",
				"pyright",
				"jsonls",
				"lua_ls",
				"html",
				"cssls",
				"ts_ls",
				"clangd",
				"gopls",
				"marksman",
				"rust_analyzer",
				"taplo",

				-- 🏗️ DevOps и инфраструктура
				"terraformls",
				"ansiblels",
				"helm_ls",
				"dockerls",
			}

			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup({ capabilities = capabilities })
			end
		end,
	},
}
