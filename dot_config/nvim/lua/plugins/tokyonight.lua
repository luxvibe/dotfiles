return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "moon", -- The theme comes in three styles, `storm`, `moon`, a darker `night` and `day`
      transparent = false,
      styles = {
        sidebars = "dark",
        floats = "dark",
      },
    },
  },

  -- Configure LazyVim to use tokyonight
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
