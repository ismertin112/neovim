-- lua/plugins/mason.lua
-- 真真 真真 真真真真� 真真真真真 � 真真真真真� LSP 真真真真,
-- 真真真真真� � 真真真真 � 真真真� Mason.

return {
	-- 1. Mason Core - 真真真真 真真真� LSP/DAP/Formatter/Linter
	{
		"williamboman/mason.nvim",
		cmd = "Mason", -- 真真真真� 真 真真真� :Mason
		opts = { -- 真真真真 真真� 真真真真 � setup()
			ui = {
				border = "rounded", -- 真真真真真�: 真真� 真真�
				icons = {
					package_installed = "�",
					package_pending = "�",
					package_uninstalled = "�",
				},
			},
		},
		-- lazy.nvim 真真真 真真真真真� � 真真真真真真� 真真真真真真�
	},

	-- 2. Mason LSPConfig - 真真 真真� Mason � nvim-lspconfig
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig", -- 真真真真真� 真 nvim-lspconfig
			"hrsh7th/cmp-nvim-lsp", -- 真真真真真� 真� 真真真真� capabilities
		},
		opts = function()
			-- 真真真 LSP 真真真真 真� 真真真真真真真 真真真真� Mason'真.
			-- 真真真� 真 真真� 真真真 + 真真真真真� 真真真真真真.
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
				"taplo", -- TOML (真真� 真真真真真真 真� 真真真真�/真真真)
				"terraformls", -- Terraform
				"tsserver", -- TypeScript/JavaScript
				"yamlls", -- YAML
				-- "lemminx",    -- XML (真真 真真�)
			}

			return {
				ensure_installed = ensure_installed,
				-- automatic_installation = true, -- 真真真真真真真真 真� 真真-真真真真�
			}
		end,
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)

			-- --- 真真真真� nvim-lspconfig ---
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local function on_attach(client, bufnr)
				-- 真真� 真真� 真真真真 真真� 真真真真 LSP 真� 真真真� 真真真� 真 keymaps.lua
				-- print("LSP attached to buffer:", bufnr, "Client:", client.name)
			end

			local lspconfig = require("lspconfig")
			require("mason-lspconfig").setup_handlers({
				-- 真真真真真 真 真真真真� 真真真真� 真真真真真� 真真真真�
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
						on_attach = on_attach,
					})
				end, -- <<< 真真真真真: 真真真真� 真真真� 真真�!

				-- 真真真 真真真真� 真真真真� 真� lua_ls
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
				end, -- 真真真� 真真� 真真�, 真真真 真真 真 真真真真真 真� 真真真真� 真真真真真� 真真
				-- ["gopls"] = function() ... end, -- 真真真: 真� 真真 真真真真� 真真真真真
			})
			-- --- 真真� 真真真真� nvim-lspconfig ---
		end,
	},

	-- 3. Mason Tool Installer - 真真-真真真真� 真真真真真�, 真真真真 � �.�.
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			ensure_installed = {
				-- 真真真真真 (真� conform.nvim):
				"stylua", -- Lua
				"black", -- Python
				"isort", -- Python (真真真真真 真真真真)
				"goimports", -- Go (真真真真真真真 � 真真真�)
				"prettierd", -- JS/TS/HTML/CSS/JSON/YAML/MD (真真真� 真真�)
				"shfmt", -- Shell scripts
				"taplo", -- TOML (真� 真真真真真 真� LSP, 真 真真真真� 真� 真真真�)
				"rustfmt", -- Rust

				-- 真真真� (真� nvim-lint 真� 真真真真真真� 真真� LSP):
				"ruff", -- Python (真真� 真真真� 真真真 � 真真真真�)
				"eslint_d", -- JS/TS (真真真� 真真�)
				"shellcheck", -- Shell scripts
				"tflint", -- Terraform (� 真� 真� 真真真真真)
				-- "yamllint",    -- YAML
				-- "markdownlint",-- Markdown
				-- "ansible-lint",-- Ansible

				-- 真真真 真真真� (真真真�):
				-- "codespell",   -- 真真真真 真真真真真 � 真真
			},
		},
	},
}
