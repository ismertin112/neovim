local Job = require("plenary.job")

local M = {}

local function run_curl(url, headers, payload, callback)
  if not url or url == "" then
    vim.notify("AI provider URL is missing", vim.log.levels.ERROR)
    return
  end
  local args = { "-s", "-X", "POST", url }
  for _, header in ipairs(headers) do
    table.insert(args, "-H")
    table.insert(args, header)
  end
  table.insert(args, "-d")
  table.insert(args, vim.fn.json_encode(payload))

  Job:new({
    command = "curl",
    args = args,
    env = { HTTP_PROXY = os.getenv("HTTP_PROXY"), HTTPS_PROXY = os.getenv("HTTPS_PROXY") },
    on_exit = function(j, return_val)
      if return_val ~= 0 then
        vim.schedule(function()
          vim.notify("Request failed: " .. table.concat(j:stderr_result(), "\n"), vim.log.levels.ERROR)
        end)
        return
      end
      local result = table.concat(j:result(), "\n")
      vim.schedule(function()
        callback(result)
      end)
    end,
  }):start()
end

function M.gigachat(prompt, callback)
  local token = os.getenv("GIGACHAT_TOKEN")
  local url = os.getenv("GIGACHAT_API_URL")
  if not token then
    vim.notify("GIGACHAT_TOKEN is not set", vim.log.levels.ERROR)
    return
  end
  run_curl(url, {
    "Authorization: Bearer " .. token,
    "Content-Type: application/json",
  }, {
    model = os.getenv("GIGACHAT_MODEL") or "gpt",
    messages = { { role = "user", content = prompt } },
  }, callback)
end

function M.yandexgpt(prompt, callback)
  local key = os.getenv("YANDEXGPT_API_KEY")
  local url = os.getenv("YANDEXGPT_API_URL")
  if not key then
    vim.notify("YANDEXGPT_API_KEY is not set", vim.log.levels.ERROR)
    return
  end
  run_curl(url, {
    "Authorization: Api-Key " .. key,
    "Content-Type: application/json",
  }, {
    modelUri = os.getenv("YANDEXGPT_MODEL") or "gpt",
    messages = { { role = "user", content = prompt } },
  }, callback)
end

return M
