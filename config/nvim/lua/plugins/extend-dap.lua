return {

  -- {
  --   "rcarriga/nvim-dap-ui",
  --   opts = {
  --     icons = { expanded = "", collapsed = "", circular = "" },
  --     layouts = {
  --       {
  --         elements = {
  --           { id = "repl", size = 0.3 },
  --           { id = "breapoints", size = 0.2 },
  --           { id = "stacks", size = 0.3 },
  --           { id = "console", size = 0.2 },
  --         },
  --         position = "right",
  --         size = 50,
  --       },
  --       {
  --         elements = {
  --           { id = "scopes", size = 0.5 },
  --           { id = "watches", size = 0.5 },
  --         },
  --         position = "bottom",
  --         size = 20,
  --       },
  --     },
  --   },
  --   dependencies = {
  --     "nvim-neotest/nvim-nio",
  --   },
  -- },

  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "ibhagwan/fzf-lua",
    },
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
          },
        },
      }

      dap.configurations.c = dap.configurations.cpp
    end,
  },
}
