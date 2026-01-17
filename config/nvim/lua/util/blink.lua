local M = {}

M.providers = {}

M.providers.lazydev = {
  name = "LazyDev",
  module = "lazydev.integrations.blink",
  score_offset = 100,
}

M.providers.dictionary = {
  name = "blink-cmp-words",
  module = "blink-cmp-words.dictionary",
  opts = {
    score_offset = 0,
    -- 觸發補全所需的字元數量。
    dictionary_search_threshold = 3,
    definition_pointers = { "!", "&", "^" },
  },
}

M.menu = {
  auto_show = true,
  border = "none",
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

M.doc = {
  window = {
    border = "none",
  },
  auto_show = true,
  auto_show_delay_ms = 100,
}

return M
