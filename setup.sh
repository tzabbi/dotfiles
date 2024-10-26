#!/bin/sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

scriptdirectory=$(cd -- "$(dirname -- "$0")" && pwd)
cd "$scriptdirectory"


for dir in */; do
    stow "$(basename "$dir")"
done
