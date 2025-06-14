vim.api.nvim_create_autocmd("FileType", {
  pattern = { "jinja" },
  callback = function()
    vim.cmd("set syntax=htmldjango")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript" },
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
  end,
})
