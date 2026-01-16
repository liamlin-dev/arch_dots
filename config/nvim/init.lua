-- Bootstrap Neovim Config (LazyVim-free)

-- 1. Load options first (before plugins)
require("config.options")

-- 2. Bootstrap lazy.nvim and load plugins
require("config.lazy")

-- 3. Load keymaps & autocmds after plugins (VeryLazy event)
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("config.keymaps")
    require("config.autocmds")
  end,
})
