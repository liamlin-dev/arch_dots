require("noice").setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },

    progress = { enabled = true },

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
})

local keymap = vim.keymap.set

keymap("n", "<leader>nn", "<cmd>Noice<cr>", { desc = "Noice Messages" })
keymap("n", "<leader>nl", "<cmd>Noice last<cr>", { desc = "Noice Last Message" })
keymap("n", "<leader>nh", "<cmd>Noice history<cr>", { desc = "Noice History" })
keymap("n", "<leader>na", "<cmd>Noice all<cr>", { desc = "Noice All" })
keymap("n", "<leader>nd", "<cmd>Noice dismiss<cr>", { desc = "Dismiss All Notifications" })
keymap("n", "<leader>nt", "<cmd>Noice fzf<cr>", { desc = "Noice FzfLua" })
