# AI / LLM 工具集成

# ── Claude Code ──────────────────────────────────────────────
(( $+commands[claude] )) && alias cc='claude'

# ── Ollama（本地 LLM）────────────────────────────────────────
(( $+commands[ollama] )) && {
    alias oll='ollama run'              # oll llama3
    alias olls='ollama list'            # 已下载模型列表
    alias ollps='ollama ps'             # 运行中的模型
}

# ── AI 命令解释（替代 tldr / man / cheat）────────────────────
# 用法：
#   exp "kubectl drain"           → 解释命令用途和常用参数
#   exp "git rebase -i HEAD~3"    → 解释完整命令行
#   cat script.sh | exp           → 解释脚本内容（pipe 模式）
exp() {
    local prompt="用简洁的中文解释以下命令或概念，包含常用参数示例：$*"
    if (( $+commands[agy] )); then
        if [[ -p /dev/stdin ]]; then
            agy "用简洁的中文解释以下内容：$(cat)"
        else
            agy "$prompt"
        fi
    elif (( $+commands[ollama] )); then
        ollama run llama3 "$prompt"
    else
        echo "未找到可用的 AI 工具，请安装 agy"
    fi
}

# ── AI 命令建议（描述需求 → 给出命令）───────────────────────
# 用法：how "把当前目录所有 jpg 转成 webp"
#       how "找出占用 8080 端口的进程并杀掉"
how() {
    local prompt="给出完成以下任务的 shell 命令（macOS/zsh），只输出命令本身和简短说明：$*"
    if (( $+commands[agy] )); then
        agy "$prompt"
    elif (( $+commands[ollama] )); then
        ollama run llama3 "$prompt"
    else
        echo "未找到可用的 AI 工具，请安装 agy"
    fi
}
