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
                lualine     = true,
            },
        },
    },

    -- lualine 状态栏主题
    -- catppuccin 已移除名为 "catppuccin" 的 lualine 主题（现按 flavour 拆分为
    -- catppuccin-mocha / catppuccin-nvim 等）。某处把 lualine 主题设成了已不存在的
    -- "catppuccin"，导致启动告警。改用 "auto"：它会自动从当前 catppuccin(mocha)
    -- 高亮派生配色，且 lualine 对 "auto" 不会发出 theme-not-found 告警。
    {
        "nvim-lualine/lualine.nvim",
        opts = function(_, opts)
            opts.options = opts.options or {}
            opts.options.theme = "auto"
        end,
    },

}
