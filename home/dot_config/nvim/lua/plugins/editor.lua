-- 编辑器增强：文件管理、lazygit
return {
    -- mini.files：轻量文件管理器（LazyVim 默认用 neo-tree，保留 mini.files 作为补充）
    {
        "nvim-mini/mini.files",
        version = false,
        keys = {
            {
                "<leader>n",
                function()
                    require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
                end,
                desc = "Files (current)",
            },
            {
                "<leader>N",
                function()
                    require("mini.files").open(vim.uv.cwd(), true)
                end,
                desc = "Files (cwd)",
            },
        },
        opts = {
            windows = {
                preview      = true,
                width_focus  = 30,
                width_preview = 50,
            },
            options = {
                use_as_default_explorer = false,
            },
        },
    },

    -- lazygit：TUI git 客户端
    {
        "kdheepak/lazygit.nvim",
        cmd          = "LazyGit",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        },
    },
}
