-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.snacks_animate = false
vim.g.autoformat = true
vim.g.lazyvim_cmp = "blink.cmp"
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"
vim.g.lazyvim_rust_diagnostics = "rust-analyzer"
vim.g.lazyvim_blink_main = true
-- vim.g.lazyvim_picker = "fzf"
-- vim.opt.winborder = "single"

local opt = vim.opt
opt.clipboard = "unnamedplus"
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.inccommand = "split" -- preview substitutions live
opt.grepprg = "rg --vimgrep" -- use ripgrep for :grep

-- 強制使用 OSC 52，nvim 就可以透過控制碼與遠端剪貼簿互通
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}
