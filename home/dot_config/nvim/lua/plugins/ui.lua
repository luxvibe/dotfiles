-- UI 覆盖：主题 Catppuccin Mocha
return {
    -- Catppuccin 主题（LazyVim 默认是 tokyonight，覆盖为 catppuccin）
    {
        "catppuccin/nvim",
        name     = "catppuccin",
        priority = 1000,
        opts = {
            flavour = "mocha",
            integrations = {
                telescope   = true,
                gitsigns    = true,
                which_key   = true,
                mason       = true,
                treesitter  = true,
                mini        = { enabled = true },
                noice       = true,
                notify      = true,
            },
        },
    },

    -- lualine：覆盖主题为 catppuccin
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                theme = "catppuccin",
            },
        },
    },
}
