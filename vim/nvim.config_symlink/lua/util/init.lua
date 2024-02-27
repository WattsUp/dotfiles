local LazyUtil = require("lazy.core.util")

local M = setmetatable({}, {
  __index = function(t, k)
    if LazyUtil[k] then
      return LazyUtil[k]
    end
    t[k] = require("util." .. k)
    return t[k]
  end,
})

function M.is_win()
  return vim.loop.os_uname().sysname:find("Windows") ~= nil
end

function M.on_load(name, fn)
  local Config = require("lazy.core.config")
  if Config.plugins[name] and Config.plugins[name]._.loaded then
    fn(name)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

function M.has(plugin)
  return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

return M
