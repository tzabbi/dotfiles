#!/bin/bash

if [[ ! command -v curl >/dev/null 2>&1 && ("$(grep "^ID=" /etc/os-release | cut -d "=" -f 2)" == "debian" || "$(grep "^ID=" /etc/os-release | cut -d "=" -f 2)" == "ubuntu") ]]; then
  echo "installing curl"
  sudo apt update && sudo apt install -y curl
fi

# install homebrew if not installed
if [[ ! -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  echo "Installing and configuring brew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo >> "$HOME/.bashrc"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.bashrc"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  brew install gcc
  if [[ "$(grep "^ID=" /etc/os-release | cut -d "=" -f 2)" == "ubuntu" ]]; then
    sudo apt-get install build-essential
  fi
  if [[ "$(grep "^ID=" /etc/os-release | cut -d "=" -f 2)" == "fedora" ]]; then
    sudo dnf group install development-tools
  fi
fi

# install required brew packages based on used linux distro
if [[ "$(grep "^ID=" /etc/os-release | cut -d "=" -f 2)" == "ubuntu" ]]; then
  brew bundle --file ./brew/Brewfile.work
fi

if [[ "$(grep "^ID=" /etc/os-release | cut -d "=" -f 2)" == "fedora" ]]; then
  brew bundle --file ./brew/Brewfile.private
fi

if [[ ! -d $HOME/.tmux/plugins/tpm ]]; then
  echo "Installing tmux plugin manager..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

if [[ ! "$(grep -wq "path = ./.dotfiles_gitconfig" $HOME/.gitconfig)" ]]; then
  printf "[include]\n    path = ./.dotfiles_gitconfig" >> "$HOME/.gitconfig"
fi

scriptdirectory=$(cd -- "$(dirname -- "$0")" && pwd)
cd "$scriptdirectory" || exit

echo "Removing .bashrc"
rm $HOME/.bashrc

for dir in */; do
  echo "Creating link for  $dir ..."
  stow "$(basename "$dir")"
done
