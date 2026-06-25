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
            transparent_background = true,  -- 背景透明，透出 Ghostty 的透明/模糊
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
        -- LazyVim 应用 colorscheme 的时机早于 transparent opts 完全生效，
        -- 导致 colorscheme 以「不透明」状态应用且之后不再刷新，透明看不出来。
        -- 这里在 setup 后立即重设一次 colorscheme，确保透明落实到 Normal 等高亮。
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
        end,
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
