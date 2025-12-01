return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = { "HiPhish/nvim-ts-rainbow2" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {
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
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = { enable = true },
      rainbow = {
        enable = true,
        query = { "rainbow-parens" },
        strategy = require("ts-rainbow").strategy.global,
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
