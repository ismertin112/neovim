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
                dependencies = {
                        "mason.nvim",
                        "mason-lspconfig.nvim",
                        "folke/neodev.nvim",
                        "SmiteshP/nvim-navic",
                },
                event = { "BufReadPre", "BufNewFile" },

                config = function()
                        require("neodev").setup({ library = { plugins = { "nvim-dap-ui" }, types = true } })

                        local lspconfig = vim.lsp.config
                        local mason_lspconfig = require("mason-lspconfig")
                        local util = lspconfig.util

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
                                        settings = python.pyright_settings({
                                                autoImportCompletions = true,
                                                autoSearchPaths = true,
                                        }),
                                },

                                ruff = {
                                        init_options = {
                                                settings = {
                                                        args = {},
                                                        organizeImports = true,
                                                },
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
                                settings = {
                                        terraform = {
                                                languageServer = {
                                                        experimentalFeatures = {
                                                                validateOnSave = true,
                                                                moduleCompletion = true,
                                                        },
                                                },
                                        },
                                },
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

        {
                "linux-cultist/venv-selector.nvim",
                branch = "main",
                cmd = { "VenvSelect", "VenvSelectCached" },
                event = "VeryLazy",
                dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
                keys = {
                        { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select virtualenv" },
                },
                opts = {
                        options = {
                                enable_cached_venvs = true,
                                cached_venv_automatic_activation = true,
                                notify_user_on_venv_activation = false,
                                require_lsp_activation = true,
                        },
                },
                config = function(_, opts)
                        local venv = require("venv-selector")
                        venv.setup(opts)

                        vim.api.nvim_create_autocmd("LspAttach", {
                                callback = function(event)
                                        local client = vim.lsp.get_client_by_id(event.data.client_id)
                                        if not client or (client.name ~= "pyright" and client.name ~= "ruff") then
                                                return
                                        end
                                        pcall(venv.retrieve_from_cache)
                                end,
                        })
                end,
        },
}
