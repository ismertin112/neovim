-- Autocommands shared across the configuration
local group = vim.api.nvim_create_augroup("CoreAutocmds", { clear = true })
local uv = vim.uv or vim.loop

local function truncate_large_lsp_log()
  local log_path = vim.lsp.get_log_path()
  if not log_path then
    return
  end

  local stat = uv.fs_stat(log_path)
  local max_size = 10 * 1024 * 1024 -- 10MB cap to keep :checkhealth happy
  if stat and stat.size > max_size then
    local fd = uv.fs_open(log_path, "w", 438) -- 0666 in octal
    if fd then
      uv.fs_write(fd, "", -1)
      uv.fs_close(fd)
    end
  end
end

truncate_large_lsp_log()

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.hl.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

-- Better terminals
vim.api.nvim_create_autocmd("TermOpen", {
  group = group,
  callback = function()
    vim.bo[0].number = false
    vim.bo[0].relativenumber = false
  end,
})

-- Close some filetypes with q
vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "help", "qf", "lspinfo", "spectre_panel", "startuptime" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
