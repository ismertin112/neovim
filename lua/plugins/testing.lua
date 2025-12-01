return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
    },
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end, desc = "Run nearest test" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file tests" },
      { "<leader>ta", function() require("neotest").run.run(".") end, desc = "Run all tests" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle test summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Open test output" },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            runner = "pytest",
            args = { "-q" },
          }),
        },
        output = { open_on_run = true, enter = true },
        summary = { follow = true, open = "botright vsplit" },
        status = { virtual_text = true, signs = true },
        floating = { border = "rounded" },
      })
    end,
  },
}
