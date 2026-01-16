return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    opts = {
      server = {
        settings = {
          ["rust-analyzer"] = {
            check = { command = "clippy" },
            cargo = { features = "all", allTargets = false },
            procMacro = { enable = true },
            inlayHints = {
              bindingModeHints = { enable = false },
              closingBraceHints = { minLines = 25 },
              typeHints = {
                hideClosureInitialization = true,
                hideNamedConstructor = true,
              },
              implicitDrops = { enable = true },
              lifetimeElisionHints = {
                enable = "always",
                useParameterNames = true,
              },
            },
            imports = {
              granularity = {
                group = "module",
              },
              prefix = "self",
            },
          },
        },
      },
    },
  },

  -- Rust Formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt" },
      },
    },
  },

  -- Ensure Rust tools are installed
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "rust-analyzer", "codelldb" })
    end,
  },
}
