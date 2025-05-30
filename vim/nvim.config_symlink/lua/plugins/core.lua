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
        jinja = { "djlint" },
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
    },
  },
}
