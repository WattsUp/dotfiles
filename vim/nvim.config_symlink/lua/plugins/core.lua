local logo = [[
|
|
|     ▗▄                                                       |
|      █▖                                                      |
|      ▐▙                                                      |
|      ▝█                                                      |
|       █▌                                                     |
|       ▜▌                                                     |
|       ▐▌                                                     |
|      ▄▄▄▄▄▄▄▄▄▄▄▄▄▄                                          |
|    ▟▛▀           ▀▀▀█▄       ▄                               |
|    ▜▙▄▟▙            ▗▟█▄▄▟▛▀▀▘            ██▌                |
|      ▀█▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▝█        ▄▄▖    ▄▄▖▄▄▖ ▄▄ ▄▄▄  ▗▄▄▄   |
|       █▘               █▌       ▝██▖  ▗█▛ ██▌ ██▛▀▀▜█▟▛▀▀██▖ |
|      ▐█               ▗█         ▐█▙ ▗██▘ ██▌ ██▌  ▐██   ██▌ |
|  ▄█▀▜█▙▖             ▗█▘          ▜█▌▟█▘  ██▌ ██▌  ▐██   ██▌ |
| ▐█  ▗▛ ▀▀▜▄▄▄▄    ▄▄█▀             ▜██▌   ██▌ ██▌  ▐██   ██▌ |
|  ▀▀▀▀       ▝▀▀▀ ▝▀                 ▀▀    ▀▀▘ ▀▀▘  ▝▀▀   ▀▀▘ |
|
|
]]

local header = vim.split(logo, "\n")
for i, line in ipairs(header) do
  header[i] = string.sub(line, (string.find(line, "|") or 0) + 1, #line - 1)
end

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "snacks.nvim",
    opts = {
      dashboard = { preset = { header = table.concat(header, "\n") } },
      picker = {
        sources = {
          explorer = {
            auto_close = true,
            layout = {
              layout = { position = "right" },
            },
          },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        css = { "prettier" },
        jinja = { "prettier" },
        python = { "isort", "black" },
        yaml = { "yamlfmt" },
        toml = { "taplo" },
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    opts = {
      highlight = {
        -- Pattern to match TODO (<author>):
        pattern = [[.*<((KEYWORDS)\s*(\(.+\))?):]],
      },
      search = {
        pattern = [[\b(KEYWORDS)\b]],
      },
    },
  },
  {
    "folke/flash.nvim",
    opts = {
      modes = {
        char = {
          enabled = false,
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "<c-k>", mode = { "i" }, false }

      opts.inlay_hints = { enabled = false }
      return opts
    end,
  },
  {
    "mason.nvim",
    opts = {
      ensure_installed = {
        "yamlfmt",
        "yamllint",
      },
    },
  },
}
