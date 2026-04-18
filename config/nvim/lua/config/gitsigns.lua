require("gitsigns").setup({
  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "" },
    topdelete = { text = "" },
    changedelete = { text = "▎" },
    untracked = { text = "▎" },
  },
  signs_staged = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "" },
    topdelete = { text = "" },
    changedelete = { text = "▎" },
  },
})

local gs = require("gitsigns")
local keymap = vim.keymap.set

-- Navigation
keymap("n", "]h", function()
  if vim.wo.diff then
    vim.cmd.normal({ "]c", bang = true })
  else
    gs.nav_hunk("next")
  end
end, { desc = "Next Hunk", silent = true })

keymap("n", "[h", function()
  if vim.wo.diff then
    vim.cmd.normal({ "[c", bang = true })
  else
    gs.nav_hunk("prev")
  end
end, { desc = "Prev Hunk", silent = true })

keymap("n", "]H", function()
  gs.nav_hunk("last")
end, { desc = "Last Hunk", silent = true })

keymap("n", "[H", function()
  gs.nav_hunk("first")
end, { desc = "First Hunk", silent = true })

-- Actions
keymap({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", { desc = "Stage Hunk", silent = true })
keymap({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", { desc = "Reset Hunk", silent = true })
keymap("n", "<leader>ghp", gs.preview_hunk_inline, { desc = "Preview Hunk Inline", silent = true })
keymap("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk", silent = true })
keymap("n", "<leader>gs", gs.stage_buffer, { desc = "Stage Buffer", silent = true })
keymap("n", "<leader>gr", gs.reset_buffer, { desc = "Reset Buffer", silent = true })
keymap("n", "<leader>gbl", ":Gitsigns blame_line", { desc = "Blame Line", silent = true })
keymap("n", "<leader>gbd", ":Gitsigns blame", { desc = "Blame Documemt", silent = true })
keymap("n", "<leader>gd", function()
  gs.diffthis("~")
end, { desc = "Diff This", silent = true })
