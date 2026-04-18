require("flash").setup({})

local keymap = vim.keymap.set

vim.keymap.set({ "n", "x", "o" }, "s", function()
  require("flash").jump()
end, { desc = "Flash" })
