require("fzf-lua").setup({
  winopts = {
    height = 0.85,
    width = 0.80,
    preview = { default = "bat" },
  },
})

require("fzf-lua").register_ui_select()

local keymap = vim.keymap.set

-- Find
keymap("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find Files" })
keymap("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", { desc = "Recent Files" })
keymap("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { desc = "Buffers" })
keymap("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", { desc = "Grep" })
keymap("n", "<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", { desc = "Document Symbols" })
keymap("n", "<leader>fS", "<cmd>FzfLua lsp_workspace_symbols<cr>", { desc = "Workspace Symbols" })
keymap("n", "<leader>fx", "<cmd>FzfLua diagnostics_document<cr>", { desc = "Diagnostics Document" })
keymap("n", "<leader>fX", "<cmd>FzfLua diagnostics_workspace<cr>", { desc = "Diagnostics Workspace" })

-- Git
-- keymap("n", "<leader>gc", "<cmd>FzfLua git_commits<cr>", { desc = "Git Commits" })
-- keymap("n", "<leader>gs", "<cmd>FzfLua git_status<cr>", { desc = "Git Status" })

-- LSP
keymap("n", "gd", "<cmd>FzfLua lsp_definitions<cr>", { desc = "Go to Definition" })
keymap("n", "gr", "<cmd>FzfLua lsp_references<cr>", { desc = "Go to References" })
keymap("n", "gi", "<cmd>FzfLua lsp_implementations<cr>", { desc = "Go to Implementation" })
keymap("n", "gt", "<cmd>FzfLua lsp_typedefs<cr>", { desc = "Go to Type Definition" })

-- Misc
keymap("n", "<leader>:", "<cmd>FzfLua command_history<cr>", { desc = "Command History" })
keymap("n", "<leader>/", "<cmd>FzfLua live_grep<cr>", { desc = "Grep" })
