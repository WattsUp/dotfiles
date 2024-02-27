local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("core.options")
require("core.keymaps")
require("core.autocommands")
require("core.usercommands")

Util = require("util")
Util.plugin.setup()

local opts = {
  checker = { enabled = true }, -- automatically check for plugin updates
  ui = {
    border = "rounded",
    icons = Util.icons.lazy,
  },
}

require("lazy").setup("plugins", opts)
