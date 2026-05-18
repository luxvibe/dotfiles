-- telescope：覆盖 LazyVim 默认配置
return {
    {
        "nvim-telescope/telescope.nvim",
        opts = {
            defaults = {
                file_ignore_patterns = { "node_modules", ".git", "vendor", "__pycache__" },
            },
            pickers = {
                find_files = { hidden = true },
                live_grep  = { additional_args = { "--hidden" } },
            },
        },
    },
}
