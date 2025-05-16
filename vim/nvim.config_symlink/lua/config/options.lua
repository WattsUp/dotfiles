local opt = vim.opt

-- Search
opt.ignorecase = true
opt.incsearch = true -- incremental
opt.smartcase = true
opt.hlsearch = true -- highlight
opt.completeopt = "menu,menuone,noselect"

-- Indents, spaces
opt.autoindent = true
opt.smartindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.shiftround = true

-- UI
opt.number = true -- line numbers
opt.relativenumber = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.scrolloff = 2
opt.sidescrolloff = 10
opt.laststatus = 3
opt.list = true -- hidden characters
opt.confirm = true -- exiting modified buffer
opt.pumheight = 10 -- max number of entries in a popup
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
end
vim.g.snacks_animate = true

-- Text
opt.textwidth = 0
opt.wrap = false
opt.linebreak = true
opt.breakindent = true

-- Folding
opt.foldenable = false

-- Clipboard
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"

-- Keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
opt.backspace = { "indent", "eol", "start" }
opt.mouse = "a"

-- Cursor
opt.cursorline = true
opt.cursorcolumn = false

-- Spelling
opt.spelllang = { "en" }

-- Split
opt.splitright = true
opt.splitbelow = true

-- Persistent undo
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
