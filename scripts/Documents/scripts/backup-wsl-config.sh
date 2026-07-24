#!/bin/sh

BACKUP_DIR="/mnt/wsl/backup"

if [ ! -d $BACKUP_DIR ]; then
  mkdir $BACKUP_DIR
fi

echo "Start Backup from $HOME to $BACKUP_DIR"
cd "$HOME" || exit 1
rsync --archive --update --recursive --progress \
  --exclude=.aws/cli \
  --exclude=.aws/sso \
  --exclude=.kube/cache \
  --exclude=.kube/http-cache \
  .additional_zsh_config .aws .kube .gitconfig .ssh .zsh_history $BACKUP_DIR

echo "Backup done!"
echo "You can now restore the config in the new wsl using the script 'restore-wls-config.sh'"
