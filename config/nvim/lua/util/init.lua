local M = {}

M.root_patterns = { ".git", "lua" }

---@param plugin string
function M.has(plugin)
  local Config = require("lazy.core.config")
  return Config.spec.plugins[plugin] ~= nil
end

---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      fn()
    end,
  })
end

---@param name string
function M.opts(name)
  local plugin = require("lazy.core.config").spec.plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

function M.is_win()
  return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

return M
