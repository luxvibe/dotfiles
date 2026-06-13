#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

info()    { printf "\033[0;34m[•]\033[0m %s\n" "$*"; }
success() { printf "\033[0;32m[✓]\033[0m %s\n" "$*"; }
die()     { printf "\033[0;31m[✗]\033[0m %s\n" "$*" >&2; exit 1; }

[[ "$(uname -s)" == "Darwin" ]] || die "此 dotfiles 仅支持 macOS"

# ── 备份现有配置 ────────────────────────────────────────────
backup_existing() {
    local backup="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S).tgz"
    info "备份现有配置到 $backup ..."
    tar czf "$backup" \
        "$HOME/.zshenv" \
        "$HOME/.config/zsh" \
        "$HOME/.gitconfig" "$HOME/.config/git" \
        "$HOME/.ssh/config" \
        "$HOME/.p10k.zsh" \
        2>/dev/null || true
    success "备份完成"
}

# ── Xcode CLT ──────────────────────────────────────────────
setup_xcode() {
    info "检查 Xcode Command Line Tools ..."
    if ! xcode-select -p &>/dev/null; then
        xcode-select --install
        info "等待 Xcode CLT 安装完成后重新运行此脚本"
        exit 0
    fi
    success "Xcode CLT 已就绪"
}

# ── Homebrew ───────────────────────────────────────────────
setup_homebrew() {
    if ! command -v brew &>/dev/null; then
        info "安装 Homebrew ..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    # Apple Silicon
    [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
    # Intel
    [[ -x /usr/local/bin/brew   ]] && eval "$(/usr/local/bin/brew shellenv)"
    success "Homebrew 已就绪"
}

# ── chezmoi ────────────────────────────────────────────────
setup_chezmoi() {
    # 如果 chezmoi 未安装，先通过 brew 安装它作为自举工具
    if ! command -v chezmoi &>/dev/null; then
        info "安装 chezmoi ..."
        brew install chezmoi
    fi

    # 初始化并应用配置
    if [ ! -d "$HOME/.local/share/chezmoi" ]; then
        info "初始化 chezmoi ..."
        chezmoi init --source="$DOTFILES_DIR"
    fi

    info "应用 chezmoi 配置 (此过程会自动安装 Brewfile / macOS 设置 / mise 运行时等) ..."
    chezmoi apply --force
    success "chezmoi 应用完成"
}

# ── main ───────────────────────────────────────────────────
main() {
    info "开始 dotfiles 引导安装 ..."

    backup_existing
    setup_xcode
    setup_homebrew
    setup_chezmoi

    success "全部完成！请重启终端或执行：source ~/.config/zsh/.zshrc"
}

main "$@"
