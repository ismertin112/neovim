return {
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
    config = function(_, opts)
      local npairs = require("nvim-autopairs")
      npairs.setup(opts)
      local cmp_ok, cmp = pcall(require, "cmp")
      if cmp_ok then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },
  {
    "ggandor/leap.nvim",
    event = "VeryLazy",
    config = function()
      local leap = require("leap")
      leap.add_default_mappings()
    end,
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize", "globals" } },
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Stop session tracking" },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<leader>ot", "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
    },
    opts = {
      open_mapping = [[<c-\>]],
      direction = "float",
      float_opts = { border = "rounded" },
      size = 18,
    },
  },
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      require("project_nvim").setup(opts)
      require("telescope").load_extension("projects")
    end,
  },
}
