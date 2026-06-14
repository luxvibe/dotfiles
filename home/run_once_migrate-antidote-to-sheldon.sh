#!/usr/bin/env bash
# 迁移：删除 antidote 运行时生成的静态文件（已切换到 sheldon）
ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
rm -f "$ZDOTDIR/.zsh_plugins.zsh" "$ZDOTDIR/.zsh_plugins"
