local M = {}

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
  buf_map(bufnr, "n", "<leader>cf", function()
    require("conform").format({ async = true, lsp_fallback = false })
  end, "Format buffer")

  if vim.bo[bufnr].filetype == "python" and client.supports_method("textDocument/codeAction") then
    local group = vim.api.nvim_create_augroup("PythonOrganizeImports", { clear = false })
    vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = group,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.code_action({
          context = { only = { "source.organizeImports" } },
          apply = true,
        })
      end,
      desc = "Organize Python imports",
    })
  end
end

M.capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities(),
  require("cmp_nvim_lsp").default_capabilities()
)

return M
