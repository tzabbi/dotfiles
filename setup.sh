#!/bin/bash

set -e

# determine linux distro
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    OS=$(uname -s)
fi

BREW_PATH="/home/linuxbrew/.linuxbrew/bin/brew"
DOTFILES_DIR=$(cd -- "$(dirname -- "$0")" && pwd)

echo "🚀 Start setup for: $OS"

echo "📦 Install system dependencies..."
case "$OS" in
    ubuntu|debian)
        sudo apt update && sudo apt install -y build-essential stow git
        ;;
    fedora)
        sudo dnf group install development-tools && sudo dnf install -y stow git curl
        ;;
esac

# install homebrew if not installed
if [[ ! -f "$BREW_PATH" ]]; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    eval "$($BREW_PATH shellenv bash)"
    brew analytics off
    brew install gcc
else
    eval "$($BREW_PATH shellenv)"
fi

if [ -f "$DOTFILES_DIR/brew/Brewfile" ]; then
    brew bundle --file "$DOTFILES_DIR/brew/Brewfile"
fi

if [[ ! -d $HOME/.tmux/plugins/tpm ]]; then
  echo "🪟 Installing tmux plugin manager..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

if [ -f "$HOME/.gitconfig" ] && ! grep -q ".dotfiles_gitconfig" "$HOME/.gitconfig"; then
    echo "📝 add .gitconfig..."
    git config --global include.path "../.dotfiles_gitconfig"
fi

cd "$DOTFILES_DIR" | exit

echo "🔗 Createting Symlinks with GNU Stow..."
[ -f "$HOME/.bashrc" ] && [ ! -L "$HOME/.bashrc" ] && rm "$HOME/.bashrc"
[ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ] && rm -rf "$HOME/.config/nvim"

for dir in */; do
    dir=${dir%/}
    if [[ "$dir" != "freecad" && "$dir" != "brew" && "$dir" != ".git" ]]; then
        echo "   Stowing $dir"
        stow "$dir"
    fi
done

FREECAD_TARGET="$HOME/.var/app/org.freecad.FreeCAD/config/FreeCAD/user.cfg"
FREECAD_SOURCE="$DOTFILES_DIR/freecad/.var/app/org.freecadweb.FreeCAD/config/FreeCAD/user.cfg"

if [ -f "$FREECAD_SOURCE" ]; then
    mkdir -p "$(dirname "$FREECAD_TARGET")"
    ln -sf "$FREECAD_SOURCE" "$FREECAD_TARGET"
fi

if [[ "$GIT_BIN" == "/home/linuxbrew/.linuxbrew/bin/git" ]]; then
  echo "🧹 removing sytem git since we are using brew installed git ..."
  if [[ "$OS" == "debian" || "$OS" == "ubuntu" ]]; then
    sudo apt remove -y git
    sudo apt autoremove -y
  elif [[ "$OS" == "fedora" ]]; then
    sudo dnf remove git
  fi
fi

# set zsh as default shell
ZSH_PATH=$(command -v zsh)
if [ "$SHELL" != "$ZSH_PATH" ]; then
    echo "🐚 change default shell to zsh..."
    if ! grep -q "$ZSH_PATH" /etc/shells; then
        sudo bash -c "echo $ZSH_PATH >> /etc/shells"
    fi
    chsh -s "$ZSH_PATH"
fi

echo "✅ Setup finished!"
