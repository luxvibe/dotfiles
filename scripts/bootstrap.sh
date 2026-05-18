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

    info "安装 Homebrew 包 ..."
    brew bundle --file="$DOTFILES_DIR/Brewfile"
    success "Homebrew 安装完成"
}

# ── chezmoi ────────────────────────────────────────────────
setup_chezmoi() {
    # chezmoi 已通过 Brewfile 安装，此处只负责初始化和应用配置
    if [ ! -d "$HOME/.local/share/chezmoi" ]; then
        info "初始化 chezmoi ..."
        chezmoi init --source="$DOTFILES_DIR"
    fi

    info "应用 chezmoi 配置 ..."
    chezmoi apply
    success "chezmoi 应用完成"
}

# ── macOS 系统设置 ─────────────────────────────────────────
setup_defaults() {
    info "应用 macOS 系统设置 ..."
    bash "$DOTFILES_DIR/scripts/defaults.sh"
    success "macOS 系统设置完成"
}

# ── mise 运行时 ────────────────────────────────────────────
setup_mise() {
    if command -v mise &>/dev/null; then
        info "安装 mise 管理的运行时 ..."
        mise install --yes
        success "mise 运行时安装完成"
    fi
}

# ── antidote 插件缓存 ─────────────────────────────────────
setup_antidote() {
    local antidote_home
    antidote_home="$(brew --prefix antidote 2>/dev/null)/share/antidote"
    local plugins_txt="$HOME/.config/zsh/.zsh_plugins"
    local plugins_zsh="$HOME/.config/zsh/.zsh_plugins.zsh"

    if [[ -d "$antidote_home" && -f "$plugins_txt" ]]; then
        info "生成 antidote 插件缓存 ..."
        zsh -c "
            fpath=('$antidote_home/functions' \$fpath)
            autoload -Uz antidote
            antidote bundle <'$plugins_txt' >'$plugins_zsh'
        "
        success "antidote 插件缓存生成完成"
    else
        info "antidote 未就绪，跳过（确认 brew install antidote 已完成）"
    fi
}

# ── main ───────────────────────────────────────────────────
main() {
    info "开始 dotfiles 安装 ..."

    backup_existing
    setup_xcode
    setup_homebrew
    setup_chezmoi
    setup_defaults
    setup_mise
    setup_antidote

    success "全部完成！请重启终端或执行：source ~/.config/zsh/.zshrc"
}

main "$@"
