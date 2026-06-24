-- UI 覆盖：主题 Catppuccin Mocha
return {
    -- Catppuccin 主题（LazyVim 默认是 tokyonight，覆盖为 catppuccin）
    {
        "catppuccin/nvim",
        name     = "catppuccin",
        lazy     = false,
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

}
