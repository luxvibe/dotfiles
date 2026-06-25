# ── 基础 ────────────────────────────────────────────────────
alias reload='exec zsh'
alias zshconf='chezmoi edit ~/.config/zsh/.zshrc'
alias c='clear'
alias q='exit'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ── chezmoi ──────────────────────────────────────────────────
alias cz='chezmoi'
alias czd='chezmoi diff'
alias cza='chezmoi apply'
alias cze='chezmoi edit'

# ── 现代 Unix 替代 ───────────────────────────────────────────
if (( $+commands[eza] )); then
    alias ls='eza --color=auto --icons=auto --group-directories-first'
    alias ll='ls -lh'
    alias la='ls -lhA'
    alias lg='ls -lhA --git'
    alias tree='ls --tree'
fi
# bat 保留原名使用，不覆盖 cat（带空格文件名转义兼容性问题）
# bat 接管 man 手册，显示带语法高亮的彩色文档
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
(( $+commands[fd]        )) && alias ff='fd'
(( $+commands[btop]      )) && alias top='btop'
(( $+commands[rg]        )) && alias gg='rg'
# delta 仅作为 git/pager 渲染器，不覆盖系统 diff 命令（接口不兼容）
(( $+commands[duf]       )) && alias df='duf'
(( $+commands[dust]      )) && alias du='dust'
(( $+commands[procs]     )) && alias ps='procs'

# ── 编辑器 ───────────────────────────────────────────────────
alias vi='nvim'
alias vim='nvim'

# ── Git ──────────────────────────────────────────────────────
# git 别名由 OMZP::git 插件提供，此处不重复定义

# ── SSH ──────────────────────────────────────────────────────
(( $+commands[sshs] )) && alias s='sshs'   # fzf 选择 SSH 主机

# ── Homebrew ─────────────────────────────────────────────────
alias bu='brew upgrade'
alias bua='brew update && brew upgrade && brew autoremove && brew cleanup --prune=30'
alias bbd='brew bundle dump --force'
alias bbc='brew bundle cleanup --force'  # 卸载不在 Brewfile 里的包
alias flush_dns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
alias flush_comp='rm -f $ZDOTDIR/.comp_setup_date ${ZSH_COMPDUMP:-~/.zcompdump} ${XDG_CACHE_HOME:-$HOME/.cache}/sheldon/init.zsh ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/{zoxide,mise,atuin}.zsh && reload'  # 强制刷新所有缓存

# ── mise ─────────────────────────────────────────────────────
alias mi='mise install'
alias mu='mise use'
alias ml='mise ls'
alias mr='mise run'

# ── Upgrade ──────────────────────────────────────────────────
alias upgrade_dotfiles='chezmoi update && reload'
alias upgrade_sheldon='brew upgrade sheldon && reload'
alias upgrade_mise='mise self-update && mise upgrade && mise prune --yes'
alias upgrade_brew='bua'
(( $+commands[cargo]    )) && alias upgrade_cargo='cargo install cargo-update && cargo install-update -a'
(( $+commands[gem]      )) && alias upgrade_gem='gem update && gem cleanup'
(( $+commands[topgrade] )) && alias upgrade_all='topgrade'

# ── 语言工具链 ───────────────────────────────────────────────
alias gor='go run'        # Go
alias got='go test ./...'
alias gob='go build'
alias gomod='go mod tidy'
alias py='python3'        # Python（uv 别名由 OMZ uv 插件提供：uvp/uvr/uvs/uva 等）
alias art='php artisan'   # PHP
# composer/cmp：按需在项目 local.zsh 中定义，全局不强制

# ── Proxy ────────────────────────────────────────────────────
PROXY_ADDR="${PROXY_ADDR:-http://127.0.0.1:7897}"
NO_PROXY_LIST="10.0.0.0/8,192.168.0.0/16,*.local,localhost,127.0.0.1"

alias showproxy='echo "http_proxy=$http_proxy"'
alias setproxy='export http_proxy=$PROXY_ADDR https_proxy=$PROXY_ADDR all_proxy=$PROXY_ADDR no_proxy=$NO_PROXY_LIST; showproxy'
alias unsetproxy='unset http_proxy https_proxy all_proxy no_proxy; showproxy'
alias toggleproxy='[[ -n "$http_proxy" ]] && unsetproxy || setproxy'

# Proxyman 抓包
alias proxyman_on='set -a 2>/dev/null || true; source "$HOME/Library/Application Support/com.proxyman.NSProxy-setapp/app-data/proxyman_env_automatic_setup.sh"; set +a 2>/dev/null || true && echo "→ Proxyman 抓包已开启（关闭此 shell 窗口恢复环境）"'