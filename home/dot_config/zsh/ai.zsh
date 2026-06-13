# AI / LLM 工具集成

# ── Claude Code ──────────────────────────────────────────────
(( $+commands[claude] )) && alias cc='claude'

# ── Ollama（本地 LLM）────────────────────────────────────────
(( $+commands[ollama] )) && {
    alias oll='ollama run'              # oll llama3
    alias olls='ollama list'            # 已下载模型列表
    alias ollps='ollama ps'             # 运行中的模型
}

