require("todo-comments").setup({})

local keymap = vim.keymap.set

vim.keymap.set("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

vim.keymap.set("n", "ft", function()
  require("todo-comments.fzf").todo()
end, { desc = "Previous todo comment" })

vim.keymap.set("n", "fT", function()
  require("todo-comments.fzf").todo({ keywords = { "TODO", "FIX", "FIXME" } })
end, { desc = "Previous todo comment" })
