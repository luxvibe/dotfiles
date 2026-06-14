# sheldon 插件管理（配置：~/.config/sheldon/plugins.toml）

# zsh-history-substring-search 按键绑定，由 zsh-defer 在插件加载后调用
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

(( $+commands[sheldon] )) || { print -P "%F{33}sheldon not found, run: brew install sheldon%f"; return }

# 缓存 sheldon source 输出，config 变化时重新生成
_sheldon_cache="${XDG_CACHE_HOME:-$HOME/.cache}/sheldon/init.zsh"
_sheldon_toml="${XDG_CONFIG_HOME:-$HOME/.config}/sheldon/plugins.toml"
if [[ ! -f "$_sheldon_cache" || "$_sheldon_toml" -nt "$_sheldon_cache" ]]; then
    mkdir -p "${_sheldon_cache:h}"
    if [[ ! -f "$_sheldon_cache" ]]; then
        # 首次运行：显示进度，让用户看到插件下载过程
        print -P "%F{yellow}sheldon: 首次初始化，正在下载插件...%f"
        if sheldon source >| "$_sheldon_cache"; then
            print -P "%F{green}sheldon: 插件加载完成，重新打开终端生效%f"
        else
            command rm -f "$_sheldon_cache"
            print -P "%F{red}sheldon: 初始化失败，运行 'sheldon source' 查看详情%f" >&2
        fi
    else
        # 后续更新（config 变化）：静默执行，错误记录到日志
        if ! sheldon source >| "$_sheldon_cache" 2>/tmp/sheldon-init.log; then
            command rm -f "$_sheldon_cache"
            print -P "%F{red}sheldon: 更新失败，详情见 /tmp/sheldon-init.log%f" >&2
        fi
    fi
fi
[[ -f "$_sheldon_cache" ]] && source "$_sheldon_cache"
unset _sheldon_cache _sheldon_toml

# 在所有 deferred 插件加载完成后绑定 history-substring-search 按键
# zsh-defer 由 sheldon 加载；初始化失败时跳过，避免 command not found 报错
(( $+functions[zsh-defer] )) && zsh-defer _hss_bindkey

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
    # mise/gh/atuin/eza/fd/rg 等已由 Homebrew 在 site-functions 自动提供，无需重复生成
    (( $+commands[kubectl] )) && kubectl completion zsh >| "$comp_dir/_kubectl" 2>/dev/null
    (( $+commands[helm]    )) && helm completion zsh >| "$comp_dir/_helm" 2>/dev/null
    (( $+commands[uv]      )) && uv generate-shell-completion zsh >| "$comp_dir/_uv" 2>/dev/null
    (( $+commands[uvx]     )) && uvx --generate-shell-completion zsh >| "$comp_dir/_uvx" 2>/dev/null
    # docker/docker-compose: OrbStack fpath 注入
    # aws/k9s/trivy/terragrunt/tofu 等: carapace 聚合处理
}

# 将自定义补全目录加入 FPATH（必须在 compinit 之前，无论目录是否已存在）
FPATH="$ZDOTDIR/completions:${FPATH}"
typeset -U fpath  # 去除重复项（OrbStack/sheldon 的 fpath+= 可能造成重复）

# 每天重新生成一次补全脚本（避免每次启动都执行）
_comp_cache="$ZDOTDIR/.comp_setup_date"
zmodload zsh/datetime
strftime -s _today '%Y%m%d' $EPOCHSECONDS
if [[ ! -f "$_comp_cache" || "$_today" != "$(<$_comp_cache)" ]]; then
    _setup_completions
    print -r -- "$_today" >| "$_comp_cache"
    # 生成新补全后强制刷新 zcompdump
    [[ -f "${ZSH_COMPDUMP:-$HOME/.zcompdump}" ]] && rm -f "${ZSH_COMPDUMP:-$HOME/.zcompdump}"
fi
unset _comp_cache _today
unfunction _setup_completions

# 补全初始化（在所有插件加载后、FPATH 设置完成后执行）
# 用 -C 跳过安全检查（每天的 _setup_completions 已处理 zcompdump 刷新）
export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
autoload -Uz compinit
compinit -C -d "$ZSH_COMPDUMP"

# ── fzf-tab（同步加载）────────────────────────────────────────
# 必须在 compinit 之后、fast-syntax-highlighting / zsh-autosuggestions 之前
# 包装补全 widget。sheldon 用 apply=["fpath"] 仅注册目录，
# 这里再显式 source 一次，避免 defer 队列导致的加载顺序错乱和早按 Tab 落空。
_fzf_tab_plugin="${XDG_DATA_HOME:-$HOME/.local/share}/sheldon/repos/github.com/Aloxaf/fzf-tab/fzf-tab.plugin.zsh"
[[ -f "$_fzf_tab_plugin" ]] && source "$_fzf_tab_plugin"
unset _fzf_tab_plugin

# ── carapace（通用补全聚合器，必须在 compinit 之后初始化）────
# 缓存放在 cache 目录而非 fpath 目录（init 脚本不是补全函数，不应被 compinit 扫描）
if (( $+commands[carapace] )); then
    _carapace_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/carapace_init.zsh"
    if [[ ! -f "$_carapace_cache" || "$_carapace_cache" -ot "${commands[carapace]}" ]]; then
        mkdir -p "${_carapace_cache:h}"
        carapace _carapace zsh >| "$_carapace_cache" 2>/dev/null || command rm -f "$_carapace_cache"
    fi
    [[ -f "$_carapace_cache" ]] && source "$_carapace_cache"
    unset _carapace_cache
    # carapace 的 compdef 会覆盖 compinit 注册的原生补全函数；
    # 对已有本地高质量补全文件的工具恢复原生优先级（动态资源补全更准确）
    local _cd="$ZDOTDIR/completions" _hb="$HOMEBREW_PREFIX/share/zsh/site-functions"
    [[ -f "$_cd/_kubectl" ]] && compdef _kubectl kubectl
    [[ -f "$_cd/_helm"    ]] && compdef _helm helm
    [[ -f "$_cd/_uv"      ]] && compdef _uv uv
    [[ -f "$_cd/_uvx"     ]] && compdef _uvx uvx
    [[ -f "$_hb/_gh"      ]] && compdef _gh gh
    unset _cd _hb
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
# FZF_DEFAULT_OPTS 只放 inline 参数，确保 fzf-tab（use-fzf-default-opts yes）
# 能正常嵌入渲染；--tmux 会开 popup 模式，与 fzf-tab 的 inline widget 冲突
export FZF_DEFAULT_OPTS='--height 40% --layout reverse --border'

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
