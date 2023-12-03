local Util = require("util")

return {
  {
    "mfussenegger/nvim-lint",
    event = "LazyFile",
    opts = {
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        javascript = { "eslint" },
        json = { "jsonlint" },
        lua = { "luacheck" },
        python = { "ruff" },
        yaml = { "yamllint" },
      },
    },
    config = function(_, opts)
      local M = {}

      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd(opts.events, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
