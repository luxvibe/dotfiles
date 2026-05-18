-- treesitter：补充 LazyVim 默认未包含的语言
return {
    {
        "nvim-treesitter/nvim-treesitter",
        opts = {
            ensure_installed = {
                -- LazyVim extras 已覆盖大部分，补充以下
                "kotlin", "php", "ruby",
                "sql", "regex",
                "dockerfile", "toml",
            },
        },
    },
}
