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

require("config").setup()

local opts = {
  checker = { enabled = true }, -- automatically check for plugin updates
  ui = {
    border = "rounded",
    icons = BVim.config.icons.lazy,
  },
}

require("lazy").setup("plugins", opts)
