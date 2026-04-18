local providers = {
  -- dictionary = {
  --   name = "blink-cmp-words",
  --   module = "blink-cmp-words.dictionary",
  --   opts = {
  --     score_offset = 0,
  --     -- 觸發補全所需的字元數量。
  --     dictionary_search_threshold = 3,
  --     definition_pointers = { "!", "&", "^" },
  --   },
  -- },
}

local menu = {
  auto_show = true,
  border = "single",
  draw = {
    columns = { { "kind_icon" }, { "label", "source_id", gap = 1 } },
    components = {
      label = {
        text = function(ctx)
          return require("colorful-menu").blink_components_text(ctx)
        end,
        highlight = function(ctx)
          return require("colorful-menu").blink_components_highlight(ctx)
        end,
      },
    },
    treesitter = { "lsp" },
  },
}

local doc = {
  window = {
    border = "single",
  },
  auto_show = true,
  auto_show_delay_ms = 100,
}

local opt = {
  sources = {
    -- `lsp`, `buffer`, `snippets`, `path` and `omni` are built-in
    default = { "lsp", "buffer", "snippets", "path" },

    per_filetype = {
      sql = { "snippets", "dadbod", "buffer" },
      lua = { inherit_defaults = true },
    },

    providers = {
      dadbod = { module = "vim_dadbod_completion.blink" },
      dictionary = providers.dictionary,
    },
  },

  completion = {
    keyword = { range = "full" },
    accept = { auto_brackets = { enabled = true } },
    list = { selection = { preselect = true, auto_insert = true } },
    ghost_text = { enabled = false }, -- conflict with menu auto show
    menu = menu,
    documentation = doc,
  },

  cmdline = {
    enabled = true,
    keymap = {
      preset = "inherit",
    },
    completion = { menu = { auto_show = true } },
  },

  signature = {
    enabled = true, -- 用 lsp_signature
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

require("blink.cmp").setup(opt)
