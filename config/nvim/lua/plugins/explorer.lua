return {
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
      { "<leader>E", function() Snacks.explorer.open({ cwd = vim.fn.getcwd() }) end, desc = "Explorer (cwd)" },
    },
    opts = {
      explorer = {
        enabled = true,
        replace_netrw = true,
      },
    },
  },
}
