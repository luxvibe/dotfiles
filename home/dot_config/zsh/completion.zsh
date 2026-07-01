# 动态补全：mise 清单 + gencomp 手动生成（brew 由 site-functions 自动处理）

export ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
typeset -g ZSH_COMPLETIONS_DIR="$ZDOTDIR/completions"

# 与 mise config.toml 对齐的 CLI 工具（语言运行时不放这里）；只在 gencomp --all 时使用
typeset -ga COMPLETION_MISE_TOOLS=(
    kubectl helm tofu
    uv uvx
    sqlc migrate shfmt golangci-lint
)

# 非标准 completion 子命令
typeset -gA COMPLETION_OVERRIDES=(
    uv  'generate-shell-completion zsh'
    uvx '--generate-shell-completion zsh'
)

typeset -ga _comp_patterns=( 'completion zsh' 'complete zsh' 'generate-shell-completion zsh' )

_comp_pattern_for() {
    local cmd="$1" out="$ZSH_COMPLETIONS_DIR/_$cmd"
    [[ -f "$out.pat" ]] && { cat "$out.pat"; return 0; }
    [[ -n "${COMPLETION_OVERRIDES[$cmd]}" ]] && { print -r -- "${COMPLETION_OVERRIDES[$cmd]}"; return 0; }
    print -r -- 'completion zsh'
}

# 前台直接执行并校验输出；卡住由调用者（人）Ctrl-C 处理，不做超时保护——
# 因为现在只由 gencomp 手动触发，不再在无人看管的 shell 启动阶段跑任意二进制。
_comp_write_completion() {
    local cmd="$1" bin="$2" out="$ZSH_COMPLETIONS_DIR/_$1"
    shift 2
    mkdir -p "$ZSH_COMPLETIONS_DIR"
    if ! "$bin" "$@" >|"$out" 2>/dev/null; then
        command rm -f "$out"
        return 1
    fi
    if [[ "$(head -1 "$out" 2>/dev/null)" != *'#compdef'* ]]; then
        command rm -f "$out"
        return 1
    fi
    print -r -- "$*" >|"$out.pat"
}

_comp_try_discover() {
    local cmd="$1" bin="$2" pat
    for pat in $_comp_patterns; do
        _comp_write_completion "$cmd" "$bin" ${=pat} && return 0
    done
    return 1
}

# ── 启动：只挂 FPATH，不做任何检测/生成 ─────────────────────
FPATH="$ZSH_COMPLETIONS_DIR:${FPATH}"
typeset -U fpath

# ── 手动生成/刷新/清理 ──────────────────────────────────────
_gencomp_one() {
    local cmd="$1"; shift
    local bin="${commands[$cmd]:A}" out="$ZSH_COMPLETIONS_DIR/_$cmd"
    [[ -z "$bin" ]] && { print -u2 "gencomp: 命令未找到: $cmd"; return 1; }
    if [[ -n "$HOMEBREW_PREFIX" && -f "$HOMEBREW_PREFIX/share/zsh/site-functions/_$cmd" ]]; then
        print -P "%F{yellow}提示:%f $cmd 已由 brew site-functions 提供补全"
        return 0
    fi
    mkdir -p "$ZSH_COMPLETIONS_DIR"
    if (( $# )); then
        _comp_write_completion "$cmd" "$bin" "$@" && return 0
        print -u2 "gencomp: 生成失败或输出不含 #compdef"
        return 1
    fi
    local pat; pat="$(_comp_pattern_for "$cmd")"
    _comp_write_completion "$cmd" "$bin" ${=pat} && return 0
    _comp_try_discover "$cmd" "$bin" && return 0
    print -u2 "gencomp: $cmd 不支持常见 completion 写法，请手动指定参数，如 gencomp $cmd completion zsh"
    return 1
}

_gencomp_rebuild_dump() {
    [[ -f "$ZSH_COMPDUMP" ]] && command rm -f "$ZSH_COMPDUMP"
    autoload -Uz compinit && compinit -C -d "$ZSH_COMPDUMP"
}

gencomp() {
    local cmd="$1"
    if [[ -z "$cmd" ]]; then
        print -u2 "用法: gencomp <cmd> [completion-args...] | gencomp --all | gencomp --list | gencomp --flush <cmd>"
        return 2
    fi
    case "$cmd" in
        --list)
            local f
            for f in "$ZSH_COMPLETIONS_DIR"/_*(N); do print -r -- "${f:t}"; done
            return 0
            ;;
        --flush)
            [[ -z "$2" ]] && { print -u2 "gencomp: 请指定命令名"; return 2; }
            command rm -f "$ZSH_COMPLETIONS_DIR/_$2" "$ZSH_COMPLETIONS_DIR/_$2.pat"
            [[ -f "$ZSH_COMPDUMP" ]] && command rm -f "$ZSH_COMPDUMP"
            return 0
            ;;
        --all)
            local t failed=()
            for t in $COMPLETION_MISE_TOOLS; do
                _gencomp_one "$t" || failed+=("$t")
            done
            local f cmdname
            for f in "$ZSH_COMPLETIONS_DIR"/_*(N); do
                cmdname="${${f:t}#_}"
                [[ -z "${commands[$cmdname]}" ]] && command rm -f "$f" "$f.pat"
            done
            _gencomp_rebuild_dump
            if (( $#failed )); then
                print -P "%F{yellow}以下工具生成失败:%f ${(j:, :)failed}"
                return 1
            fi
            print -P "%F{green}✓%f 全部补全已刷新"
            return 0
            ;;
    esac

    shift
    if _gencomp_one "$cmd" "$@"; then
        _gencomp_rebuild_dump
        print -P "%F{green}✓%f 已生成 $ZSH_COMPLETIONS_DIR/_$cmd"
        return 0
    fi
    return 1
}
