-- require("vim-tmux-navigator").setup({})

local keymap = vim.keymap.set

-- Tmux Navigation
keymap("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Navigate Left" })
keymap("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Navigate Down" })
keymap("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Navigate Up" })
keymap("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Navigate Right" })
keymap("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", { desc = "Navigate Previous" })
