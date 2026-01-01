return {
  -- 找到 snacks.nvim 的配置
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        enabled = true,
      },
    },
  },

  -- yazi
  -- {
  --   "mikavilpas/yazi.nvim",
  --   version = "*", -- use the latest stable version
  --   event = "VeryLazy",
  --   dependencies = {
  --     { "nvim-lua/plenary.nvim", lazy = true },
  --   },
  --   keys = {
  --     -- 👇 in this section, choose your own keymappings!
  --     -- {
  --     --   "<leader>-",
  --     --   mode = { "n", "v" },
  --     --   "<cmd>Yazi<cr>",
  --     --   desc = "Open yazi at the current file",
  --     -- },
  --     -- {
  --     --   -- Open in the current working directory
  --     --   "<leader>cw",
  --     --   "<cmd>Yazi cwd<cr>",
  --     --   desc = "Open the file manager in nvim's working directory",
  --     -- },
  --     {
  --       "<leader>e",
  --       "<cmd>Yazi toggle<cr>",
  --       desc = "Resume the last yazi session",
  --     },
  --   },
  --   opts = {
  --     -- if you want to open yazi instead of netrw, see below for more info
  --     open_for_directories = false,
  --     keymaps = {
  --       show_help = "<f1>",
  --     },
  --   },
  --   init = function()
  --     vim.g.loaded_netrwPlugin = 1
  --   end,
  -- },
}
