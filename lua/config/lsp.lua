local M = {}

local function format_on_save(bufnr)
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    group = vim.api.nvim_create_augroup("LspFormat" .. bufnr, { clear = true }),
    callback = function()
      vim.lsp.buf.format({ bufnr = bufnr })
    end,
  })
end

local function buf_map(bufnr, mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
end

M.on_attach = function(client, bufnr)
  buf_map(bufnr, "n", "gd", vim.lsp.buf.definition, "Goto definition")
  buf_map(bufnr, "n", "gr", vim.lsp.buf.references, "References")
  buf_map(bufnr, "n", "gD", vim.lsp.buf.declaration, "Declaration")
  buf_map(bufnr, "n", "gi", vim.lsp.buf.implementation, "Implementation")
  buf_map(bufnr, "n", "K", vim.lsp.buf.hover, "Hover")
  buf_map(bufnr, "n", "<leader>rn", vim.lsp.buf.rename, "Rename")
  buf_map(bufnr, { "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
  buf_map(bufnr, "n", "<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
  buf_map(bufnr, "n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
  buf_map(bufnr, "n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
  buf_map(bufnr, "n", "<leader>lf", function()
    vim.lsp.buf.format({ async = true })
  end, "Format buffer")

  if client.supports_method("textDocument/formatting") then
    local ft = vim.bo[bufnr].filetype
    if ft == "python" or ft == "terraform" or ft == "hcl" then
      format_on_save(bufnr)
    end
  end
end

M.capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities()
)

return M
