# AI / LLM 工具集成

# ── Claude Code（Anthropic）─────────────────────────────────
(( $+commands[claude] )) && alias cc='claude'

# ── Codex CLI（OpenAI）──────────────────────────────────────
(( $+commands[codex] )) && {
    alias cx='codex'           # 交互模式
    alias cxr='codex review'   # 代码审查（非交互）
}

# ── Kiro CLI（Amazon）───────────────────────────────────────
(( $+commands[kiro] )) && alias ki='kiro'

# ── GitHub Copilot（按需安装：gh extension install github/gh-copilot）
# (( $+commands[gh] )) && {
#     alias ghcs='gh copilot suggest'   # 建议命令
#     alias ghce='gh copilot explain'   # 解释命令
# }
