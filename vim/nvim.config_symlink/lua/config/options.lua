vim.g.snacks_animate = false

-- Allow .nvim.lua to be sourced for project specific settings
vim.opt.exrc = true

if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = "/mnt/c/Scripts/win32yank.exe -i --crlf",
      ["*"] = "/mnt/c/Scripts/win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "/mnt/c/Scripts/win32yank.exe -o --lf",
      ["*"] = "/mnt/c/Scripts/win32yank.exe -o --lf",
    },
    cache_enabled = 0,
  }
end
