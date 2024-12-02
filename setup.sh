#!/bin/sh


if [ ! -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
  echo "Installing and configuring brew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo >> $HOME/.bashrc
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.bashrc
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  if [ $(grep "^ID=" /etc/os-release | cut -d "=" -f 2) == "ubuntu" ]; then
    sudo apt-get install build-essential
    brew install gcc
    brew bundle --file ./brew/Brewfile.work
  fi
  if [ $(grep "^ID=" /etc/os-release | cut -d "=" -f 2) == "fedora" ]; then
    sudo dnf group install development-tools
    brew install gcc
    brew bundle --file ./brew/Brewfile.private
  fi
fi

if [ ! -d $HOME/.tmux/plugins/tpm ]; then
  echo "Installing tmux plugin manager..."
  git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
fi

scriptdirectory=$(cd -- "$(dirname -- "$0")" && pwd)
cd "$scriptdirectory"

echo "Removing .bashrc"
rm $HOME/.bashrc

for dir in */; do
  echo "Creating link for  $dir ..."
  stow "$(basename "$dir")"
done
