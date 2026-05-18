-- LSP 覆盖：补充 LazyVim extras 未覆盖的服务器配置
return {
    -- mason-lspconfig：补充额外服务器
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
                "bashls",
                "dockerls",
                "marksman",
                "clangd",       -- C/C++ LSP
                "cmake",        -- CMakeLists.txt 支持
            },
        },
    },

    -- nvim-lspconfig：覆盖特定服务器配置
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                gopls = {
                    settings = {
                        gopls = {
                            analyses    = { unusedparams = true },
                            staticcheck = true,
                        },
                    },
                },
                pyright = {
                    settings = {
                        python = {
                            analysis = { typeCheckingMode = "basic" },
                        },
                    },
                },
                clangd = {
                    cmd = {
                        "clangd",
                        "--background-index",       -- 后台建索引
                        "--clang-tidy",             -- 集成 clang-tidy lint
                        "--header-insertion=iwyu",  -- 头文件自动补全（include-what-you-use 风格）
                        "--completion-style=detailed",
                        "--function-arg-placeholders",
                    },
                    init_options = {
                        usePlaceholders = true,
                        completeUnimported = true,
                    },
                },
            },
        },
    },

    -- conform.nvim：覆盖格式化器配置
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                go         = { "gofumpt", "goimports" },
                python     = { "ruff_format", "ruff_organize_imports" },
                rust       = { "rustfmt" },
                c          = { "clang_format" },
                cpp        = { "clang_format" },
                sh         = { "shfmt" },
                bash       = { "shfmt" },
            },
        },
    },
}
