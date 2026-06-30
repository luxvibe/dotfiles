# zsh 插件管理（zinit）

# zsh-history-substring-search 按键绑定，由 zinit atload 在插件加载后调用
_hss_bindkey() {
    zmodload zsh/terminfo
    for keymap in main emacs viins; do
        bindkey -M "$keymap" "$terminfo[kcuu1]" history-substring-search-up
        bindkey -M "$keymap" "$terminfo[kcud1]" history-substring-search-down
    done
    bindkey '^P' history-substring-search-up
    bindkey '^N' history-substring-search-down
}

# OMZ 插件依赖此变量存放补全缓存（kubectl / npm 插件）
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
mkdir -p "$ZSH_CACHE_DIR/completions"

# ── zinit 自动安装 + 初始化 ──────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
    print -P "%F{yellow}zinit: 首次初始化，正在安装...%f"
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
[[ -f "${ZINIT_HOME}/zinit.zsh" ]] || { print -P "%F{red}zinit: 安装失败，请检查网络后重新打开终端%f" >&2; return }
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# ── Powerlevel10k 主题（同步加载，配合 instant prompt）──────────
zinit ice depth=1
zinit light romkatv/powerlevel10k

# ── Homebrew 补全 ─────────────────────────────────────────────
if [[ -n "$HOMEBREW_PREFIX" ]]; then
    FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}"
fi

# ── 工具动态补全注册（只在 zcompdump 过期时执行，避免每次启动都慢）──
# 各工具的补全脚本输出到 $ZDOTDIR/completions/，由 FPATH 统一加载
_setup_completions() {
    local comp_dir="$ZDOTDIR/completions"
    mkdir -p "$comp_dir"
    # 只生成 mise 管理且 Homebrew site-functions 未提供的工具
    (( $+commands[kubectl] )) && kubectl completion zsh >| "$comp_dir/_kubectl" 2>/dev/null
    (( $+commands[helm]    )) && helm completion zsh >| "$comp_dir/_helm" 2>/dev/null
    (( $+commands[uv]      )) && uv generate-shell-completion zsh >| "$comp_dir/_uv" 2>/dev/null
    (( $+commands[uvx]     )) && uvx --generate-shell-completion zsh >| "$comp_dir/_uvx" 2>/dev/null
    # docker/docker-compose: OrbStack fpath 注入
    # aws/k9s/trivy 等已由 Homebrew site-functions 提供
}

# 将自定义补全目录加入 FPATH（必须在 compinit 之前）
FPATH="$ZDOTDIR/completions:${FPATH}"
typeset -U fpath  # 去除重复项

# 每天重新生成一次补全脚本
export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
_comp_cache="$ZDOTDIR/.comp_setup_date"
zmodload zsh/datetime
strftime -s _today '%Y%m%d' $EPOCHSECONDS
if [[ ! -f "$_comp_cache" || "$_today" != "$(<$_comp_cache)" ]]; then
    _setup_completions
    print -r -- "$_today" >| "$_comp_cache"
    [[ -f "$ZSH_COMPDUMP" ]] && rm -f "$ZSH_COMPDUMP"
fi
unset _comp_cache _today
unfunction _setup_completions

# ── zsh-completions（fpath 注册，同步）──────────────────────
zinit ice blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

# ── 补全初始化 ──────────────────────────────────────────────
autoload -Uz compinit
compinit -C -d "$ZSH_COMPDUMP"

# ── fzf-tab（同步，compinit 后）──────────────────────────────
# 必须在 compinit 之后、fast-syntax-highlighting / zsh-autosuggestions 之前
zinit light Aloxaf/fzf-tab

# ── OMZ 库文件（Turbo）──────────────────────────────────────
# theme-and-appearance.zsh 会设 alias ls='ls -G'，用 atload 在加载后覆盖回 eza
zinit wait lucid for \
    OMZL::history.zsh \
    OMZL::key-bindings.zsh \
    atload"(( \$+commands[eza] )) && alias ls='eza --color=auto --icons=auto --group-directories-first'" \
        OMZL::theme-and-appearance.zsh

# ── OMZ 插件（Turbo）────────────────────────────────────────
zinit wait lucid for \
    OMZP::colored-man-pages \
    OMZP::cp \
    OMZP::extract \
    OMZP::fancy-ctrl-z \
    OMZP::git \
    OMZP::sudo \
    OMZP::opentofu \
    OMZP::docker \
    OMZP::docker-compose \
    OMZP::kubectl \
    OMZP::helm \
    OMZP::aws \
    OMZP::npm \
    OMZP::uv

# ── 交互体验插件（Turbo）────────────────────────────────────
zinit wait lucid for \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    atload"_hss_bindkey" \
        zsh-users/zsh-history-substring-search \
    djui/alias-tips \
    hlissner/zsh-autopair \
    wfxr/forgit

# ── FZF 集成 ─────────────────────────────────────────────────
# 只加载 key-bindings.zsh（Ctrl-R / Ctrl-T / Alt-C）。
# 不再加载 completion.zsh：fzf-tab 已经基于 fzf 接管了 Tab 补全，
# 若再 source fzf 的 completion.zsh，它会把 ^I 抢绑成 fzf-completion，
# 并对带 / 的路径走自己的 _fzf_path_completion，导致 fzf-tab 失效。
_fzf_shell="${HOMEBREW_PREFIX}/opt/fzf/shell"
[[ -f "$_fzf_shell/key-bindings.zsh" ]] && source "$_fzf_shell/key-bindings.zsh"
unset _fzf_shell

# ── FZF 配置 ──────────────────────────────────────────────────
export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix --hidden --follow --exclude .git"
# FZF_DEFAULT_OPTS 只放 inline 参数，确保 fzf-tab（use-fzf-default-opts yes）
# 能正常嵌入渲染；--tmux 会开 popup 模式，与 fzf-tab 的 inline widget 冲突
export FZF_DEFAULT_OPTS='--height 40% --layout reverse --border'
# Dracula 配色：fg/bg/fg+/bg+ 留 -1 跟随终端（保留透明背景），其余用 Dracula 固定色
FZF_DEFAULT_OPTS+=' --color=dark'
FZF_DEFAULT_OPTS+=' --color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f'
FZF_DEFAULT_OPTS+=' --color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7'

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--tmux bottom,40% \
  --walker-skip .git,node_modules,target \
  --preview 'bat -n --color=always {} || cat {}' \
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# FZF_CTRL_R_OPTS 已移除：atuin 通过 bindkey '^r' atuin-search 接管了 Ctrl-R，
# fzf 的 history widget 永远不会执行

export FZF_ALT_C_OPTS="--tmux bottom,40% \
  --walker-skip .git,node_modules,target \
  --preview '(eza --tree --level 3 --color=always --icons=auto --group-directories-first {} || tree -NC {}) | head -200'"

export _ZO_FZF_OPTS="--scheme=path --tiebreak=end,chunk,index \
  --bind=ctrl-z:ignore,btab:up,tab:down --cycle --keep-right \
  --border=sharp --height=45% --info=inline --layout=reverse \
  --tabstop=1 --exit-0 --select-1 \
  --preview 'eza --tree --level 3 --color=always --group-directories-first {2} 2>/dev/null'"

# ── fzf-tab 补全预览 ──────────────────────────────────────────
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# 让 _files 把 dotfile 也算进候选（cd ~/<Tab> 能看到 .config、.ssh、.claude 等）
_comp_options+=(globdots)

# fzf-tab 默认 query-string=prefix input first：候选无公共前缀时会拿用户
# 输入的 ~/ 之类路径片段当 fzf query，反而把所有候选过滤掉。
# 改成只用候选的公共前缀，避免这种"0/N 0 匹配"的尴尬。
zstyle ':fzf-tab:*' query-string prefix

zstyle ':fzf-tab:complete:cd:*' fzf-preview \
       'eza -1 --color=always --icons=auto --group-directories-first $realpath'

zstyle ':fzf-tab:complete:*:argument-rest' fzf-preview \
       'if [[ -n "$realpath" ]]; then
          if [ -d "$realpath" ]; then
            eza -1 --color=always --icons=auto --group-directories-first "$realpath"
          else
            bat --color=always --plain --line-range :500 "$realpath" 2>/dev/null || cat "$realpath"
          fi
        elif [ -d "$word" ]; then
          eza -1 --color=always --icons=auto --group-directories-first "$word"
        elif [ -f "$word" ]; then
          bat --color=always --plain --line-range :500 "$word" 2>/dev/null || cat "$word"
        fi'

zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'

zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
       '[[ $group == "[process ID]" ]] && ps -p $word -o comm="" -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags '--preview-window=down:3:wrap'

zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff $word | delta'
zstyle ':fzf-tab:complete:git-log:*'  fzf-preview 'git log --color=always $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview 'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
       'case "$group" in
        "commit tag") git show --color=always $word ;;
        *) git show --color=always $word | delta ;;
        esac'
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
       'case "$group" in
        "modified file") git diff $word | delta ;;
        "recent commit object name") git show --color=always $word | delta ;;
        *) git log --color=always $word ;;
        esac'

zstyle ':fzf-tab:complete:(\\|*/|)man:*' fzf-preview 'man $word | bat -plman --color=always'

zstyle ':fzf-tab:complete:-command-:*' fzf-preview \
       '(out=$(man "$word" | bat -plman --color=always) 2>/dev/null && echo $out) ||
        (out=$(which "$word") && echo $out)'

zstyle ':fzf-tab:complete:brew-(install|uninstall|search|info):*-argument-rest' fzf-preview \
       'brew info $word | bat -plhelp --color=always'

zstyle ':fzf-tab:complete:(export|unset|expand):*' fzf-preview \
       'echo ${(P)word} | bat -plhelp --color=always'

# ── navi（Ctrl+G 命令速查）────────────────────────────────────
(( $+commands[navi] )) && eval "$(navi widget zsh)"
