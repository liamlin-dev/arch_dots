return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      {
        "xzbdmw/colorful-menu.nvim",
        config = true,
      },
      "kristijanhusak/vim-dadbod-completion",
      "archie-judd/blink-cmp-words",
    },
    opts = function(_, opts)
      local util = require("util.blink")

      return {
        sources = {
          -- `lsp`, `buffer`, `snippets`, `path` and `omni` are built-in
          default = { "lsp", "buffer", "snippets", "path", "dictionary" },

          per_filetype = {
            sql = { "snippets", "dadbod", "buffer" },
            lua = { inherit_defaults = true, "lazydev" },
          },

          providers = {
            dadbod = { module = "vim_dadbod_completion.blink" },
            lazydev = util.providers.lazydev,
            dictionary = util.providers.dictionary,
          },
        },

        completion = {
          keyword = { range = "full" },
          accept = { auto_brackets = { enabled = true } },
          list = { selection = { preselect = true, auto_insert = true } },
          ghost_text = { enabled = false }, -- conflict with menu auto show
          menu = util.menu,
          documentation = util.doc,
        },

        cmdline = {
          enabled = true,
          keymap = {
            preset = "inherit",
          },
          completion = { menu = { auto_show = true } },
        },

        signature = {
          enabled = false, -- Let Noice handle signature help
        },

        keymap = {
          preset = "default",
        },
      }
    end,
  },
}
