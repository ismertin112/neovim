-- lua/plugins/mason.lua
-- ¿¿¿¿ ¿¿¿¿ ¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿¿ ¿ ¿¿¿¿¿¿¿¿¿¿¿ LSP ¿¿¿¿¿¿¿¿,
-- ¿¿¿¿¿¿¿¿¿¿¿ ¿ ¿¿¿¿¿¿¿¿ ¿ ¿¿¿¿¿¿¿ Mason.

return {
	-- 1. Mason Core - ¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿ LSP/DAP/Formatter/Linter
	{
		"williamboman/mason.nvim",
		cmd = "Mason", -- ¿¿¿¿¿¿¿¿¿ ¿¿ ¿¿¿¿¿¿¿ :Mason
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

	-- 2. Mason LSPConfig - ¿¿¿¿ ¿¿¿¿¿ Mason ¿ nvim-lspconfig
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig", -- ¿¿¿¿¿¿¿¿¿¿¿ ¿¿ nvim-lspconfig
			"hrsh7th/cmp-nvim-lsp", -- ¿¿¿¿¿¿¿¿¿¿¿ ¿¿¿ ¿¿¿¿¿¿¿¿¿ capabilities
		},
		opts = function()
			-- ¿¿¿¿¿¿ LSP ¿¿¿¿¿¿¿¿ ¿¿¿ ¿¿¿¿¿¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿ Mason'¿¿.
			-- ¿¿¿¿¿¿¿ ¿¿ ¿¿¿¿¿ ¿¿¿¿¿¿ + ¿¿¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿¿¿¿.
			local ensure_installed = {
				"ansiblels", -- Ansible
				"bashls", -- Bash
				"clangd", -- C/C++
				"cssls", -- CSS
				"dockerls", -- Dockerfile
				"gopls", -- Go
				"helm_ls", -- Helm
				"html", -- HTML
				"jsonls", -- JSON
				"lua_ls", -- Lua
				"marksman", -- Markdown
				"pyright", -- Python
				"rust_analyzer", -- Rust
				"taplo", -- TOML (¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿¿¿¿ ¿¿¿ ¿¿¿¿¿¿¿¿¿/¿¿¿¿¿¿)
				"terraformls", -- Terraform
				"tsserver", -- TypeScript/JavaScript
				"yamlls", -- YAML
				-- "lemminx",    -- XML (¿¿¿¿ ¿¿¿¿¿)
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
				-- ¿¿¿¿¿ ¿¿¿¿¿ ¿¿¿¿¿¿¿¿ ¿¿¿¿¿ ¿¿¿¿¿¿¿¿ LSP ¿¿¿ ¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿ ¿¿ keymaps.lua
				-- print("LSP attached to buffer:", bufnr, "Client:", client.name)
			end

			local lspconfig = require("lspconfig")
			require("mason-lspconfig").setup_handlers({
				-- ¿¿¿¿¿¿¿¿¿¿ ¿¿ ¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
						on_attach = on_attach,
					})
				end, -- <<< ¿¿¿¿¿¿¿¿¿¿: ¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿ ¿¿¿¿¿!

				-- ¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿ ¿¿¿ lua_ls
				["lua_ls"] = function()
					lspconfig.lua_ls.setup({
						capabilities = capabilities,
						on_attach = on_attach,
						settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
								workspace = { checkThirdParty = false },
								telemetry = { enable = false },
							},
						},
					})
				end, -- ¿¿¿¿¿¿¿ ¿¿¿¿¿ ¿¿¿¿¿, ¿¿¿¿¿¿ ¿¿¿¿ ¿¿ ¿¿¿¿¿¿¿¿¿¿ ¿¿¿ ¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿¿¿ ¿¿¿¿
				-- ["gopls"] = function() ... end, -- ¿¿¿¿¿¿: ¿¿¿ ¿¿¿¿ ¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿¿
			})
			-- --- ¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿ nvim-lspconfig ---
		end,
	},

	-- 3. Mason Tool Installer - ¿¿¿¿-¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿¿¿, ¿¿¿¿¿¿¿¿ ¿ ¿.¿.
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				-- ¿¿¿¿¿¿¿¿¿¿ (¿¿¿ conform.nvim):
				"stylua", -- Lua
				"black", -- Python
				"isort", -- Python (¿¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿)
				"goimports", -- Go (¿¿¿¿¿¿¿¿¿¿¿¿¿¿ ¿ ¿¿¿¿¿¿¿)
				"prettierd", -- JS/TS/HTML/CSS/JSON/YAML/MD (¿¿¿¿¿¿¿ ¿¿¿¿¿)
				"shfmt", -- Shell scripts
				"taplo", -- TOML (¿¿¿ ¿¿¿¿¿¿¿¿¿¿ ¿¿¿ LSP, ¿¿ ¿¿¿¿¿¿¿¿¿ ¿¿¿ ¿¿¿¿¿¿¿)
				"rustfmt", -- Rust

				-- ¿¿¿¿¿¿¿ (¿¿¿ nvim-lint ¿¿¿ ¿¿¿¿¿¿¿¿¿¿¿¿¿ ¿¿¿¿¿ LSP):
				"ruff", -- Python (¿¿¿¿¿ ¿¿¿¿¿¿¿ ¿¿¿¿¿¿ ¿ ¿¿¿¿¿¿¿¿¿)
				"eslint_d", -- JS/TS (¿¿¿¿¿¿¿ ¿¿¿¿¿)
				"shellcheck", -- Shell scripts
				"tflint", -- Terraform (¿ ¿¿¿ ¿¿¿ ¿¿¿¿¿¿¿¿¿¿)
				-- "yamllint",    -- YAML
				-- "markdownlint",-- Markdown
				-- "ansible-lint",-- Ansible

				-- ¿¿¿¿¿¿ ¿¿¿¿¿¿¿ (¿¿¿¿¿¿¿):
				-- "codespell",   -- ¿¿¿¿¿¿¿¿ ¿¿¿¿¿¿¿¿¿¿ ¿ ¿¿¿¿
			},
		},
	},
}
