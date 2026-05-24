# ── 基础 ────────────────────────────────────────────────────
alias reload='exec zsh'
alias zshconf='chezmoi edit ~/.config/zsh/.zshrc'
alias h='history'
alias c='clear'
alias q='exit'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ── 现代 Unix 替代 ───────────────────────────────────────────
if (( $+commands[eza] )); then
    alias ls='eza --color=auto --icons=auto --group-directories-first'
    alias ll='ls -lh'
    alias la='ls -lhA'
    alias lg='ls -lhA --git'
    alias tree='ls --tree'
fi
# bat 保留原名使用，不覆盖 cat（带空格文件名转义兼容性问题）
(( $+commands[fd]        )) && alias find='fd'
(( $+commands[btop]      )) && alias top='btop'
(( $+commands[rg]        )) && alias grep='rg'
# help/tldr 已由 ai.zsh 中的 exp() 函数替代（AI 解释更准确）
(( $+commands[delta]     )) && alias diff='delta'
(( $+commands[duf]       )) && alias df='duf'
(( $+commands[dust]      )) && alias du='dust'
(( $+commands[hyperfine] )) && alias benchmark='hyperfine'
(( $+commands[gping]     )) && alias ping='gping'
(( $+commands[procs]     )) && alias ps='procs'

# ── 编辑器 ───────────────────────────────────────────────────
alias v='nvim'
alias vi='nvim'
alias vim='nvim'

# ── Git ──────────────────────────────────────────────────────
# git 别名由 OMZP::git 插件提供，此处不重复定义
# lazygit（避免与 eza 的 lg='ls -lhA --git' 冲突）
(( $+commands[lazygit]   )) && alias lzg='lazygit'
(( $+commands[lazydocker] )) && alias lzd='lazydocker'

# ── SSH ──────────────────────────────────────────────────────
(( $+commands[sshs] )) && alias s='sshs'   # fzf 选择 SSH 主机

# ── Homebrew ─────────────────────────────────────────────────
alias bu='brew upgrade'
alias bua='brew update && brew upgrade && brew autoremove && brew cleanup --prune=30'
alias bbd='brew bundle dump --force --file=~/.dotfiles/Brewfile'
alias flush_dns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
alias flush_comp='rm -f $ZDOTDIR/.comp_setup_date $ZDOTDIR/.zsh_plugins.zsh ~/.zcompdump && reload'  # 强制刷新所有补全缓存

# ── mise ─────────────────────────────────────────────────────
alias mi='mise install'
alias mu='mise use'
alias ml='mise ls'
alias mr='mise run'

# ── Upgrade ──────────────────────────────────────────────────
alias upgrade_dotfiles='cd ~/.dotfiles && git pull --rebase && chezmoi apply; cd - >/dev/null; reload'
alias upgrade_antidote='brew upgrade antidote && reload'
alias upgrade_mise='mise self-update && mise upgrade'
alias upgrade_brew='bua'
(( $+commands[cargo]    )) && alias upgrade_cargo='cargo install cargo-update && cargo install-update -a'
(( $+commands[gem]      )) && alias upgrade_gem='gem update && gem cleanup'
(( $+commands[topgrade] )) && alias upgrade_all='topgrade'

# ── 语言工具链 ───────────────────────────────────────────────
alias gor='go run'        # Go
alias got='go test ./...'
alias gob='go build'
alias gomod='go mod tidy'
alias py='python3'        # Python
alias pip='uv pip'
alias art='php artisan'   # PHP
# composer/cmp：按需在项目 local.zsh 中定义，全局不强制

# ── Proxy ────────────────────────────────────────────────────
PROXY_ADDR="${PROXY_ADDR:-http://127.0.0.1:7897}"
NO_PROXY_LIST="10.*.*.*,192.168.*.*,*.local,localhost,127.0.0.1"

alias showproxy='echo "http_proxy=$http_proxy"'
alias setproxy='export http_proxy=$PROXY_ADDR https_proxy=$PROXY_ADDR all_proxy=$PROXY_ADDR no_proxy=$NO_PROXY_LIST; showproxy'
alias unsetproxy='unset http_proxy https_proxy all_proxy no_proxy; showproxy'
alias toggleproxy='[[ -n "$http_proxy" ]] && unsetproxy || setproxy'

# Proxyman 抓包
alias proxyman_on='set -a && source "$HOME/.proxyman/proxyman_env_automatic_setup.sh" && set +a && echo "→ Proxyman 抓包已开启（关闭此 shell 窗口恢复环境）"'