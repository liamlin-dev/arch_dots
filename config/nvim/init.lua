-- Bootstrap Neovim Config (LazyVim-free)

-- 1. Load options first (before plugins)
require("options")
require("keymaps")

-- 2. Plugins
-- stylua: ignore
local gh = function(x) return 'https://github.com/' .. x end
vim.pack.add({
  -- core
  gh("MunifTanjim/nui.nvim"),
  gh("nvim-lua/plenary.nvim"),
  -- color scheme and icon
  gh("sainnhe/gruvbox-material"),
  gh("catppuccin/nvim"), -- only for palette
  gh("nvim-tree/nvim-web-devicons"), -- icons
  -- UI
  gh("folke/noice.nvim"),
  gh("folke/todo-comments.nvim"), -- todo
  gh("Bekaboo/dropbar.nvim"), -- symbol brocon
  gh("nvim-lualine/lualine.nvim"), -- status line
  gh("folke/which-key.nvim"), -- shortcut hint
  gh("rcarriga/nvim-notify"), -- notification
  -- tools
  gh("folke/snacks.nvim"), -- lots of tools
  gh("ibhagwan/fzf-lua"), -- search tool
  gh("christoomey/vim-tmux-navigator"), -- tmux integration
  gh("lewis6991/gitsigns.nvim"), -- git
  gh("echasnovski/mini.pairs"), -- auto pair
  gh("echasnovski/mini.surround"), -- surround
  gh("folke/flash.nvim"), -- fast motion
  -- lsp
  gh("neovim/nvim-lspconfig"), -- lsp config file
  gh("mason-org/mason.nvim"), -- lsp downloader
  gh("stevearc/conform.nvim"), -- format
  gh("mfussenegger/nvim-lint"), -- lint
  -- debug
  gh("mfussenegger/nvim-dap"), -- dap
  gh("theHamsta/nvim-dap-virtual-text"),
  -- completion
  gh("xzbdmw/colorful-menu.nvim"), -- colorful completion menu
  { src = gh("saghen/blink.cmp"), vim.version.range("1.*") }, -- completion engine
})

-- 3. Plugins config
vim.g.gruvbox_material_transparent_background = 1
vim.cmd.colorscheme("gruvbox-material")

require("nvim-web-devicons").setup({})
require("config.snacks")
require("config.fzf-lua")
require("which-key").setup({ preset = "helix" })
require("config.vim-tmux-navigator")
require("config.gitsigns")
require("config.noice")
require("mini.pairs").setup({})
require("dropbar").setup({})
require("config.surround")
require("config.todo-comments")
require("config.flash")
require("config.lualine")
require("colorful-menu").setup({})
require("config.lsp")
require("mason").setup({})
require("config.conform")
require("config.nvim-lint")
require("config.debug")
require("config.blink-cmp")

-- 4. Load keymaps & autocmds after plugins
require("keymaps")
require("autocmds")
