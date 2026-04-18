local M = {}

local EXCLUDE_PATTERNS = {
  -- 目錄
  "_deps",
  "CMakeFiles",
  ".git",
  -- 副檔名
  "*.py",
  "*.sh",
  "*.cmake",
  "*.txt",
  "*.json",
}

function get_executable()
  local dap = require("dap")
  local fzf = require("fzf-lua")

  local exclude_args = ""
  for _, pattern in ipairs(EXCLUDE_PATTERNS) do
    exclude_args = exclude_args .. string.format(" --exclude %q", pattern)
  end

  return coroutine.create(function(coro)
    local cmd = string.format("fd -tx%s . build/", exclude_args)

    fzf.fzf_exec(cmd, {
      prompt = "Debug Executable> ",
      winopts = {
        height = 0.4,
        width = 0.6,
        row = 0.5,
      },
      actions = {
        ["default"] = function(selected)
          -- 處理 ESC
          if not selected or #selected == 0 then
            coroutine.resume(coro, dap.ABORT)
            return
          end

          -- 移除 fzf 可能產生的首尾空白或索引文字
          -- fzf-lua 預設回傳第一個元素即為路徑
          local entry = selected[1]
          local path = entry:match("^%s*(.-)%s*$")

          -- 轉換為絕對路徑
          local full_path = vim.fn.getcwd() .. "/" .. path

          coroutine.resume(coro, full_path)
        end,
      },
    })
  end)
end

M.set_cpp = function()
  local dap = require("dap")

  dap.adapters.cppdbg = {
    id = "cppdbg",
    type = "executable",
    command = vim.fn.stdpath("data") .. "/mason/bin/OpenDebugAD7",
  }

  dap.configurations.cpp = {
    {
      name = "Launch (GDB)",
      type = "cppdbg",
      request = "launch",
      program = get_executable,
      cwd = "${workspaceFolder}",
      stopAtEntry = true,
      setupCommands = {
        { text = "-enable-pretty-printing", description = "Enable pretty printing", ignoreFailures = false },
        { text = "set follow-fork-mode child", description = "Follow fork", ignoreFailures = true },
      },
    },
    {
      name = "Attach to Process",
      type = "cppdbg",
      request = "attach",
      processId = require("dap.utils").pick_process,
      program = get_executable,
      cwd = "${workspaceFolder}",
    },
  }
  dap.configurations.c = dap.configurations.cpp
end

return M
