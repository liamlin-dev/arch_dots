local M = {}
M.env_cleanup = function(venv)
  if string.find(venv, "/") then
    local final_venv = venv
    for w in venv:gmatch("([^/]+)") do
      final_venv = w
    end
    venv = final_venv
  end
  return venv
end

local copilot_status = function()
  local status_c, client = pcall(require, "copilot.client")
  local status_a, api = pcall(require, "copilot.api")
  if not status_c or not status_a then
    return "unknown"
  end

  if client.is_disabled() then
    return "disabled"
  end

  local is_buf_attached = client.buf_is_attached(vim.api.nvim_get_current_buf())
  if is_buf_attached then
    local status, data = pcall(api.status)
    if status and data.status == "warning" then
      return "warning"
    elseif status and data.status == "ok" then
      return "enabled"
    else
      return "sleep"
    end
  end

  return "unknown"
end
M.copilot_status_icon = function()
  local icons = {
    enabled = " ",
    sleep = " ",
    disabled = " ",
    warning = " ",
    unknown = " ",
  }

  return icons[copilot_status()] or icons.unknown
end

M.components = {
  spaces = {
    function()
      return " "
    end,
    padding = 0.3,
  },
}

return M
