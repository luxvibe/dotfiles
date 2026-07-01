-- UI 覆盖：主题 Tokyo Night
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      light_style = "day",
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
    -- LazyVim 应用 colorscheme 的时机早于 transparent opts 完全生效，
    -- 导致 colorscheme 以「不透明」状态应用且之后不再刷新，透明看不出来。
    -- 这里在 setup 后立即重设一次 colorscheme，确保透明落实到 Normal 等高亮。
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  {
    "catppuccin/nvim",
    enabled = false,
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options = opts.options or {}
      opts.options.theme = "tokyonight"
    end,
  },
}