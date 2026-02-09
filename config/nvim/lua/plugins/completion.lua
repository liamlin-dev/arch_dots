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
          enabled = true, -- 用原生的就好
        },

        keymap = {
          preset = "none",

          ["<C-/>"] = { "show", "show_documentation", "hide_documentation" },
          ["<C-e>"] = { "hide", "fallback" },
          ["<C-y>"] = { "select_and_accept", "fallback" },

          ["<Up>"] = { "select_prev", "fallback" },
          ["<Down>"] = { "select_next", "fallback" },
          ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
          ["<C-n>"] = { "select_next", "fallback_to_mappings" },

          ["<C-b>"] = { "scroll_documentation_up", "fallback" },
          ["<C-f>"] = { "scroll_documentation_down", "fallback" },

          ["<Tab>"] = { "snippet_forward", "fallback" },
          ["<S-Tab>"] = { "snippet_backward", "fallback" },

          ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
          ["<C-u>"] = { "scroll_signature_up", "fallback" },
          ["<C-d>"] = { "scroll_signature_down", "fallback" },
        },
      }
    end,
  },
}
