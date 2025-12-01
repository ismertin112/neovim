-- Bootstrap lazy.nvim and load plugin specifications
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ import = "plugins" }, {
  ui = { border = "rounded" },
  install = { colorscheme = { "catppuccin", "tokyonight" } },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    local ok, ai = pcall(require, "ai")
    if ok and ai and type(ai.setup) == "function" then
      ai.setup()
    end
  end,
})
