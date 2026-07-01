# 动态补全：mise 清单 + gencomp 按需（brew 由 site-functions 自动处理）

export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
typeset -g ZSH_COMPLETIONS_DIR="$ZDOTDIR/completions"

# 与 mise config.toml 对齐的 CLI 工具（语言运行时不放这里）
typeset -ga COMPLETION_MISE_TOOLS=(
    kubectl helm tofu
    uv uvx
    air sqlc migrate shfmt golangci-lint
)

# 非标准 completion 子命令
typeset -gA COMPLETION_OVERRIDES=(
    uv  'generate-shell-completion zsh'
    uvx '--generate-shell-completion zsh'
)

local -a _comp_patterns=( 'completion zsh' 'complete zsh' 'generate-shell-completion zsh' )

_comp_run_timeout() {
    if (( $+commands[timeout] )); then
        command timeout 1 "$@"
    elif (( $+commands[perl] )); then
        perl -e 'alarm 1; exec @ARGV' -- "$@"
    else
        "$@"
    fi
}

_comp_pattern_for() {
    local cmd="$1" out="$ZSH_COMPLETIONS_DIR/_$cmd"
    [[ -f "$out.pat" ]] && { cat "$out.pat"; return 0; }
    [[ -n "${COMPLETION_OVERRIDES[$cmd]}" ]] && { print -r -- "${COMPLETION_OVERRIDES[$cmd]}"; return 0; }
    print -r -- 'completion zsh'
}

_comp_refresh() {
    local cmd="$1" bin out pat
    bin="${commands[$cmd]:A}"
    out="$ZSH_COMPLETIONS_DIR/_$cmd"
    [[ -n "$bin" ]] || return 1
    [[ -n "$HOMEBREW_PREFIX" && -f "$HOMEBREW_PREFIX/share/zsh/site-functions/_$cmd" ]] && return 1
    [[ -f "$out" && -s "$out" && ! "$bin" -nt "$out" ]] && return 1

    pat="$(_comp_pattern_for "$cmd")"
    mkdir -p "$ZSH_COMPLETIONS_DIR"
    if ! _comp_run_timeout "$bin" ${=pat} >|"$out" 2>/dev/null; then
        command rm -f "$out"
        return 1
    fi
    [[ "$(head -1 "$out")" == *'#compdef'* ]] || { command rm -f "$out"; return 1; }
}

_comp_try_discover() {
    local cmd="$1" bin="$2" out="$3" pat
    for pat in $_comp_patterns; do
        _comp_run_timeout "$bin" ${=pat} >|"$out" 2>/dev/null || continue
        [[ "$(head -1 "$out")" == *'#compdef'* ]] || { command rm -f "$out"; continue; }
        print -r -- "$pat" >|"$out.pat"
        return 0
    done
    command rm -f "$out"
    return 1
}

# ── 启动：刷新清单 + 已有 gencomp 文件 ───────────────────────
local -i _comp_stale=0 cmd f
mkdir -p "$ZSH_COMPLETIONS_DIR"
for cmd in $COMPLETION_MISE_TOOLS; do
    if _comp_refresh "$cmd"; then (( _comp_stale++ )); fi
done
for f in "$ZSH_COMPLETIONS_DIR"/_*(N); do
    cmd="${${f:t}#_}"
    if [[ -z "${commands[$cmd]}" ]]; then
        command rm -f "$f" "$f.pat"
        (( _comp_stale++ ))
        continue
    fi
    [[ ${COMPLETION_MISE_TOOLS[(Ie)$cmd]} -gt 0 ]] && continue
    if _comp_refresh "$cmd"; then (( _comp_stale++ )); fi
done
if (( _comp_stale > 0 )) && [[ -f "$ZSH_COMPDUMP" ]]; then
    command rm -f "$ZSH_COMPDUMP"
fi

FPATH="$ZSH_COMPLETIONS_DIR:${FPATH}"
typeset -U fpath

# ── 手动生成（curl / npm 等）──────────────────────────────────
gencomp() {
    local cmd="$1"
    if [[ -z "$cmd" ]]; then
        print -u2 "用法: gencomp <cmd> [completion-args...] | gencomp --list | gencomp --flush <cmd>"
        return 2
    fi
    if [[ "$cmd" == --list ]]; then
        local f
        for f in "$ZSH_COMPLETIONS_DIR"/_*(N); do print -r -- "${f:t}"; done
        return 0
    fi
    if [[ "$cmd" == --flush ]]; then
        [[ -z "$2" ]] && { print -u2 "gencomp: 请指定命令名"; return 2; }
        command rm -f "$ZSH_COMPLETIONS_DIR/_$2" "$ZSH_COMPLETIONS_DIR/_$2.pat"
        [[ -f "$ZSH_COMPDUMP" ]] && command rm -f "$ZSH_COMPDUMP"
        return 0
    fi

    local bin="${commands[$cmd]:A}" out="$ZSH_COMPLETIONS_DIR/_$cmd"
    [[ -z "$bin" ]] && { print -u2 "gencomp: 命令未找到: $cmd"; return 1; }
    if [[ -n "$HOMEBREW_PREFIX" && -f "$HOMEBREW_PREFIX/share/zsh/site-functions/_$cmd" ]]; then
        print -P "%F{yellow}提示:%f $cmd 已由 brew site-functions 提供补全"
        return 0
    fi

    shift
    if (( $# )); then
        mkdir -p "$ZSH_COMPLETIONS_DIR"
        _comp_run_timeout "$bin" "$@" >|"$out" 2>/dev/null || { print -u2 "gencomp: 生成失败"; return 1; }
        [[ "$(head -1 "$out")" == *'#compdef'* ]] || { command rm -f "$out"; print -u2 "gencomp: 输出无效"; return 1; }
        print -r -- "$*" >|"$out.pat"
    elif ! _comp_try_discover "$cmd" "$bin" "$out" && ! _comp_refresh "$cmd"; then
        [[ -f "$out" ]] && { print -P "%F{yellow}补全已是最新:%f $out"; return 0; }
        print -u2 "gencomp: $cmd 不支持常见 completion，请手动指定参数"
        return 1
    fi

    [[ -f "$ZSH_COMPDUMP" ]] && command rm -f "$ZSH_COMPDUMP"
    autoload -Uz compinit && compinit -C -d "$ZSH_COMPDUMP"
    print -P "%F{green}✓%f 已生成 $out"
}