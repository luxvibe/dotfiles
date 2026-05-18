-- git：gitsigns 由 LazyVim 内置，此处只覆盖配置
return {
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add          = { text = "▎" },
                change       = { text = "▎" },
                delete       = { text = "" },
                topdelete    = { text = "" },
                changedelete = { text = "▎" },
            },
            current_line_blame      = false,
            current_line_blame_opts = { delay = 500 },
        },
    },
}
