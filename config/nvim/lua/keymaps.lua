-- Neovim Keymaps

local keymap = vim.keymap.set

-- Better copy & paste
keymap("n", "x", [["_x]], { desc = "Delete Character without yanking" })
keymap("x", "x", [["_d]], { desc = "Delete Selection without yanking" })
keymap("x", "p", [["_dP]], { desc = "Paste without overwriting register" })

-- Move Lines
keymap("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
keymap("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
keymap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
keymap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
keymap("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
keymap("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- Buffers
keymap("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
keymap("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
keymap("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer" })
keymap("n", "<leader>bD", "<cmd>bdelete<cr>", { desc = "Delete Buffer and Window" })

-- Clear search
keymap({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- Search (saner n/N behavior)
keymap("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
keymap("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
keymap("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
keymap("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
keymap("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
keymap("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Save file
keymap("n", "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Keywordprg
keymap("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- Better indenting
keymap("x", "<", "<gv")
keymap("x", ">", ">gv")

-- Lazy
keymap("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- New file
keymap("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- Location list
keymap("n", "<leader>xl", function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Location List" })

-- Quickfix list
keymap("n", "<leader>xq", function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Quickfix List" })

keymap("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
keymap("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- Formatting
keymap({ "n", "x" }, "<leader>cf", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format" })

-- Diagnostics
local diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end
keymap("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
keymap("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
keymap("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
keymap("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
keymap("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
keymap("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
keymap("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- Quit
keymap("n", "<leader>q", "<cmd>qa<cr>", { desc = "Quit Neovim" })
keymap("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Force Quit" })

-- Windows --
keymap("n", "<leader>ww", "<C-W>p", { desc = "Other Window", remap = true })
keymap("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
keymap("n", "<leader>ws", "<C-W>s", { desc = "Split Below", remap = true })
keymap("n", "<leader>wv", "<C-W>v", { desc = "Split Right", remap = true })
-- map("n", "<leader>wh", "<C-W>h", { desc = "Go Left", remap = true })
-- map("n", "<leader>wj", "<C-W>j", { desc = "Go Down", remap = true })
-- map("n", "<leader>wk", "<C-W>k", { desc = "Go Up", remap = true })
-- map("n", "<leader>wl", "<C-W>l", { desc = "Go Right", remap = true })
keymap("n", "<leader>wo", "<C-W>o", { desc = "Only Window", remap = true })
keymap("n", "<leader>w=", "<C-W>=", { desc = "Equal Size", remap = true })
keymap("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
keymap("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
