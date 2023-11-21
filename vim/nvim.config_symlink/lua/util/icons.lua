M = {
  lazy = {
    cmd = " ",
    config = " ",
    event = "",
    ft = " ",
    init = " ",
    import = " ",
    keys = " ",
    lazy = " ",
    loaded = "",
    not_loaded = "",
    plugin = " ",
    runtime = " ",
    require = " ",
    source = " ",
    start = "",
    task = " ",
    list = {
      "",
      "",
      "",
      "‒",
    },
  },
  diagnostics = {
    Error = " ",
    Warn  = " ",
    Hint  = " ",
    Info  = " ",
  },
  git = {
    -- Change type
    added = " ",
    modified = " ",
    deleted = " ",
    renamed = " ",
    -- Status type
    untracked = "",
    ignored = " ",
    unstaged = " ",
    staged = " ",
    conflict = " ",
  },
}

M.buffer_icon = function()
  local devicons = require("nvim-web-devicons")
  local icon, icon_hl = devicons.get_icon(vim.fn.expand("%:t"))
  if icon then
    return icon, icon_hl
  end

  icon, icon_hl = devicons.get_icon_by_filetype(vim.bo.filetype)
  if icon then
    return icon, icon_hl
  end

  return " ", "DevIconDefault"
end

return M
