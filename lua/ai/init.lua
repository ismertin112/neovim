local providers = require("ai.providers")

local M = {}

local function show_response(title, text)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(text, "\n"))
  local width = math.floor(vim.o.columns * 0.6)
  local height = math.floor(vim.o.lines * 0.6)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  vim.api.nvim_open_win(buf, true, {
    style = "minimal",
    relative = "editor",
    border = "rounded",
    width = width,
    height = height,
    row = row,
    col = col,
    title = title,
  })
end

local function get_selection_or_buffer()
  local mode = vim.fn.mode()
  if mode:match("v") then
    local _, ls = unpack(vim.fn.getpos("<"))
    local _, le = unpack(vim.fn.getpos(">"))
    if ls > le then
      ls, le = le, ls
    end
    return table.concat(vim.fn.getline(ls, le), "\n")
  end
  return table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
end

local function send(provider, prompt)
  local handler = providers[provider]
  if not handler then
    vim.notify("Unsupported provider: " .. provider, vim.log.levels.ERROR)
    return
  end
  handler(prompt, function(response)
    show_response(provider .. " response", response)
  end)
end

local function docstring_prompt(text)
  return table.concat({
    "Generate a concise docstring for the highlighted function.",
    "Use the same language as the source, document params and return values,",
    "and prefer a format compatible with PEP 257.",
    "Code:",
    text,
  }, "\n")
end

function M.setup()
  vim.api.nvim_create_user_command("AIChat", function(opts)
    local prompt = opts.args ~= "" and opts.args or get_selection_or_buffer()
    send(vim.g.ai_provider or os.getenv("AI_PROVIDER") or "gigachat", prompt)
  end, { nargs = "?", range = true })

  vim.keymap.set("v", "<leader>aa", function()
    send(vim.g.ai_provider or os.getenv("AI_PROVIDER") or "gigachat", get_selection_or_buffer())
  end, { desc = "Send selection to AI" })

  vim.keymap.set("n", "<leader>aa", function()
    send(vim.g.ai_provider or os.getenv("AI_PROVIDER") or "gigachat", get_selection_or_buffer())
  end, { desc = "Send buffer to AI" })

  vim.keymap.set("v", "<leader>ad", function()
    local prompt = docstring_prompt(get_selection_or_buffer())
    send(vim.g.ai_provider or os.getenv("AI_PROVIDER") or "gigachat", prompt)
  end, { desc = "Generate docstring with AI" })
end

return M
