-- 自定义快捷键（LazyVim 已内置大量默认键位，此处只补充/覆盖）
-- 查看 LazyVim 默认键位：https://www.lazyvim.org/keymaps
local map = vim.keymap.set

-- ── 基础覆盖 ─────────────────────────────────────────────────
map("n", "<leader>w", "<cmd>w<CR>",  { desc = "Save" })
map("n", "<leader>W", "<cmd>wa<CR>", { desc = "Save all" })

-- ── 行移动（可视模式）────────────────────────────────────────
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- ── Git ───────────────────────────────────────────────────────
-- <leader>gg 由 editor.lua 的 lazygit.nvim keys 配置
-- <leader>gb / ]h / [h / <leader>hp 由 LazyVim gitsigns 内置

-- ── 文件树 ───────────────────────────────────────────────────
-- <leader>n / <leader>N 由 editor.lua 的 mini.files keys 配置
