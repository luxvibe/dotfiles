# ~/.config/zsh/plugins.zsh
# Core Zsh plugins management

# --- Environment Setup ---
if (( $+commands[brew] )); then
    eval "$(brew shellenv)"
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

if (( $+commands[mise] )); then
    eval "$(mise activate zsh)"
fi

# --- Zinit Setup ---
zinit light-mode depth"1" for \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl

# --- Starship Theme ---
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi

# --- Powerlevel10k Theme ---
# zinit ice depth=1
# zinit light romkatv/powerlevel10k

# --- Oh My Zsh Core ---
zinit for \
    OMZL::directories.zsh \
    OMZL::history.zsh \
    OMZL::key-bindings.zsh \
    OMZL::theme-and-appearance.zsh \
    OMZP::common-aliases

# --- Async Plugins ---
zinit wait lucid for \
    OMZP::colored-man-pages \
    OMZP::cp \
    OMZP::sudo \
    OMZP::tmux \
    OMZP::ansible \
    OMZP::git \
    OMZP::kubectl \
    OMZP::helm \
    OMZP::docker \
    OMZP::docker-compose \
    OMZP::extract \
    OMZP::chezmoi \
    OMZP::uv \
    OMZP::mise \
    OMZP::fancy-ctrl-z \
    MichaelAquilina/zsh-you-should-use

# --- Tools ---
# Navi
if ! (( $+commands[navi] )); then
    zinit ice from"gh-r" as"program"
    zinit light denisidoro/navi
fi
if (( $+commands[navi] )); then
    eval "$(navi widget zsh)"
fi

# --- Completion Enhancements ---
# (Must be loaded before Fzf-tab to ensure compinit is handled correctly)
zinit wait lucid depth"1" for \
    blockf \
    zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-history-substring-search \
    hlissner/zsh-autopair \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting

# --- Zoxide ---
if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh)"
    # Zoxide's internal fzf preview
    export _ZO_FZF_OPTS="--scheme=path --tiebreak=end,chunk,index            --bind=ctrl-z:ignore,btab:up,tab:down --cycle --keep-right            --border=sharp --height=45% --info=inline --layout=reverse            --tabstop=1 --exit-0 --select-1            --preview '(eza --tree --icons --level 3 --color=always            --group-directories-first {2} || tree -NC {2} ||            ls --color=always --group-directories-first {2}) 2>/dev/null | head -200'"
fi

# --- LS_COLORS (Vivid) ---
# Generate Catppuccin Mocha colors for ls/eza
# if (( $+commands[vivid] )); then
#     export LS_COLORS="$(vivid generate catppuccin-mocha)"
# fi

# --- Atuin ---
if (( $+commands[atuin] )); then
    eval "$(atuin init zsh --disable-up-arrow)"
fi

# --- Load FZF Ecosystem ---
# (This handles fzf theme, plugins like fzf-tab/forgit, and previews)
[[ -f ~/.config/fzf/fzf.zsh ]] && source ~/.config/fzf/fzf.zsh

# --- Powerlevel10k Configuration ---
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

