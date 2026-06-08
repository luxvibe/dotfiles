# ── 通用工具 ─────────────────────────────────────────────────

# 安全删除：移入垃圾桶而非永久删除，用法与 rm 一致
rm() {
    if ! (( $+commands[trash] )); then
        command rm "$@"
        return
    fi
    local targets=()
    for arg in "$@"; do [[ "$arg" != -* ]] && targets+=("$arg"); done
    trash "${targets[@]}"
}

# 创建目录并进入
mkcd() { mkdir -p "$1" && cd "$1"; }

# 查询天气
weather() { curl -s "wttr.in/${1:-}?lang=zh&format=v2"; }

# ── FZF 工作流 ───────────────────────────────────────────────

# fzf 选进程并 kill
fkill() {
    local pid
    pid=$(command ps -u "$USER" -o pid,ppid,comm,args | fzf --header-lines=1 --multi \
          --preview 'command ps -p {1} -o pid,ppid,user,comm,args,etime,pcpu,pmem --no-headers 2>/dev/null' \
          --preview-window=down:4 | awk '{print $1}')
    [[ -n "$pid" ]] && echo "$pid" | xargs kill -9 && echo "已终止 PID: $pid"
}

# fzf 选目录并进入（递归）
fcd() {
    local dir
    dir=$(fd --type d --hidden --exclude .git 2>/dev/null | fzf \
          --preview 'eza --tree --level 2 --color=always {} 2>/dev/null || ls {}')
    [[ -n "$dir" ]] && cd "$dir"
}

# ripgrep 搜索 + fzf 预览 + 在 nvim 打开
rgv() {
    rg --color=always --line-number --no-heading --smart-case "${*:-}" |
    fzf --ansi --height 80% --tmux 100%,80% \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind "enter:become(nvim +{2} {1})"
}

# ── Docker 工作流 ────────────────────────────────────────────

# fzf 选容器并进入 shell
dsh() {
    local container
    container=$(docker ps --format '{{.Names}}\t{{.Image}}\t{{.Status}}' |
                fzf --header 'Container  Image  Status' \
                    --preview 'docker inspect {1} | jq ".[0] | {State, Config: .Config.Env}"' |
                awk '{print $1}')
    [[ -n "$container" ]] && docker exec -it "$container" /bin/sh
}

# fzf 选容器并跟踪日志
dlog() {
    local container
    container=$(docker ps --format '{{.Names}}\t{{.Image}}\t{{.Status}}' |
                fzf --header 'Container  Image  Status' | awk '{print $1}')
    [[ -n "$container" ]] && docker logs -f "$container"
}

# ── Kubernetes 工作流 ────────────────────────────────────────

# fzf 选 pod 并进入 shell
kpod() {
    local ns="${1:-default}"
    local pod
    pod=$(kubectl get pods -n "$ns" --no-headers 2>/dev/null |
          fzf --preview "kubectl describe pod -n $ns {1} | bat -plyaml --color=always" |
          awk '{print $1}')
    [[ -n "$pod" ]] && kubectl exec -it -n "$ns" "$pod" -- /bin/sh
}

# fzf 选 pod 并跟踪日志
klogf() {
    local ns="${1:-default}"
    local pod
    pod=$(kubectl get pods -n "$ns" --no-headers 2>/dev/null |
          fzf --preview "kubectl logs -n $ns --tail=20 {1}" |
          awk '{print $1}')
    [[ -n "$pod" ]] && kubectl logs -f -n "$ns" "$pod"
}

# ── Homebrew Mirror（中国大陆加速）──────────────────────────
set_homebrew_mirror() {
    export HOMEBREW_API_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles/api"
    export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"
    export HOMEBREW_PIP_INDEX_URL="https://mirrors.ustc.edu.cn/pypi/simple"
    echo "Homebrew 已切换到 USTC 镜像"
}

reset_homebrew_mirror() {
    unset HOMEBREW_API_DOMAIN HOMEBREW_BOTTLE_DOMAIN HOMEBREW_PIP_INDEX_URL
    echo "Homebrew 已切换回官方源"
}

# ── mitmweb 抓包 ─────────────────────────────────────────────
# 启动 mitmweb 并将当前终端流量导入
mitmweb_on() {
    local port="${1:-8080}"
    if pgrep -f "mitmweb" &>/dev/null; then
        echo "mitmweb 已在运行，Web UI: http://127.0.0.1:8081"
    else
        mitmweb --listen-port "$port" &>/tmp/mitmweb.log &
        sleep 1
        echo "mitmweb 已启动 (port: $port, Web UI: http://127.0.0.1:8081)"
        open "http://127.0.0.1:8081"
    fi
    export http_proxy="http://127.0.0.1:${port}"
    export https_proxy="http://127.0.0.1:${port}"
    export no_proxy="localhost,127.0.0.1,*.local"
    echo "终端代理已设置 → http://127.0.0.1:${port}"
}

# 停止 mitmweb 并清除代理
mitmweb_off() {
    pkill -f "mitmweb" 2>/dev/null && echo "mitmweb 已停止" || echo "mitmweb 未在运行"
    unset http_proxy https_proxy no_proxy
    echo "终端代理已清除"
}

# ── Yazi（退出后自动 cd 到最后所在目录）─────────────────────
y() {
    local tmp cwd
    tmp=$(mktemp -t "yazi-cwd.XXXXXX")
    yazi "$@" --cwd-file="$tmp"
    cwd=$(cat "$tmp" 2>/dev/null)
    [[ -n "$cwd" && "$cwd" != "$PWD" ]] && cd "$cwd"
    rm -f "$tmp"
}