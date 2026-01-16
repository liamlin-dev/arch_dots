return {
  -- C++ LSP (Clangd)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
            fallbackFlags = { "--std=c++20", "-Wall", "-Wextra" },
          },
        },
      },
    },
    -- C++ specific keymaps
    keys = {
      { "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", desc = "Switch Header/Source" },
    },
  },

  -- C++ Formatting (clang-format)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
    },
  },

  -- C++ Debugging (cppdbg via Mason)
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      local utils = require("util.dap")

      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7",
      }

      dap.configurations.cpp = {
        {
          name = "Launch (GDB)",
          type = "cppdbg",
          request = "launch",
          program = utils.get_executable,
          cwd = "${workspaceFolder}",
          stopAtEntry = false,
          setupCommands = {
            { text = "-enable-pretty-printing", description = "Enable pretty printing", ignoreFailures = false },
            { text = "set follow-fork-mode child", description = "Follow fork", ignoreFailures = true },
          },
        },
        {
          name = "Attach to Process",
          type = "cppdbg",
          request = "attach",
          processId = require("dap.utils").pick_process,
          program = utils.get_executable,
          cwd = "${workspaceFolder}",
        },
      }
      dap.configurations.c = dap.configurations.cpp
    end,
  },

  -- Treesitter for C++
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "c", "cpp", "cmake" })
    end,
  },

  -- Mason: ensure C++ tools installed
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "clangd", "clang-format", "cpptools" })
    end,
  },
}
