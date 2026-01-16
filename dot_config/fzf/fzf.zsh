# ~/.config/fzf/fzf.zsh
# FZF Ecosystem Configuration (Theming, Plugins, Previews)

# --- 1. Theming ---

# --- 2. Default Command ---
# Use fd for blazing fast file finding (respects .gitignore)
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# --- Carapace (Fallback completions) ---
__carapace_register() {
  (( $+commands[carapace] )) || return 0
  (( $+_comps )) || return 0

  local carapace_init compdef_line
  local -a lines eval_lines
  carapace_init="$(carapace _carapace zsh)"
  lines=("${(@f)carapace_init}")
  for line in $lines; do
    if [[ $line == compdef\ _carapace_completer* ]]; then
      compdef_line=$line
    else
      eval_lines+=("$line")
    fi
  done

  # 只为没有现成补全的命令注册 Carapace
  eval "${(F)eval_lines}"
  [[ -z $compdef_line ]] && return 0

  local -a carapace_cmds
  eval "carapace_cmds=(${compdef_line#compdef _carapace_completer })"

  local cmd
  for cmd in $carapace_cmds; do
    if [[ -z ${_comps[$cmd]} ]]; then
      compdef _carapace_completer "$cmd"
    fi
  done
}

# --- 3. Plugins (Loaded via Zinit) ---

# Forgit: Git interactive mode (ctrl+g)
zinit ice wait lucid depth"1"
zinit light wfxr/forgit

# Fzf-tab: The killer feature (replaces zsh completion menu)
# Needs to run after compinit
# 若补全异常，可删除 ~/.zcompdump* 后重开终端
zinit ice wait lucid depth"1" atload' zicompinit; zicdreplay; __carapace_register' blockf
zinit light Aloxaf/fzf-tab

# --- 4. Fzf-tab Configuration (Previews & Behaviors) ---

# Basic behavior
zstyle ':fzf-tab:*' switch-group '<' '>'
# 避免用完整输入作为查询，导致候选被过滤为空
zstyle ':fzf-tab:*' query-string prefix
zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format ''
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
