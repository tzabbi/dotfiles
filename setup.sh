#!/bin/bash

# if [[ ! command -v curl >/dev/null 2>&1 && ("$(grep "^ID=" /etc/os-release | cut -d "=" -f 2)" == "debian" || "$(grep "^ID=" /etc/os-release | cut -d "=" -f 2)" == "ubuntu") ]]; then
#   echo "installing curl"
#   sudo apt update && sudo apt install -y curl
# fi

# install homebrew if not installed
if [[ ! -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  echo "Installing and configuring brew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo >>"$HOME/.bashrc"
  echo "eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" >>"$HOME/.bashrc"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  brew install gcc
  if [[ "$(grep "^ID=" /etc/os-release | cut -d "=" -f 2)" == "ubuntu" || "$(grep "^ID=" /etc/os-release | cut -d "=" -f 2)" == "debian" ]]; then
    sudo apt-get install -y build-essential stow
  fi
  if [[ "$(grep "^ID=" /etc/os-release | cut -d "=" -f 2)" == "fedora" ]]; then
    sudo dnf group install development-tools stow
  fi
fi

brew bundle --file ./brew/Brewfile

if [[ ! -d $HOME/.tmux/plugins/tpm ]]; then
  echo "Installing tmux plugin manager..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

if ! grep -wq "path = ./.dotfiles_gitconfig" "$HOME/.gitconfig"; then
  printf "[include]\n    path = ./.dotfiles_gitconfig" >>"$HOME/.gitconfig"
fi

scriptdirectory=$(cd -- "$(dirname -- "$0")" && pwd)
cd "$scriptdirectory" || exit

echo "Removing .bashrc"
rm "$HOME/.bashrc"

echo "Removing nvim config"
rm "$HOME/.config/nvim"

for dir in */; do
  if [[ "$dir" != "freecad/" ]]; then
    echo "Creating link for  $dir ..."
    stow "$(basename "$dir")"
  fi
done

ln -s ~/dotfiles/freecad/.var/app/org.freecadweb.FreeCAD/config/FreeCAD/user.cfg ~/.var/app/org.freecad.FreeCAD/config/FreeCAD/user.cfg

if [[ "$(which curl)" == "/home/linuxbrew/.linuxbrew/bin/curl" && "$(which git)" == "/home/linuxbrew/.linuxbrew/bin/git" && ("$(grep "^ID=" /etc/os-release | cut -d "=" -f 2)" == "debian" || "$(grep "^ID=" /etc/os-release | cut -d "=" -f 2)" == "ubuntu") ]]; then
  echo "Uninstalling curl and git..."
  sudo sudo apt remove -y curl git
fi

# set zsh as default shell
if [[ "$SHELL" != "*zsh" ]]; then
  if ! grep -q "/home/linuxbrew/.linuxbrew/bin/zsh" /etc/shells; then
    sudo bash -c 'echo "/home/linuxbrew/.linuxbrew/bin/zsh" >> /etc/shells'
    chsh -s "$(which zsh)"
  fi
fi

# install markdown formatter plugins
# pip3 install mdformat-tables mdformat_frontmatter

# install optional neovim provider
# Python provider for neovim is required for plugins written in python
# pip3 install neovim

# Node.js provider for neovim is required for plugins written in JavaScript/TypeScript
# npm install -g neovim

# Ruby provider for neovim is required for plugins written in Ruby
# gem install neovim
