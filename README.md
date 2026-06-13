# dotfiles

个人 macOS dotfiles，由 [chezmoi](https://chezmoi.io) 管理。

## 一键安装（新机）

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /tmp init --apply luxvibe
```

首次运行会交互式询问 name / email。

## 目录结构

```
~/.dotfiles/
├── home/                 chezmoi 源根（dot_ → .，*.tmpl → 模板渲染）
│   ├── dot_p10k.zsh          → ~/.p10k.zsh（powerlevel10k 主题配置）
│   ├── dot_zshenv        → ~/.zshenv（XDG 变量、ZDOTDIR）
│   ├── dot_config/
│   │   ├── zsh/          → ~/.config/zsh/（.zshrc + 拆分模块）
│   │   ├── git/          → ~/.config/git/（签名、全局 ignore）
│   │   ├── tmux/         → ~/.config/tmux/（无插件，单文件配置）
│   │   ├── nvim/         → ~/.config/nvim/（LazyVim 精简）
│   │   ├── mise/         → ~/.config/mise/（多语言版本管理）
│   │   ├── atuin/        → ~/.config/atuin/
│   │   └── bat/          → ~/.config/bat/
│   └── private_dot_ssh/  → ~/.ssh/（权限 0700）
├── Brewfile              所有 brew + cask
├── scripts/
│   ├── bootstrap.sh      一键引导安装
│   └── defaults.sh       macOS 系统设置（25+ 项）
└── docs/
    ├── INSTALL.md
    ├── KEYBINDINGS.md
    └── TROUBLESHOOTING.md
```

## 常用命令

| 命令 | 作用 |
|---|---|
| `chezmoi update` | 拉取远程最新并 apply（日常同步） |
| `chezmoi apply` | 应用本地最新配置 |
| `chezmoi diff` | 预览变更 |
| `chezmoi init` | 重新生成配置文件（模板新增变量时使用） |
| `chezmoi edit ~/.config/zsh/.zshrc` | 编辑配置（定位到源文件）|
| `chezmoi doctor` | 环境健康检查 |
| `~/.dotfiles/scripts/bootstrap.sh` | 完整重新应用（含 brew、mise 等） |

## 工具栈

### Shell / 终端

| 工具 | 用途 | 替代关系 |
|---|---|---|
| zsh | 主 Shell | — |
| tmux | 终端复用器，会话持久化（无插件，单文件配置） | — |
| powerlevel10k | zsh 提示符主题（instant prompt，极速启动） | oh-my-zsh 主题 |
| atuin | Shell 历史记录（SQLite + 同步） | fzf history / `Ctrl-R` |
| antidote | zsh 插件管理器（静态加载，brew 安装） | zinit / oh-my-zsh / antigen |
| iTerm2 | macOS 终端模拟器 | Terminal.app |

### 配置管理

| 工具 | 用途 | 替代关系 |
|---|---|---|
| chezmoi | dotfiles 管理，支持模板渲染与加密 | stow / yadm |

### 编辑器（Neovim）

| 插件 | 用途 | 替代关系 |
|---|---|---|
| lazy.nvim | 插件管理器（懒加载） | packer.nvim |
| mason.nvim | LSP / linter 服务器管理 | — |
| nvim-lspconfig | LSP 客户端配置 | — |
| conform.nvim | 保存时自动格式化 | null-ls |
| nvim-treesitter | 语法高亮与代码结构解析 | — |
| telescope.nvim | 模糊查找（文件、符号、grep） | fzf.vim |
| gitsigns.nvim | 行级 git 状态显示 | — |
| catppuccin | Mocha 配色主题 | — |
| lualine.nvim | 状态栏 | — |
| which-key.nvim | 按键提示 | — |
| mini.files | 轻量文件管理器 | neo-tree |

### 语言版本管理

| 工具 | 版本 / 说明 | 替代关系 |
|---|---|---|
| mise | 多语言版本管理器（统一入口） | nvm / pyenv / rbenv / sdkman / phpenv |
| node | LTS | nvm |
| pnpm | latest | npm / yarn |
| deno | latest | — |
| bun | latest | — |
| python | 3.12 | pyenv |
| uv | latest，现代 Python 包管理（10× pip） | pip / poetry |
| go | latest | — |
| rust | stable | rustup（mise 内置） |
| dotnet | 8（Unity 脚本 & 后端 C#） | — |
| java | temurin-21（JDK 21 LTS） | sdkman |
| maven | latest | — |
| gradle | latest | — |
| kotlin | latest | — |
| ruby | 3.3 | rbenv / rvm |
| php | 8.1（brew shivammathur/php 安装） | phpenv |

### 现代 CLI 工具

| 工具 | 用途 | 替代关系 |
|---|---|---|
| eza | 文件列表展示（图标 + 颜色） | ls |
| bat | 文件内容查看（语法高亮 + 行号） | cat |
| fd | 文件查找 | find |
| fzf | 通用模糊查找器 | — |
| ripgrep | 代码内容搜索 | grep |
| sd | 文本替换 | sed |
| zoxide | 智能目录跳转（学习访问历史） | cd / autojump |
| yazi | 终端文件管理器（TUI） | ranger / nnn |
| watchexec | 文件变化触发命令 | entr |
| btop | 系统资源监控 TUI | top / htop |
| procs | 进程列表 | ps |
| duf | 磁盘使用概览 | df |
| dust | 目录磁盘占用分析 | du |
| fastfetch | 系统信息展示 | neofetch |
| tlrc | 命令速查手册（tldr 客户端） | man / tldr |
| hyperfine | 命令基准测试 | time |
| gping | 带折线图的 ping | ping |

### Git 工具

| 工具 | 用途 | 替代关系 |
|---|---|---|
| git | 版本控制 | — |
| forgit | fzf 增强 git 工作流（fuzzy add/checkout/log/stash） | 手写 fzf 函数 |
| gh | GitHub CLI（PR、issue、Copilot） | — |
| glab | GitLab CLI | — |
| git-delta | git diff / blame 美化渲染 | diff-so-fancy |
| git-extras | 扩展 git 子命令集合 | — |

### 容器 / Kubernetes

| 工具 | 用途 | 替代关系 |
|---|---|---|
| OrbStack | macOS 容器运行时（轻量快速） | Docker Desktop |
| kubectl | Kubernetes CLI | — |
| kubectx / kubens | 快速切换 context / namespace | — |
| k9s | Kubernetes TUI 管理器 | — |
| helm | Kubernetes 包管理器 | — |
| stern | 多 Pod 日志聚合 | kubectl logs |
| kustomize | Kubernetes 配置定制 | — |
| dive | 分析 Docker 镜像层 | — |

### 数据库 CLI

| 工具 | 用途 | 替代关系 |
|---|---|---|
| mysql-client | MySQL CLI（`mysql` 命令） | — |
| libpq | PostgreSQL CLI（`psql`、`pg_dump`） | — |
| redis | Redis CLI（`redis-cli`） | — |
| mongosh | MongoDB Shell | mongo（旧版） |

### API / 网络调试

| 工具 | 用途 | 替代关系 |
|---|---|---|
| xh | HTTP 客户端（Rust 实现，更快） | httpie / curl |
| grpcurl | gRPC 接口调试 | — |
| jq | JSON 处理与查询 | — |
| yq | YAML / JSON / TOML 处理 | — |
| mitmproxy | HTTP/HTTPS 中间人代理调试 | Charles / Proxyman |

### 云平台

| 工具 | 用途 | 替代关系 |
|---|---|---|
| awscli | AWS 命令行工具 | — |
| aws-vault | AWS 凭证安全存储与切换 | — |

### AI / LLM

| 工具 | 用途 | 替代关系 |
|---|---|---|
| aichat | 多模型 AI CLI（OpenAI / Claude / Gemini 等） | — |
| mods | 管道友好的 AI CLI | — |
| gh copilot | GitHub Copilot CLI（`gh extension`） | — |

### 代码质量

| 工具 | 用途 | 替代关系 |
|---|---|---|
| shellcheck | Shell 脚本静态分析（mise 管理） | — |
| shfmt | Shell 脚本格式化（mise 管理） | — |
| actionlint | GitHub Actions workflow 静态分析（brew 安装） | — |
| golangci-lint | Go 多合一 linter v2（mise 原生支持） | — |
| buf | Protobuf / gRPC 工具链（mise 管理） | protoc-gen-* |
| biome | 格式化 + Lint 二合一，新项目首选 | prettier + ESLint |

### IaC / Secrets

| 工具 | 用途 | 替代关系 |
|---|---|---|
| opentofu | IaC 核心（terraform 开源替代，mise 管理，支持多版本） | terraform |
| terragrunt | Terraform DRY 封装（mise 管理） | — |
| sops | secrets 文件加密，配合 git 存储敏感配置 | — |
| age | 现代加密工具，sops 的加密后端 | gpg |
| trivy | 容器 / 代码 / IaC 安全扫描 | — |

### 开发效率

| 工具 | 用途 | 替代关系 |
|---|---|---|
| gum | 交互式 shell 脚本 UI 组件 | — |
| viddy | 实时监控命令输出 | watch |
| git-cliff | 从 commit 自动生成 CHANGELOG | — |
| trufflehog | git 历史 secrets 扫描 | — |
| dua-cli | 交互式磁盘空间分析 | ncdu |

### C++ 工具链

| 工具 | 用途 | 替代关系 |
|---|---|---|
| cmake | 跨平台构建系统生成器 | Makefile / Meson |
| ninja | 高速构建系统（cmake 后端） | make |
| meson | 现代构建系统（部分项目） | cmake |
| llvm | Clang/LLVM 工具链（含 clang-format、clang-tidy、clangd） | GCC |
| ccache | 编译缓存，加速重复编译 | — |
| cppcheck | C++ 静态分析 | — |
| bear | 生成 compile_commands.json（clangd 索引必需） | — |
| include-what-you-use | 头文件依赖分析，配合 clangd | — |
| conan | C++ 包管理（brew 安装） | vcpkg |
| lua@5.4 | Lua 5.4（C++ 嵌入脚本，cmake find_package(Lua) 依赖） | — |
| luarocks | Lua 包管理器 | — |

## 许可

MIT
