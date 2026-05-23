# PATH 管理

# Homebrew（Apple Silicon 优先，Intel Mac 兜底）
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Go
export GOPATH="$HOME/Workspace/golang"
export PATH="${GOPATH}/bin:$PATH"
# GOPROXY 在 private.zsh 中按网络环境配置

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# 用户私有可执行文件
export PATH="$HOME/.bin:$PATH"
