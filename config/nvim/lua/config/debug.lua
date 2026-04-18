local dap = require("dap")

local keymap = vim.keymap.set

-- stylua: ignore start
-- F-keys
keymap("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
keymap("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
keymap("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
keymap("n", "<F23>", dap.step_out, { desc = "Debug: Step Out (Shift+F11)" })
keymap("n", "<F9>", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
keymap("n", "<F17>", dap.terminate, { desc = "Debug: Stop (Shift+F5)" })

-- GDB like
keymap("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Breakpoint (b)" })
keymap("n", "<leader>dc", dap.continue, { desc = "Debug: Continue (c)" })
keymap("n", "<leader>dn", dap.step_over, { desc = "Debug: Next (n)" })
keymap("n", "<leader>ds", dap.step_into, { desc = "Debug: Step (s)" })
keymap("n", "<leader>do", dap.step_out, { desc = "Debug: Out (fin)" })
keymap("n", "<leader>dq", dap.terminate, { desc = "Debug: Terminate" })
keymap("n", "<leader>dr", dap.repl.toggle, { desc = "Debug: Toggle REPL" })

-- widgets
local widgets = require("dap.ui.widgets")
keymap({ "n", "v" }, "<leader>dh", widgets.hover, { desc = "Debug: Hover Variables" })
keymap({ "n", "v" }, "<leader>dp", widgets.preview, { desc = "Debug: Preview Variables" })
keymap("n", "<leader>dS", function() widgets.centered_float(widgets.scopes) end, { desc = "Debug: Scopes" })
keymap("n", "<leader>df", function() widgets.centered_float(widgets.frames) end, { desc = "Debug: Call Stack" })
keymap("n", "<leader>dt", function() widgets.centered_float(widgets.threads) end, { desc = "Debug: Threads" })
-- stylua: ignore end

require("nvim-dap-virtual-text").setup({ enabled = true })

vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" }) -- Highlight the line where execution stopped
local icons = {
  Stopped = { "", "DiagnosticWarn", "DapStoppedLine" },
  Breakpoint = { "", "DiagnosticError" },
  BreakpointCondition = "",
  BreakpointRejected = { "", "DiagnosticError" },
  LogPoint = ".>",
}

for name, sign in pairs(icons) do
  sign = type(sign) == "table" and sign or { sign }
  vim.fn.sign_define(
    "Dap" .. name,
    { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
  )
end

local util = require("util.dap")
util.set_cpp()
