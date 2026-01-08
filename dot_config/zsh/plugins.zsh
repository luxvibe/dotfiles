# ~/.config/zsh/plugins.zsh
# Zsh plugins configuration

# ------------------------------------------------------------------------------
# 1. Environment Setup (MUST BE FIRST)
# ------------------------------------------------------------------------------

# Homebrew Setup
if (( $+commands[brew] )); then
    eval "$(brew shellenv)"
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# Mise Setup
if (( $+commands[mise] )); then
    eval "$(mise activate zsh)"
fi

# ------------------------------------------------------------------------------
# 2. Zinit Configuration
# ------------------------------------------------------------------------------

zinit light-mode depth"1" for \
      zdharma-continuum/zinit-annex-bin-gem-node \
      zdharma-continuum/zinit-annex-patch-dl

# Oh My Zsh core
zinit for \
      OMZL::directories.zsh \
      OMZL::history.zsh \
      OMZL::key-bindings.zsh \
      OMZL::theme-and-appearance.zsh \
      OMZP::common-aliases

# Async Plugins
zinit wait lucid for \
      OMZP::colored-man-pages \
      OMZP::cp \
      OMZP::sudo \
      OMZP::tmux \
      OMZP::ansible \
      OMZP::git \
      OMZP::laravel \
      OMZP::python \
      OMZP::kubectl \
      OMZP::terraform \
      OMZP::helm \
      OMZP::docker \
      OMZP::docker-compose \
      OMZP::extract \
      OMZP::fnm \
      OMZP::chezmoi \
      OMZP::uv \
      OMZP::fancy-ctrl-z \
      MichaelAquilina/zsh-you-should-use

# Navi - Interactive Cheatsheet (Official Setup)
# First, ensure navi is installed (prefer GitHub release binary for speed)
if ! (( $+commands[navi] )); then
    zinit ice from"gh-r" as"program"
    zinit light denisidoro/navi
fi
# Then, load the widget immediately (not async) to ensure keybinding works
if (( $+commands[navi] )); then
    eval "$(navi widget zsh)"
fi

# Completion enhancements
zinit wait lucid depth"1" for \
      atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
      zdharma-continuum/fast-syntax-highlighting \
      blockf \
      zsh-users/zsh-completions \
      atload"!_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
      zsh-users/zsh-history-substring-search \
      hlissner/zsh-autopair

# Zoxide
if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh)"
    export _ZO_FZF_OPTS="--scheme=path --tiebreak=end,chunk,index \
           --bind=ctrl-z:ignore,btab:up,tab:down --cycle --keep-right \
           --border=sharp --height=45% --info=inline --layout=reverse \
           --tabstop=1 --exit-0 --select-1 \
           --preview '(eza --tree --icons --level 3 --color=always \
           --group-directories-first {2} || tree -NC {2} || \
           ls --color=always --group-directories-first {2}) 2>/dev/null | head -200'"
fi

# FZF: fuzzy finder settings
if (( $+commands[brew] )); then
    FZF="$(brew --prefix)/opt/fzf/shell/"
elif [[ -d "/usr/share/fzf" ]]; then
    FZF="/usr/share/fzf/"
fi

[[ -f "$FZF/completion.zsh" ]] && source "$FZF/completion.zsh"
[[ -f "$FZF/key-bindings.zsh" ]] && source "$FZF/key-bindings.zsh"

# Git utilities powered by FZF
zinit ice wait lucid depth"1"
zinit light wfxr/forgit

# FZF-tab
zinit ice wait lucid depth"1" atload"zicompinit; zicdreplay" blockf
zinit light Aloxaf/fzf-tab

# FZF settings
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 40% --tmux 100%,60% --border'

# Completion Styles

# Initialize LS_COLORS using system defaults (safe fallback)

# This prevents "zsh: command not found: di=..." errors while keeping iTerm2 colors

if [[ -z "$LS_COLORS" ]]; then

  if (( $+commands[dircolors] )); then

    # GNU/Linux or brew coreutils

    eval "$(dircolors -b)"

  elif (( $+commands[gdircolors] )); then

    # macOS with brew coreutils

    eval "$(gdircolors -b)"

  else

    # BSD/macOS default (uses LSCOLORS -> LS_COLORS mapping)

    export CLICOLOR=1

    zstyle ':completion:*' list-colors ''

  fi

fi



# Apply colors to completion list if LS_COLORS is present

if [[ -n "$LS_COLORS" ]]; then

  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

fi



zstyle ':completion:*' menu no

zstyle ':completion:*:descriptions' format '[%d]'

zstyle ':fzf-tab:*' switch-group '<' '>'

# Powerlevel10k
zinit ice depth"1"
zinit light romkatv/powerlevel10k
# --- Fzf-tab Advanced Configuration ---
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ${(P)word}'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview 'ps -p $word -o command= -w'
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff $word | delta'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --color=always $word'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview 'git show --color=always $word | delta'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview '[ -f "$realpath" ] && git diff $word | delta || git log --color=always $word'

# Atuin Initialization
if command -v atuin &>/dev/null; then
    eval "$(atuin init zsh)"
fi
