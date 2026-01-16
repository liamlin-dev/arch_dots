return {
  {
    "folke/snacks.nvim",
    opts = {
      input = {
        enabled = true,
      },
      statuscolumn = {
        enabled = true,
        left = { "mark", "sign" }, -- signs on the left
        right = { "fold", "git" }, -- git signs on the right
        folds = {
          open = false,
          git_hl = false,
        },
        git = {
          patterns = { "GitSign", "MiniDiffSign" },
        },
        refresh = 50,
      },
    },
  },
}
