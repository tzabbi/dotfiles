#!/bin/sh
dotfiles=( "bashrc" "tmux")

for tool in "${dotfiles[@]}"; do
    echo "Create Symlink for $tool"
    stow $tool
done

