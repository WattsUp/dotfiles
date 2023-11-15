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

return M
