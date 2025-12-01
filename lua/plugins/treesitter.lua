return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = { "HiPhish/nvim-ts-rainbow2" },
    event = { "BufReadPost", "BufNewFile" },
    opts = function()
      local rainbow = require("ts-rainbow")

      return {
        ensure_installed = {
          "lua",
          "python",
          "terraform",
          "hcl",
          "bash",
          "json",
          "yaml",
          "toml",
          "markdown",
          "markdown_inline",
          "regex",
        },
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = { enable = true },
        rainbow = {
          enable = true,
          query = { "rainbow-parens" },
          strategy = rainbow.strategy.global,
        },
      }
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
