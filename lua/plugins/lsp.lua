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
      ensure_installed = { "ruff", "tflint", "terraform", "stylua" },
      run_on_start = true,
      auto_update = true,
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = { "pyright", "ruff_lsp", "terraformls", "tflint", "lua_ls" },
      automatic_installation = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason.nvim", "mason-lspconfig.nvim", "folke/neodev.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("neodev").setup({ library = { plugins = { "nvim-dap-ui" }, types = true } })
      local lspconfig = require("lspconfig")
      local servers = {
        pyright = {
          settings = python.pyright_settings(),
        },
        ruff_lsp = {
          init_options = {
            settings = {
              args = {},
            },
          },
        },
        terraformls = {},
        tflint = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
            },
          },
        },
      }

      require("mason-lspconfig").setup_handlers({
        function(server)
          local opts = vim.tbl_deep_extend("force", {
            capabilities = lsp.capabilities,
            on_attach = lsp.on_attach,
          }, servers[server] or {})
          lspconfig[server].setup(opts)
        end,
      })
    end,
  },
}
