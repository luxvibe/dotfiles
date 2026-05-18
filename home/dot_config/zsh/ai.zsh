# AI / LLM 工具集成

# ── GitHub Copilot CLI ───────────────────────────────────────
(( $+commands[gh] )) && {
    alias '?'='gh copilot suggest'      # ? "list all running containers"
    alias '??'='gh copilot explain'     # ?? "what does kubectl drain do"
}

# ── aichat（会话式、RAG、多 provider）────────────────────────
(( $+commands[aichat] )) && {
    alias ai='aichat'
    alias aie='aichat -e'               # 直接执行模式（执行建议命令）
    alias ais='aichat --session'        # 开始一个命名会话
}

# ── mods（pipe 场景：命令输出 → LLM 解读）────────────────────
# 用法：kubectl get events | mods "有什么异常事件？"
#       cat error.log | mods "为什么报错？"
#       git diff | mods "写一个 commit message"
(( $+commands[mods] )) && alias m='mods'

# ── Claude Code ──────────────────────────────────────────────
(( $+commands[claude] )) && alias cc='claude'

# ── Gemini CLI ───────────────────────────────────────────────
(( $+commands[gemini] )) && alias gm='gemini'

# ── Ollama（本地 LLM）────────────────────────────────────────
(( $+commands[ollama] )) && {
    alias oll='ollama run'              # oll llama3
    alias olls='ollama list'            # 已下载模型列表
    alias ollps='ollama ps'             # 运行中的模型
}

# ── AI 命令解释（替代 tldr / man / cheat）────────────────────
# 优先级：aichat → mods → ollama，均不可用时降级到 tldr
#
# 用法：
#   exp "kubectl drain"           → 解释命令用途和常用参数
#   exp "git rebase -i HEAD~3"    → 解释完整命令行
#   cat script.sh | exp           → 解释脚本内容（pipe 模式）
exp() {
    local prompt="用简洁的中文解释以下命令或概念，包含常用参数示例：$*"
    if (( $+commands[aichat] )); then
        if [[ -p /dev/stdin ]]; then
            aichat "用简洁的中文解释以下内容：$(cat)"
        else
            aichat "$prompt"
        fi
    elif (( $+commands[mods] )); then
        if [[ -p /dev/stdin ]]; then
            mods "用简洁的中文解释以下内容"
        else
            echo "$*" | mods "用简洁的中文解释这个命令"
        fi
    elif (( $+commands[ollama] )); then
        ollama run llama3 "$prompt"
    else
        echo "未找到可用的 AI 工具，请安装 aichat 或 mods"
    fi
}

# ── AI 命令建议（描述需求 → 给出命令）───────────────────────
# 用法：how "把当前目录所有 jpg 转成 webp"
#       how "找出占用 8080 端口的进程并杀掉"
how() {
    local prompt="给出完成以下任务的 shell 命令（macOS/zsh），只输出命令本身和简短说明：$*"
    if (( $+commands[aichat] )); then
        aichat -e "$prompt"             # -e 模式可直接执行建议的命令
    elif (( $+commands[mods] )); then
        echo "$*" | mods "给出完成这个任务的 shell 命令（macOS/zsh），只输出命令和简短说明"
    elif (( $+commands[gh] )); then
        gh copilot suggest -t shell "$*"
    else
        echo "未找到可用的 AI 工具"
    fi
}

# ── Copilot Widget（Ctrl-X Ctrl-A → 把当前命令行发给 copilot）
if (( $+commands[gh] )); then
    _gh_copilot_suggest() {
        local cmd="$BUFFER"
        BUFFER=""
        zle reset-prompt
        local suggestion
        suggestion=$(gh copilot suggest -t shell "$cmd" 2>/dev/null)
        if [[ -n "$suggestion" ]]; then
            BUFFER="$suggestion"
            zle end-of-line
        fi
    }
    zle -N _gh_copilot_suggest
    bindkey '^X^A' _gh_copilot_suggest
fi
