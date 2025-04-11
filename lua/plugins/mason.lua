-- lua/plugins/mason.lua

return {
	-- 1. mason core - ¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿ lsp/dap/formatter/linter
	{
		"williamboman/mason.nvim",
		cmd = "Mason", -- ¿¿¿¿¿¿¿¿¿ ¿¿ ¿¿¿¿¿¿¿ :mason
		opts = { -- ¿¿¿¿¿¿¿¿ ¿¿¿¿¿ ¿¿¿¿¿¿¿¿ ¿ setup()
			ui = {
				border = "rounded", -- ¿¿¿¿¿¿¿¿¿¿¿: ¿¿¿¿¿ ¿¿¿¿¿
				icons = {
					package_installed = "¿",
					package_pending = "¿",
					package_uninstalled = "¿",
				},
			},
		},
		-- lazy.nvim ¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿¿¿ ¿ ¿¿¿¿¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿¿¿¿¿
	},

	-- 2. mason lspconfig - ¿¿¿¿ ¿¿¿¿¿ mason ¿ nvim-lspconfig
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig", -- ¿¿¿¿¿¿¿¿¿¿¿ ¿¿ nvim-lspconfig
			"hrsh7th/cmp-nvim-lsp", -- ¿¿¿¿¿¿¿¿¿¿¿ ¿¿¿ ¿¿¿¿¿¿¿¿¿ capabilities
		},
		opts = function()
			-- ¿¿¿¿¿¿ lsp ¿¿¿¿¿¿¿¿ ¿¿¿ ¿¿¿¿¿¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿ mason'¿¿.
			-- ¿¿¿¿¿¿¿ ¿¿ ¿¿¿¿¿ ¿¿¿¿¿¿ + ¿¿¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿¿¿¿.
			local ensure_installed = {
				"ansiblels", -- ansible
				"bashls", -- bash
				"clangd", -- c/c++
				"cssls", -- css
				"dockerls", -- dockerfile
				"gopls", -- go
				"helm_ls", -- helm
				"html", -- html
				"jsonls", -- json
				"lua_ls", -- lua
				"marksman", -- markdown
				"pyright", -- python
				"rust_analyzer", -- rust
				"taplo", -- toml (¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿¿¿¿ ¿¿¿ ¿¿¿¿¿¿¿¿¿/¿¿¿¿¿¿)
				"terraformls", -- terraform
				"yamlls", -- yaml
				"lemminx", -- xml (¿¿¿¿ ¿¿¿¿¿)
			}

			return {
				ensure_installed = ensure_installed,
				-- automatic_installation = true, -- ¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿ ¿¿¿ ¿¿¿¿-¿¿¿¿¿¿¿¿¿
			}
		end,
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)

			-- --- ¿¿¿¿¿¿¿¿¿ nvim-lspconfig ---
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local function on_attach(client, bufnr)
				-- ¿¿¿¿¿¿¿¿¿¿ ¿¿¿¿ ¿¿¿¿¿¿¿¿¿¿¿ lsp ¿¿¿¿¿¿¿¿ ¿¿¿¿¿
				-- ¿¿¿ ¿¿¿¿¿¿ ¿¿¿¿¿ ¿¿¿ ¿¿¿, ¿¿¿ ¿¿¿ ¿¿¿ ¿¿¿¿¿¿¿¿¿¿ ¿¿ ¿¿¿¿ lsp
				local map = vim.keymap.set
				local opts_lsp = { buffer = bufnr, noremap = true, silent = true }
				map("n", "K", vim.lsp.buf.hover, opts_lsp)
				map("n", "gd", vim.lsp.buf.definition, opts_lsp)
				map("n", "gd", vim.lsp.buf.declaration, opts_lsp)
				map("n", "gi", vim.lsp.buf.implementation, opts_lsp)
				map("n", "go", vim.lsp.buf.type_definition, opts_lsp)
				map("n", "gr", vim.lsp.buf.references, opts_lsp)
				map("n", "<leader>rn", vim.lsp.buf.rename, opts_lsp) -- rename
				map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts_lsp) -- code action
				map("n", "<leader>d", vim.diagnostic.open_float, opts_lsp) -- ¿¿¿¿¿¿/¿¿¿¿¿¿¿¿¿¿¿¿¿¿
				map("n", "[d", vim.diagnostic.goto_prev, opts_lsp) -- ¿¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿
				map("n", "]d", vim.diagnostic.goto_next, opts_lsp) -- ¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿

				-- ¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿ ¿¿¿ ¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿ (¿¿¿¿¿¿¿¿¿¿¿)
				-- if client.supports_method("textdocument/documenthighlight") then
				--   vim.api.nvim_create_augroup("lsp_document_highlight", {clear = true})
				--   vim.api.nvim_create_autocmd({"cursorhold", "cursorholdi"}, {
				--      group = "lsp_document_highlight",
				--      buffer = bufnr,
				--      callback = vim.lsp.buf.document_highlight,
				--   })
				--   vim.api.nvim_create_autocmd("cursormoved", {
				--      group = "lsp_document_highlight",
				--      buffer = bufnr,
				--      callback = vim.lsp.buf.clear_references,
				--   })
				-- end
			end

			local lspconfig = require("lspconfig")
			require("mason-lspconfig").setup_handlers({
				-- 1. ¿¿¿¿¿¿¿¿¿¿ ¿¿ ¿¿¿¿¿¿¿¿¿ ¿¿¿ ¿¿¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
						on_attach = on_attach, -- ¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿ ¿¿¿¿¿¿¿¿ ¿ ¿¿¿¿¿¿¿¿¿
					})
				end,

				-- 2. ¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿¿ ¿¿¿ yamlls ¿ schemastore
				["yamlls"] = function()
					lspconfig.yamlls.setup({
						capabilities = capabilities,
						on_attach = on_attach,
						-- ¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿¿¿ ¿¿¿ yamlls
						settings = {
							yaml = {
								schemastore = {
									-- ¿¿¿¿¿: ¿¿¿¿¿¿¿¿¿, ¿¿¿ schemastore.nvim ¿¿¿¿¿¿¿¿!
									enable = true, -- ¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿¿
									url = "", -- ¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿, ¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿
								},
								schemas = require("schemastore").yaml.schemas(), -- ¿¿¿¿¿¿¿¿ ¿¿¿¿¿
								validate = true,
								format = { enable = true }, -- ¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿¿¿¿¿¿ ¿¿ lsp (¿¿¿¿ conform ¿¿ ¿¿¿¿¿¿¿¿¿¿¿¿)
							},
						},
					})
				end,

				-- 3. ¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿¿ ¿¿¿ jsonls ¿ schemastore
				["jsonls"] = function()
					lspconfig.jsonls.setup({
						capabilities = capabilities,
						on_attach = on_attach,
						settings = {
							json = {
								schemas = require("schemastore").json.schemas(),
								validate = { enable = true },
							},
						},
					})
				end,

				-- 4. ¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿¿ ¿¿¿ lua_ls (¿¿¿¿¿¿ ¿¿ ¿¿¿¿¿¿¿¿)
				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						on_attach = on_attach,
						settings = {
							lua = {
								diagnostics = { globals = { "vim" } },
								workspace = { checkthirdparty = false },
								telemetry = { enable = false },
							},
						},
					})
				end,
				-- ¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿¿¿ ¿¿¿ ¿¿¿¿¿¿¿¿¿¿¿¿¿
			})
			-- --- ¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿ nvim-lspconfig ---
		end,
	},
	-- 3. mason tool installer - ¿¿¿¿-¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿¿¿, ¿¿¿¿¿¿¿¿ ¿ ¿.¿.
	{
		"whoissethdaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				-- ¿¿¿¿¿¿¿¿¿¿ (¿¿¿ conform.nvim):
				"stylua", -- lua
				"black", -- python
				"isort", -- python (¿¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿)
				"goimports", -- go (¿¿¿¿¿¿¿¿¿¿¿¿¿¿ ¿ ¿¿¿¿¿¿¿)
				"prettierd", -- js/ts/html/css/json/yaml/md (¿¿¿¿¿¿¿ ¿¿¿¿¿)
				"shfmt", -- shell scripts
				"taplo", -- toml (¿¿¿ ¿¿¿¿¿¿¿¿¿¿ ¿¿¿ lsp, ¿¿ ¿¿¿¿¿¿¿¿¿ ¿¿¿ ¿¿¿¿¿¿¿)
				"rustfmt", -- rust

				-- ¿¿¿¿¿¿¿ (¿¿¿ nvim-lint ¿¿¿ ¿¿¿¿¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿ lsp):
				"ruff", -- python (¿¿¿¿¿ ¿¿¿¿¿¿¿ ¿¿¿¿¿¿ ¿ ¿¿¿¿¿¿¿¿¿)
				"eslint_d", -- js/ts (¿¿¿¿¿¿¿ ¿¿¿¿¿)
				"shellcheck", -- shell scripts
				"tflint", -- terraform (¿ ¿¿¿ ¿¿¿ ¿¿¿¿¿¿¿¿¿¿)
				"yamllint", -- yaml
				"markdownlint", -- markdown
				"ansible-lint", -- ansible
				"revive",

				-- ¿¿¿¿¿¿ ¿¿¿¿¿¿¿ (¿¿¿¿¿¿¿):
				-- "codespell",   -- ¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿¿ ¿ ¿¿¿¿
			},
		},
	},
}
