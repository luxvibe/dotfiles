# ~/.config/fzf/fzf.zsh
# FZF Ecosystem Configuration (Theming, Plugins, Previews)

# --- 1. Theming (Catppuccin Macchiato) ---
export FZF_DEFAULT_OPTS=" --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 --height 40% --tmux 100%,60% --border --layout=reverse --info=inline"

# --- 2. Default Command ---
# Use fd for blazing fast file finding (respects .gitignore)
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# --- 3. Plugins (Loaded via Zinit) ---

# Forgit: Git interactive mode (ctrl+g)
zinit ice wait lucid depth"1"
zinit light wfxr/forgit

# Fzf-tab: The killer feature (replaces zsh completion menu)
# Needs to run after compinit
zinit ice wait lucid depth"1" atload"zicompinit; zicdreplay" blockf
zinit light Aloxaf/fzf-tab

# --- 4. Fzf-tab Configuration (Previews & Behaviors) ---

# Basic behavior
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:git-checkout:*' sort false

# Colors
if [[ -n "$LS_COLORS" ]]; then
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# Previews
# cd: Preview directory content
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

# Environment variables
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' 	fzf-preview 'echo ${(P)word}'

# Process kill
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview 'ps -p $word -o command= -w'

# Git previews (Delta integration)
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 	'git diff $word | delta'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 	'git log --color=always $word'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview 	'git show --color=always $word | delta'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview 	'[ -f "$realpath" ] && git diff $word | delta || git log --color=always $word'
