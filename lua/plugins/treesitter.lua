return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = { "HiPhish/nvim-ts-rainbow2" },
    event = { "BufReadPost", "BufNewFile" },
    opts = function()
      local ok, rainbow = pcall(require, "ts-rainbow")

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
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = { enable = true },
        rainbow = ok
            and {
              enable = true,
              query = { "rainbow-parens" },
              strategy = rainbow.strategy.global,
            }
          or { enable = false },
      }
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
