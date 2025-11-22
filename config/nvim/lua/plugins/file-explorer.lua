return {
  -- 找到 snacks.nvim 的配置
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        enabled = false, -- 將內置的 explorer 功能設為禁用
      },
    },
    keys = {
      -- { "<leader>E", false }, -- 這些可能是舊的或額外的映射
      -- { "<leader>e", false },
    },
  },

  -- mini-files
  -- {
  --   "nvim-mini/mini.files",
  --   version = "*",
  --   lazy = false,
  --   keys = {
  --     { "<TAB>", "<CMD>lua MiniFiles.open()<CR>" },
  --   },
  --   config = function()
  --     require("mini.files").setup({
  --
  --       mappings = {
  --         close = "<TAB>",
  --         go_in = "L",
  --         go_in_plus = "<CR>",
  --         go_out = "H",
  --         go_out_plus = "",
  --         mark_goto = "'",
  --         mark_set = "m",
  --         reset = "<BS>",
  --         reveal_cwd = "@",
  --         show_help = "g?",
  --         synchronize = "=",
  --         trim_left = "<",
  --         trim_right = ">",
  --       },
  --     })
  --   end,
  -- },

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
  --       "<TAB>",
  --       "<cmd>Yazi toggle<cr>",
  --       desc = "Resume the last yazi session",
  --     },
  --   },
  --   ---@type YaziConfig | {}
  --   opts = {
  --     -- if you want to open yazi instead of netrw, see below for more info
  --     open_for_directories = false,
  --     keymaps = {
  --       show_help = "<f1>",
  --     },
  --   },
  --   -- 👇 if you use `open_for_directories=true`, this is recommended
  --   init = function()
  --     -- mark netrw as loaded so it's not loaded at all.
  --     --
  --     -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
  --     vim.g.loaded_netrwPlugin = 1
  --   end,
  -- },
}
