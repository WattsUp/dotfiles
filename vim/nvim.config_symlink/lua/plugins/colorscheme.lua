return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    opts = {
      integrations = {
        neotree = true,
        which_key = true,
      },
    },
    config = function()
      vim.cmd("colorscheme catppuccin")
    end,
  },
}
