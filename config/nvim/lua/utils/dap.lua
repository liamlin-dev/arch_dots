local M = {}

M.get_executable = function()
  local dap = require("dap")
  local fzf = require("fzf-lua")
  return coroutine.create(function(coro)
    fzf.fzf_exec("find build -type f -executable", {
      prompt = "Select Executable> ",
      actions = {
        ["default"] = function(selected)
          if not selected or #selected == 0 then
            coroutine.resume(coro, dap.ABORT)
          else
            coroutine.resume(coro, selected[1])
          end
        end,
      },
    })
  end)
end

return M
