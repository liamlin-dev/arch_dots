return {
  {
    "rcarriga/nvim-dap-ui",
    -- stylua: ignore start
    keys = {
      { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI", },
      { "<leader>dp", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" }, },
    },
    -- stylua: ignore end
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
            { id = "console", size = 0.2 },
          },
          position = "right",
          size = 45,
        },
        {
          elements = {
            -- REPL 是你現在的新戰場，給它最大空間輸入 -exec 指令
            { id = "repl", size = 0.5 },
            { id = "stacks", size = 0.5 },
            -- Call Stack 放在底部很適合，因為函數名稱通常很長
            -- Console 看程式原本的 stdout
            -- 把 Breakpoints 拿掉或隱藏，因為通常直接看程式碼行號旁的紅點就夠了
          },
          position = "bottom",
          -- 高度設為 12~15，保證你看得到 hexdump 的輸出
          size = 15,
        },
      },
      -- 浮動視窗設定 (當你按 <leader>de 時出現的視窗)
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

  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "ibhagwan/fzf-lua",
    },
    -- stylua: ignore start
    keys = {
      -- 1. 常用控制 (對應 GDB 指令)
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      { "<F23>", function() require("dap").step_out() end, desc = "Debug: Step Out" }, -- Shift + F11 = F22
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
      { "<F17>", function() require("dap").terminate() end, desc = "Debug: Stop" }, -- Shift+F5 = F17 停止

      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Breakpoint (b)" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Debug: Continue (c)" },
      { "<leader>dn", function() require("dap").step_over() end, desc = "Debug: Next (n)" },
      { "<leader>ds", function() require("dap").step_into() end, desc = "Debug: Step (s)" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Debug: Out (fin)" }, -- 用 o 代表 Out, 避免與 Find 衝突

      -- 2. HFT/進階場景必備
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Debug: REPL" }, -- 呼叫 REPL 輸入 GDB 指令
      { "<leader>dq", function() require("dap").terminate() end, desc = "Debug: Terminate" }, -- 停止
    },
    -- stylua: ignore end
    opts = function()
      local dap = require("dap")
      local utils = require("utils.dap")

      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7",
      }

      dap.configurations.cpp = {
        {
          name = "Launch GDB via cpptools",
          type = "cppdbg",
          request = "launch",
          program = utils.get_executable,
          cwd = "${workspaceFolder}",
          stopAtEntry = false,
          setupCommands = {
            {
              text = "-enable-pretty-printing",
              description = "enable pretty printing",
              ignoreFailures = false,
            },
            {
              text = "set follow-fork-mode child",
              description = "follow fork",
              ignoreFailures = true,
            },
          },
        },
        {
          name = "Attach to Process",
          type = "cppdbg",
          request = "attach",
          processId = require("dap.utils").pick_process,
          program = utils.get_executable,
          cwd = "${workspaceFolder}",
        },
      }

      dap.configurations.c = dap.configurations.cpp
    end,
  },
}
