-- 自定义选项（覆盖 LazyVim 默认值）
-- LazyVim 默认已设置：number、relativenumber、signcolumn、cursorline、
-- termguicolors、scrolloff、splitright、splitbelow、undofile、clipboard 等
local o = vim.opt

-- LazyVim 默认 tabstop=2，覆盖为 4（前端文件类型单独处理）
o.tabstop    = 4
o.shiftwidth = 4

-- 文件类型缩进覆盖（前端 / 脚本类用 2 空格）
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact",
                "json", "jsonc", "yaml", "html", "css", "scss",
                "lua", "ruby", "php" },
    callback = function()
        vim.opt_local.tabstop    = 2
        vim.opt_local.shiftwidth = 2
    end,
})
