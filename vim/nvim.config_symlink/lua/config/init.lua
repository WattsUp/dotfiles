_G.BVim = require("util")

local M = {}

BVim.config = M

local options = {
  icons = {
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
      Warn = " ",
      Hint = " ",
      Info = " ",
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
    kinds = {
      Array = " ",
      Boolean = " ",
      Class = " ",
      Color = " ",
      Control = " ",
      Collapsed = " ",
      Constant = " ",
      Comment = "//",
      Constructor = " ",
      Copilot = " ",
      Enum = " ",
      EnumMember = " ",
      Event = " ",
      Field = " ",
      File = " ",
      Folder = " ",
      Function = "ƒ ",
      Interface = " ",
      Key = " ",
      Keyword = " ",
      Method = "ƒ ",
      Module = " ",
      Namespace = " ",
      Null = " ",
      Number = " ",
      Object = " ",
      Operator = " ",
      Package = " ",
      Property = " ",
      Reference = " ",
      Snippet = " ",
      String = " ",
      Struct = " ",
      Text = " ",
      TypeParameter = " ",
      Unit = " ",
      Value = " ",
      Variable = " ",
    },
  },
}

local lazy_clipboard

function M.setup()
  local lazy_autocmds = vim.fn.argc(-1) == 0
  if not lazy_autocmds then
    M.load("autocmds")
  end

  local group = vim.api.nvim_create_augroup("BVim", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "VeryLazy",
    callback = function()
      if lazy_autocmds then
        M.load("autocmds")
      end
      M.load("keymaps")
      if lazy_clipboard ~= nil then
        vim.opt.clipboard = lazy_clipboard
      end
    end,
  })
end

function M.load(name)
  local function _load(mod)
    if require("lazy.core.cache").find(mod)[1] then
      BVim.try(function()
        require(mod)
      end, { msg = "Failed loading " .. mod })
    end
  end

  local pattern = "BVim" .. name:sub(1, 1):upper() .. name:sub(2)
  _load("config." .. name)
  if vim.bo.filetype == "lazy" then
    vim.cmd([[do VimResized]])
  end
  vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
end

M.did_init = false
function M.init()
  if M.did_init then
    return
  end
  M.did_init = true

  BVim.lazy_notify()

  M.load("options")

  lazy_clipboard = vim.opt.clipboard
  vim.opt.clipboard = ""

  BVim.plugin.setup()
end

setmetatable(M, {
  __index = function(_, key)
    return options[key]
  end,
})

return M
