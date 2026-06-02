# antidote 插件管理
# brew 安装，路径通过 HOMEBREW_PREFIX 获取（由 path.zsh 的 brew shellenv 设置）

# zsh-history-substring-search 的按键绑定（post hook 在插件加载后调用）
_hss_bindkey() {
    zmodload zsh/terminfo
    for keymap in main emacs viins; do
        bindkey -M "$keymap" "$terminfo[kcuu1]" history-substring-search-up
        bindkey -M "$keymap" "$terminfo[kcud1]" history-substring-search-down
    done
    # 同时绑定 Ctrl-P / Ctrl-N 作为备用
    bindkey '^P' history-substring-search-up
    bindkey '^N' history-substring-search-down
}

ANTIDOTE_HOME="${HOMEBREW_PREFIX}/opt/antidote/share/antidote"
[[ -d "$ANTIDOTE_HOME" ]] || {
    print -P "%F{33}antidote not found, run: brew install antidote%f"
    return
}

# 插件列表文件（antidote bundle 的输入和输出）
zsh_plugins_src="$ZDOTDIR/.zsh_plugins"
zsh_plugins_out="$ZDOTDIR/.zsh_plugins.zsh"

# 静态加载：若插件列表有变化则重新生成
if [[ ! "$zsh_plugins_out" -nt "$zsh_plugins_src" ]]; then
    source "$ANTIDOTE_HOME/antidote.zsh"
    antidote bundle <"$zsh_plugins_src" >"$zsh_plugins_out"
fi
source "$zsh_plugins_out"

# ── Homebrew 补全 ─────────────────────────────────────────────
if [[ -n "$HOMEBREW_PREFIX" ]]; then
    FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}"
fi

# ── 工具动态补全注册（只在 zcompdump 过期时执行，避免每次启动都慢）──
# 各工具的补全脚本输出到 $ZDOTDIR/completions/，由 FPATH 统一加载
_setup_completions() {
    local comp_dir="$ZDOTDIR/completions"
    mkdir -p "$comp_dir"

    # mise（语言版本管理）
    (( $+commands[mise]    )) && mise completion zsh >| "$comp_dir/_mise" 2>/dev/null
    # kubectl / helm / docker / docker-compose 补全：由 OMZ 插件提供，此处不重复生成
    # gh（GitHub CLI）
    (( $+commands[gh]      )) && gh completion -s zsh >| "$comp_dir/_gh" 2>/dev/null
    # uv（Python 包管理）
    (( $+commands[uv]      )) && uv generate-shell-completion zsh >| "$comp_dir/_uv" 2>/dev/null
}

# 将自定义补全目录加入 FPATH（必须在 compinit 之前）
[[ -d "$ZDOTDIR/completions" ]] && FPATH="$ZDOTDIR/completions:${FPATH}"

# 每天重新生成一次补全脚本（避免每次启动都执行）
_comp_cache="$ZDOTDIR/.comp_setup_date"
if [[ ! -f "$_comp_cache" || $(date +%Y%m%d) != $(cat "$_comp_cache" 2>/dev/null) ]]; then
    _setup_completions
    date +%Y%m%d >| "$_comp_cache"
    # 生成新补全后强制刷新 zcompdump
    [[ -f "${ZSH_COMPDUMP:-$HOME/.zcompdump}" ]] && rm -f "${ZSH_COMPDUMP:-$HOME/.zcompdump}"
fi
unset _comp_cache

# 补全初始化（在所有插件加载后、FPATH 设置完成后执行）
# 用 -C 跳过安全检查（每天的 _setup_completions 已处理 zcompdump 刷新）
autoload -Uz compinit
compinit -C -d "${ZSH_COMPDUMP:-$HOME/.zcompdump}"

# ── fzf-tab（同步加载）────────────────────────────────────────
# 必须在 compinit 之后、fast-syntax-highlighting / zsh-autosuggestions 之前
# 包装补全 widget。antidote 那边用 kind:fpath，仅把目录加进 fpath，
# 这里再显式 source 一次，避免 defer 队列导致的加载顺序错乱和早按 Tab 落空。
_fzf_tab_plugin="$ANTIDOTE_HOME/github.com/Aloxaf/fzf-tab/fzf-tab.plugin.zsh"
[[ -f "$_fzf_tab_plugin" ]] && source "$_fzf_tab_plugin"
unset _fzf_tab_plugin

# ── carapace（通用补全聚合器，必须在 compinit 之后初始化）────
# 缓存到文件避免每次启动都 fork carapace 进程（约 50-100ms）
if (( $+commands[carapace] )); then
    _carapace_cache="$ZDOTDIR/completions/_carapace_init.zsh"
    if [[ ! -f "$_carapace_cache" || "$_carapace_cache" -ot "$(command -v carapace)" ]]; then
        mkdir -p "$ZDOTDIR/completions"
        carapace _carapace zsh >| "$_carapace_cache"
    fi
    source "$_carapace_cache"
fi

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
export FZF_DEFAULT_OPTS='--height 40% --tmux bottom,40% --layout reverse --border'

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--walker-skip .git,node_modules,target \
  --preview 'bat -n --color=always {} || cat {}' \
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_CTRL_R_OPTS="--preview 'echo {} | cut -f2 | bat --color=always --plain --language=sh' \
  --preview-window down:3:wrap --bind '?:toggle-preview' --exact"

export FZF_ALT_C_OPTS="--walker-skip .git,node_modules,target \
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
