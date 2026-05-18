# ── 现代 CLI 工具 ──────────────────────────────────────────
brew "bat"          # cat 替代（语法高亮）
brew "eza"          # ls 替代
brew "fd"           # find 替代
brew "fzf"          # 模糊查找器
brew "ripgrep"      # grep 替代
brew "sd"           # sed 替代
brew "zoxide"       # 智能 cd
brew "git-delta"    # 美化 git diff
brew "yazi"         # 终端文件管理器
brew "watchexec"    # 文件变化触发命令

# ── 系统监控 ───────────────────────────────────────────────
# bottom 与 btop 功能重叠，保留功能更丰富的 btop
brew "btop"
brew "procs"        # ps 替代
brew "duf"          # df 替代
brew "dust"         # du 替代
brew "fastfetch"    # 系统信息展示
brew "hyperfine"    # 命令基准测试
brew "gping"        # 带图 ping

# ── Shell / 终端核心 ───────────────────────────────────────
brew "zsh"
brew "tmux"
brew "antidote"     # zsh 插件管理器
brew "atuin"
brew "chezmoi"      # dotfiles 管理
brew "carapace"     # 通用命令补全聚合器（500+ 命令）
brew "sshs"         # fzf 风格 SSH 主机选择器

# ── Git ────────────────────────────────────────────────────
brew "git"
brew "gh"           # 装完后：gh extension install github/gh-copilot
brew "glab"         # 自建 GitLab CLI
brew "lazygit"
brew "git-extras"

# ── Go 开发工具（语言工具链已迁移至 mise）────────────────────
# golangci-lint / actionlint / shfmt / air / sqlc / migrate → mise config.toml
brew "protobuf"       # protoc 编译器（系统级二进制，brew 更稳定）
brew "evans"          # gRPC 交互式 REPL 客户端

# ── 语言版本管理（替代 nvm/pyenv/rbenv/sdkman/phpenv）─────
brew "mise"

# ── 数据库 CLI ─────────────────────────────────────────────
brew "mysql-client"
brew "libpq"        # 含 psql / pg_dump
brew "redis"        # 含 redis-cli
brew "mongosh"

# ── PHP（brew 安装，避免 macOS iconv 编译问题）────────────
tap "shivammathur/php"
brew "shivammathur/php/php@8.1"
# PHP 扩展（swoole/redis）由 run_onchange_php-extensions.sh 通过 pecl 安装
# 依赖的编译头文件
brew "openssl@3"    # swoole 编译依赖
brew "pcre2"        # swoole 编译依赖（php_pcre.h 需要）

# ── API / 网络调试 ─────────────────────────────────────────
# httpie 与 xh 功能重叠，xh 是 Rust 实现更快，保留 xh
brew "xh"           # httpie 替代，Rust 实现，更快
brew "grpcurl"
brew "jq"
brew "yq"
cask "mitmproxy"    # HTTP/HTTPS 中间人代理调试

# ── 容器 / Kubernetes ─────────────────────────────────────
# kubectl / helm → 已迁移至 mise（支持按集群锁版本，多集群场景很有用）
brew "kubectx"      # 含 kubens，切换 context/namespace
brew "k9s"
brew "stern"
brew "kustomize"
brew "dive"
brew "lazydocker"
brew "kubeconform"  # K8s manifest 结构校验（比 kubeval 更新）
brew "fluxcd/tap/flux"  # GitOps CD 工具（brew tap 专属，mise 暂不支持）

# ── 云平台（AWS）──────────────────────────────────────────
brew "awscli"
brew "aws-vault"

# ── IaC / Secrets ─────────────────────────────────────────
# terraform / terragrunt → 已迁移至 mise（支持按项目锁版本）
brew "sops"         # secrets 文件加密，配合 git 存储敏感配置
brew "age"          # 现代加密工具，sops 的加密后端（替代 gpg）
brew "trivy"        # 容器 / 代码 / IaC 安全扫描，CI 必备
brew "topgrade"     # 一键升级所有包管理器（upgrade_all 别名依赖此工具）

# ── AI / LLM ──────────────────────────────────────────────
# brew "ollama"
brew "aichat"
brew "charmbracelet/tap/mods"

# ── 开发效率 ───────────────────────────────────────────────
brew "gum"          # 交互式 shell 脚本 UI 组件
brew "viddy"        # watch 替代，实时监控命令输出
brew "tlrc"         # tldr 客户端，快速查命令用法
brew "git-cliff"    # 从 commit 自动生成 CHANGELOG
brew "trufflehog"   # git 历史 secrets 扫描，防止敏感信息泄露
brew "dua-cli"      # 交互式磁盘空间分析（支持直接删除）
brew "trash"        # 安全删除，移入垃圾桶（rm 函数依赖）

# ── App 管理 ───────────────────────────────────────────────
cask "pearcleaner"  # 彻底卸载 App 及残留文件

# ── 代码质量 ───────────────────────────────────────────────
# shellcheck / shfmt → 已迁移至 mise
# prettier 按项目安装（npm install -D prettier），避免版本与项目不一致
brew "biome"          # 格式化 + Lint 二合一（替代 prettier + ESLint），新项目首选
brew "actionlint"     # GitHub Actions workflow 静态分析

# ── 编译工具 / C/C++ ──────────────────────────────────────
brew "cmake"
brew "ninja"
brew "pkgconf"
brew "llvm"         # Clang/LLVM 工具链（含 clang-format、clang-tidy、clangd）
brew "ccache"       # 编译缓存，加速重复编译
brew "cppcheck"     # C++ 静态分析（补充 clang-tidy）
brew "include-what-you-use"  # 头文件依赖分析，配合 clangd 使用
brew "bear"         # 生成 compile_commands.json（clangd 索引必需）
brew "conan"        # C/C++ 包管理器（替代 uv tool install 方式，更稳定）
brew "meson"        # 现代构建系统，部分项目用（补充 cmake/ninja）
brew "lua@5.4"      # Lua 5.4（C++ 项目嵌入脚本，cmake find_package(Lua) 依赖）
brew "luarocks"     # Lua 包管理器（依赖 lua，与 lua@5.4 共存）

# ── macOS casks ────────────────────────────────────────────
cask "iterm2"
cask "orbstack"     # Docker runtime（替代 Docker Desktop）

# 字体
cask "font-meslo-lg-nerd-font"
cask "font-jetbrains-mono-nerd-font"

# 生产力 / 窗口
cask "raycast"
cask "rectangle"
cask "stats"
cask "hiddenbar"
cask "karabiner-elements"

# 工具
cask "maczip"
cask "mos"
cask "keycastr"

# 编辑器（按需取消注释）
cask "cursor"
cask "jetbrains-toolbox"
# cask "unity-hub"    # Unity 版本管理器（Unity 开发时取消注释）
