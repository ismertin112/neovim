local M = {}

local function python_path()
  local venv = os.getenv("VIRTUAL_ENV")
  if venv and venv ~= "" then
    return venv .. "/bin/python"
  end
  local cwd = vim.fn.getcwd()
  for _, env in ipairs({ ".venv", "venv" }) do
    local path = cwd .. "/" .. env .. "/bin/python"
    if vim.fn.executable(path) == 1 then
      return path
    end
  end
  if vim.fn.executable("poetry") == 1 then
    local ok, result = pcall(vim.fn.system, { "poetry", "env", "info", "-p" })
    if ok and result and result ~= "" then
      local p = vim.trim(result) .. "/bin/python"
      if vim.fn.executable(p) == 1 then
        return p
      end
    end
  end
  return "python3"
end

function M.pyright_settings()
  return {
    python = {
      pythonPath = python_path(),
      analysis = {
        autoImportCompletions = true,
        typeCheckingMode = "basic",
        useLibraryCodeForTypes = true,
      },
    },
  }
end

return M
