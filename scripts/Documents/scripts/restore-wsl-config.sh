#!/bin/sh

BACKUP_DIR="/mnt/wsl/backup"

echo "Start restore from $HOME to $BACKUP_DIR"
cd "$BACKUP_DIR" || exit 1
rsync --archive --update --recursive --progress \
  .additional_zsh_config .aws .gitconfig .kube .ssh .zsh_history "$HOME"

echo "Restoring you wsl config is done!"
