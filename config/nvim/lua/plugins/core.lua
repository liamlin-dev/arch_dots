return {
  -- Core
  "nvim-lua/plenary.nvim",
  "MunifTanjim/nui.nvim",

  -- UI
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    lazy = false,
    opts = {
      -- stylua: ignore start
      ensure_installed = {
        "bash", "c", "cpp", "lua", "luadoc", "markdown", "markdown_inline", "python",
        "rust", "vim", "vimdoc", "json", "yaml", "cmake"
      },
      -- stylua: ignore end
      highlight = { enable = true },
      indent = { enable = true },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]a"] = "@parameter.inner",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[a"] = "@parameter.inner",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
  },

  -- LSP (Moved to lsp.lua)
  -- Mason (Moved to lsp.lua)
  -- Completion (blink.cmp in completion.lua)

  -- FZF-Lua (Unified Picker)
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    keys = {
      -- Files
      { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent Files" },
      { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
      -- Search
      { "<leader>sg", "<cmd>FzfLua live_grep<cr>", desc = "Grep" },
      { "<leader>sw", "<cmd>FzfLua grep_cword<cr>", desc = "Grep Word" },
      { "<leader>sW", "<cmd>FzfLua grep_cWORD<cr>", desc = "Grep WORD" },
      { "<leader>ss", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Document Symbols" },
      { "<leader>sS", "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },
      -- Git
      { "<leader>gc", "<cmd>FzfLua git_commits<cr>", desc = "Git Commits" },
      { "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Git Status" },
      -- LSP
      { "gd", "<cmd>FzfLua lsp_definitions<cr>", desc = "Go to Definition" },
      { "gr", "<cmd>FzfLua lsp_references<cr>", desc = "Go to References" },
      { "gi", "<cmd>FzfLua lsp_implementations<cr>", desc = "Go to Implementation" },
      { "gt", "<cmd>FzfLua lsp_typedefs<cr>", desc = "Go to Type Definition" },
      -- Misc
      { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
      { "<leader>/", "<cmd>FzfLua live_grep<cr>", desc = "Grep" },
      { "<leader><space>", "<cmd>FzfLua files<cr>", desc = "Find Files" },
    },
    opts = {
      winopts = {
        height = 0.85,
        width = 0.80,
        preview = { default = "bat" },
      },
    },
    config = function(_, opts)
      require("fzf-lua").setup(opts)
      require("fzf-lua").register_ui_select()
    end,
  },

  -- WhichKey
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
    },
  },

  -- Git
  { "lewis6991/gitsigns.nvim", opts = {} },
}
