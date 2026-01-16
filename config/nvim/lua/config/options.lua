-- Neovim Options

local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- General
opt.autowrite = true
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2
opt.confirm = true
opt.cursorline = true
opt.mouse = "a"

-- Indentation
opt.expandtab = true
opt.shiftround = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- UI
opt.number = true
opt.relativenumber = true
-- opt.signcolumn = "yes:2"
opt.showmode = false
opt.laststatus = 3
opt.termguicolors = true
opt.pumblend = 10
opt.pumheight = 10
opt.ruler = false

-- Folding
opt.foldlevel = 99
opt.foldmethod = "indent"
opt.foldtext = ""
opt.fillchars = {
  foldopen = "▾",
  foldclose = "▸",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "nosplit"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

-- Splits
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"

-- Misc
opt.formatoptions = "jcroqlnt"
opt.jumpoptions = "view"
opt.linebreak = true
opt.list = true
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.smoothscroll = true
opt.spelllang = { "en" }
opt.timeoutlen = vim.g.vscode and 1000 or 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.virtualedit = "block"
opt.wildmode = "longest:full,full"
opt.winminwidth = 5
opt.wrap = false
