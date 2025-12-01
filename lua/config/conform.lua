local M = {}

function M.setup()
  local conform = require("conform")

  conform.setup({
    formatters_by_ft = {
      python = { "ruff_fix", "ruff_format" },
      terraform = { "terraform_fmt" },
      hcl = { "terraform_fmt" },
      lua = { "stylua" },
    },
    format_on_save = {
      lsp_fallback = false,
      timeout_ms = 500,
    },
  })

  vim.keymap.set("n", "<leader>cF", function()
    conform.format({ async = true, lsp_fallback = false })
  end, { desc = "Format file" })
end

return M
