return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        neocmake = {},
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cmake = { "gersemi" },
      },
    },
  },
  -- {
  --   "Civitasv/cmake-tools.nvim",
  --   enabled = true,
  --   opts = {},
  -- },
}
