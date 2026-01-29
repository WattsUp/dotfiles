vim.api.nvim_create_autocmd("FileType", {
  pattern = { "jinja" },
  callback = function()
    vim.cmd("set syntax=htmldjango")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "make" },
  callback = function()
    vim.cmd("setlocal noexpandtab")
  end,
})
