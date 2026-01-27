return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify", -- For popup-style notifications
    },
    keys = {
      { "<leader>nn", "<cmd>Noice<cr>", desc = "Noice Messages" },
      { "<leader>nl", "<cmd>Noice last<cr>", desc = "Noice Last Message" },
      { "<leader>nh", "<cmd>Noice history<cr>", desc = "Noice History" },
      { "<leader>na", "<cmd>Noice all<cr>", desc = "Noice All" },
      { "<leader>nd", "<cmd>Noice dismiss<cr>", desc = "Dismiss All Notifications" },
      { "<leader>nt", "<cmd>Noice fzf<cr>", desc = "Noice FzfLua" },
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },

        -- noice 的 lsp 格式不好看，原生的已經夠好用
        signature = {
          enabled = false,
          view = "hover", -- or "popup"
        },
        hover = {
          enabled = false,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
        inc_rename = true,
      },
      routes = {
        -- Hide "written" messages
        {
          filter = { event = "msg_show", kind = "", find = "written" },
          opts = { skip = true },
        },
      },
      -- Use notify for notifications (popup bubbles)
      notify = {
        enabled = true,
        view = "notify",
      },
      messages = {
        enabled = true,
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
      },
    },
  },
  -- nvim-notify for popup-style notifications
  {
    "rcarriga/nvim-notify",
    lazy = true,
    opts = {
      background_colour = "#000000",
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      stages = "fade_in_slide_out",
      render = "wrapped-compact",
      top_down = true,
    },
  },
}
