# PATH 管理

# Homebrew（Apple Silicon）—— 静态展开，避免每次启动 fork brew 进程
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
path=("/opt/homebrew/bin" "/opt/homebrew/sbin" $path)
[ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
export HOMEBREW_BUNDLE_FILE="$HOME/.dotfiles/Brewfile"

# Go
export GOPATH="$HOME/Workspace/golang"
export PATH="${GOPATH}/bin:$PATH"
# GOPROXY 在 private.zsh 中按网络环境配置

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# 用户私有可执行文件
export PATH="$HOME/.bin:$PATH"
