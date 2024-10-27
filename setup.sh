#!/bin/sh

if [ ! -d $HOME/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
fi

scriptdirectory=$(cd -- "$(dirname -- "$0")" && pwd)
cd "$scriptdirectory"


for dir in */; do
    stow "$(basename "$dir")"
done
