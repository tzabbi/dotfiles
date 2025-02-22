#!/bin/bash

# if [[ ! "$(command -v curl > /dev/null)" 2>&1 && ("$(grep "^ID=" /etc/os-release | cut -d "=" -f 2)" == "debian" || "$(grep "^ID=" /etc/os-release | cut -d "=" -f 2)" == "ubuntu") ]]; then
#   echo "installing curl"
#   sudo apt update && sudo apt install -y curl
# fi

# install homebrew if not installed
if [[ ! -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  echo "Installing and configuring brew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo >>"$HOME/.bashrc"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>"$HOME/.bashrc"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  brew install gcc
  if [[ "$(grep "^ID=" /etc/os-release | cut -d "=" -f 2)" == "ubuntu" || "$(grep "^ID=" /etc/os-release | cut -d "=" -f 2)" == "debian" ]]; then
    sudo apt-get install -y build-essential stow
  fi
  if [[ "$(grep "^ID=" /etc/os-release | cut -d "=" -f 2)" == "fedora" ]]; then
    sudo dnf group install development-tools
    sudo dnf install stow
  fi
fi

# install required brew packages based on used linux distro
if [[ "$(grep "^ID=" /etc/os-release | cut -d "=" -f 2)" == "ubuntu" || "$(grep "^ID=" /etc/os-release | cut -d "=" -f 2)" == "debian" ]]; then
  brew bundle --file ./brew/Brewfile.work
fi

if [[ "$(grep "^ID=" /etc/os-release | cut -d "=" -f 2)" == "fedora" ]]; then
  brew bundle --file ./brew/Brewfile.private
fi

if [[ ! -d $HOME/.tmux/plugins/tpm ]]; then
  echo "Installing tmux plugin manager..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

if ! grep --quiet "path = ./.dotfiles_gitconfig" $HOME/.gitconfig ; then
  printf "[include]\n  path = ./.dotfiles_gitconfig" >> "$HOME/.gitconfig"
fi

scriptdirectory=$(cd -- "$(dirname -- "$0")" && pwd)
cd "$scriptdirectory" || exit

if [ ! -L "$HOME/.bashrc" ]; then
  echo "Removing .bashrc"
  rm "$HOME/.bashrc"
fi

if [ ! -L "$HOME/.config/nvim" ]; then
  echo "Removing nvim config"
  rm -rf "$HOME/.config/nvim"
fi

if [ ! -L "$HOME/.config/ghostty" ]; then
  echo "Removing k9s config"
  rm -rf "$HOME/.config/ghostty"
fi

if [ ! -L "$HOME/.config/k9s" ]; then
  echo "Removing ghostty config"
  rm -rf "$HOME/.config/k9s"
fi

for dir in */; do
  echo "Creating link for  $dir ..."
  stow "$(basename "$dir")"
done

if [[ "$(which curl)" == "/home/linuxbrew/.linuxbrew/bin/curl" && "$(which git)" == "/home/linuxbrew/.linuxbrew/bin/git" && ("$(grep "^ID=" /etc/os-release | cut -d "=" -f 2)" == "debian" || "$(grep "^ID=" /etc/os-release | cut -d "=" -f 2)" == "ubuntu") ]]; then
  echo "Uninstalling curl and git..."
  sudo sudo apt remove -y curl git
fi

# set zsh as default shell
if [[ "$(basename "$SHELL")" != "zsh" ]]; then
  if [[ ! "$(grep -q "/home/linuxbrew/.linuxbrew/bin/zsh" /etc/shells)" ]]; then
    sudo bash -c 'echo "/home/linuxbrew/.linuxbrew/bin/zsh" >> /etc/shells'
    chsh -s "$(which zsh)"
  fi
fi

# Debian: enable ping as normal user
# if [[ ! -x ping ]]; then
# echo jojo
# sudo setcap cap_net_raw+ep /bin/ping
# fi
