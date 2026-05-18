# 快捷键速查

## Zsh

| 快捷键 | 功能 |
|---|---|
| `Ctrl-R` | atuin / fzf 历史搜索 |
| `Ctrl-T` | fzf 文件搜索 |
| `Alt-C`  | fzf 目录跳转 |
| `Tab`    | fzf-tab 补全（含预览）|
| `Ctrl-X Ctrl-A` | GitHub Copilot 建议当前命令 |
| `↑ / ↓`  | history-substring-search |

## Powerlevel10k

| 命令 | 功能 |
|---|---|
| `p10k configure` | 重新运行配置向导，生成新的 `~/.p10k.zsh` |
| `source ~/.p10k.zsh` | 立即应用 `.p10k.zsh` 的修改，无需重启终端 |

## 常用函数

| 命令 | 功能 |
|---|---|
| `fkill` | fzf 选进程并 kill |
| `fcd`   | fzf 选目录并进入 |
| `rgv`   | ripgrep + fzf + nvim 预览 |
| `kpod [ns]` | fzf 选 K8s pod 并进入 shell |
| `klogf [ns]` | fzf 选 K8s pod 并跟踪日志 |
| `dsh`   | fzf 选 Docker 容器并进入 shell |
| `dlog`  | fzf 选 Docker 容器并跟踪日志 |
| `mkcd`  | 创建目录并进入 |
| `weather` | 查询天气 |

## forgit 命令（git + fzf，由 wfxr/forgit 提供）

| 命令 | 功能 |
|---|---|
| `gfa`    | fuzzy add（交互式暂存文件）|
| `gfco`   | fuzzy checkout（交互式切换分支）|
| `gflog`  | fuzzy log（交互式浏览提交历史）|
| `gfstash` | fuzzy stash（交互式管理 stash）|
| `gfclean` | fuzzy clean（交互式清理未跟踪文件）|
| `gfcp`   | fuzzy cherry-pick（交互式 cherry-pick）|

## Tmux

| 快捷键（prefix = C-a）| 功能 |
|---|---|
| `prefix \|` | 水平分割 |
| `prefix -`  | 垂直分割 |
| `prefix h/j/k/l` | 面板导航 |
| `prefix H/J/K/L` | 面板大小调整 |
| `prefix c`  | 新建窗口（当前路径）|
| `prefix r`  | 重载配置 |
| `M-Left/Right` | 切换窗口 |

## Neovim

| 快捷键 | 功能 |
|---|---|
| `<Space>ff` | Telescope 文件搜索 |
| `<Space>fg` | Telescope 全文搜索 |
| `<Space>fb` | Telescope Buffers |
| `<Space>fr` | 最近文件 |
| `<Space>fc` | Git commits |
| `<Space>gg` | LazyGit |
| `<Space>gb` | git blame 行 |
| `<Space>w`  | 保存文件 |
| `<Space>W`  | 保存所有文件 |
| `<Space>qq` | 退出所有（LazyVim 内置）|
| `<Space>e`  | 诊断浮窗（Diagnostic float）|
| `<Space>n`  | 文件管理（当前文件所在目录）|
| `<Space>N`  | 文件管理（工作目录）|
| `<Space>rn` | 重命名 |
| `<Space>ca` | Code action |
| `<Space>D`  | 跳转类型定义（Type definition）|
| `gd`        | 跳转定义（Go to definition）|
| `gD`        | 跳转声明（Go to declaration）|
| `gr`        | 查看引用 |
| `gi`        | 查看实现（Implementations）|
| `K`         | 悬停文档 |
| `<C-k>`     | 签名帮助（Signature help，插入模式）|
| `[d / ]d`   | 诊断上/下 |
| `[h / ]h`   | Git hunk 上/下 |

## 常用别名

| 别名 | 功能 |
|---|---|
| `lzg` | lazygit（避免与 eza 的 `lg` 冲突）|
| `lzd` | lazydocker |
| `v`   | nvim |

## Rectangle（窗口管理）

| 快捷键 | 功能 |
|---|---|
| `⌃⌥←` | 左半屏 |
| `⌃⌥→` | 右半屏 |
| `⌃⌥↑` | 上半屏 |
| `⌃⌥↓` | 下半屏 |
| `⌃⌥U` | 左上四分之一 |
| `⌃⌥I` | 右上四分之一 |
| `⌃⌥J` | 左下四分之一 |
| `⌃⌥K` | 右下四分之一 |
| `⌃⌥↩` | 最大化 |
| `⌃⌥C` | 居中 |
| `⌃⌥D` | 左三分之一 |
| `⌃⌥F` | 中三分之一 |
| `⌃⌥G` | 右三分之一 |
| `⌃⌥⇧←` | 移到左侧显示器 |
| `⌃⌥⇧→` | 移到右侧显示器 |
