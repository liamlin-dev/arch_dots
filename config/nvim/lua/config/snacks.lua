require("snacks").setup({
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
  dashboard = { enabled = false },
})

local keymap = vim.keymap.set
keymap("n", "<leader>e", function()
  Snacks.explorer()
end, { desc = "Find Files" })
