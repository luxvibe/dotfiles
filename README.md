# ⚡️ Dotfiles

> My highly opinionated, performance-tuned, and aesthetic development environment.
> Managed by **chezmoi**.

![Ghostty](https://img.shields.io/badge/Terminal-Ghostty-blue?style=for-the-badge&logo=ghostty)
![Shell](https://img.shields.io/badge/Shell-Zsh-green?style=for-the-badge&logo=zsh)
![Editor](https://img.shields.io/badge/Editor-Neovim-green?style=for-the-badge&logo=neovim)
![Tmux](https://img.shields.io/badge/Multiplexer-Tmux-yellow?style=for-the-badge&logo=tmux)
![Theme](https://img.shields.io/badge/Theme-Catppuccin-purple?style=for-the-badge&logo=catppuccin)

## ✨ Features

*   **Terminal**: [Ghostty](https://github.com/ghostty-org/ghostty) with Catppuccin Macchiato theme & blur effect.
*   **Shell**: Zsh + Powerlevel10k (Instant Prompt) + Fzf-tab + Autosuggestions.
*   **Editor**:
    *   **Neovim**: [LazyVim](https://www.lazyvim.org/) based configuration.
    *   **IdeaVim**: Zen mode with EasyMotion & VSCode-like keybindings.
*   **Multiplexer**: Tmux with [Oh My Tmux](https://github.com/gpakosz/.tmux), Vim-navigation integration.
*   **Version Manager**: [Mise](https://mise.jdx.dev/) (RTX) for managing Node, Python, Go, etc.
*   **Modern Unix Tools**: `eza`, `bat`, `rg`, `fd`, `delta`, `zoxide`.

## 🚀 Installation

One-liner to set up everything on a new machine:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply luxvibe
```

## 🎹 Cheatsheet

### Zsh (Shell)
*   `z <dir>`: Smart jump to directory
*   `...`: Go up 2 levels
*   `fk`: Fix previous command
*   `lg`: Open Lazygit
*   `brew-dump` / `brew-install`: Manage packages

### Tmux
*   **Prefix**: `Ctrl + b`
*   `Prefix + |` / `-`: Split window vertical / horizontal
*   `Ctrl + h/j/k/l`: Navigate between Tmux panes & Vim splits
*   `Prefix + r`: Reload config
*   `Prefix + I`: Install plugins

### IdeaVim / Neovim
*   **Leader**: `Space`
*   `<Space> s <char>`: EasyMotion jump
*   `<Space> e`: Toggle file explorer (focus current file)
*   `<Space> g g`: Git actions
*   `<Space> r n`: Rename
*   `Ctrl + h/j/k/l`: Navigate windows

## 📂 Structure

```text
~/.config/
├── ghostty/        # Terminal config
├── nvim/           # LazyVim config
├── tmux/           # Tmux config
├── zsh/            # Zsh modules (aliases, plugins)
├── fzf/            # Fzf theming
├── bat/            # Bat config
└── mise/           # Tool versions
```

## 🎨 Theme

Everything is unified with **Catppuccin Macchiato**.

*   **Ghostty**: Macchiato
*   **Tmux**: Macchiato
*   **Neovim**: Macchiato (Transparent)
*   **Bat/Fzf**: Dracula/Macchiato
