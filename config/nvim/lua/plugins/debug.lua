return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "ibhagwan/fzf-lua",
      "theHamsta/nvim-dap-virtual-text",
    },
    -- stylua: ignore
    keys = {
      -- F-keys 配置
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      { "<F23>", function() require("dap").step_out() end, desc = "Debug: Step Out" }, -- Shift + F11 = F23
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
      { "<F17>", function() require("dap").terminate() end, desc = "Debug: Stop" }, -- Shift+F5 = F17

      -- 常用控制 (對應 GDB 指令)
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Breakpoint (b)" },
      { "<leader>dr", function() require("dap").continue() end, desc = "Debug: Run (r)" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Debug: Continue (c)" },
      { "<leader>dn", function() require("dap").step_over() end, desc = "Debug: Next (n)" },
      { "<leader>ds", function() require("dap").step_into() end, desc = "Debug: Step (s)" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Debug: Out (fin)" },
      -- { "<leader>dr", function() require("dap").repl.open() end, desc = "Debug: REPL" },
      { "<leader>dq", function() require("dap").terminate() end, desc = "Debug: Terminate" },
    },
    config = function()
      local dap = require("dap")
      local ui = require("dapui")
      local util = require("util.dap")

      -- Setup Virtual Text
      require("nvim-dap-virtual-text").setup({})

      -- language specific setup
      util.set_cpp()

      -- LazyVim standard icons
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

      -- Auto open/close UI
      -- stylua: ignore start
      dap.listeners.before.attach.dapui_config = function() ui.open() end
      dap.listeners.before.launch.dapui_config = function() ui.open() end
      -- 為了看 log 故不自動關閉
      -- dap.listeners.before.event_terminated.dapui_config = function() ui.close() end
      -- dap.listeners.before.event_exited.dapui_config = function() ui.close() end
      -- stylua: ignore end
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI", },
      { "<leader>dp", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" }, },
    },
    opts = {
      icons = { expanded = "▾", collapsed = "▸", circular = "↺" },
      mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.5 },
            { id = "watches", size = 0.3 },
            { id = "stacks", size = 0.2 },
          },
          position = "right",
          size = 50,
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          position = "bottom",
          size = 15,
        },
      },
      floating = {
        max_height = 0.9,
        max_width = 0.9,
        border = "rounded",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
    },
  },
}
