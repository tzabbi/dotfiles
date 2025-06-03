#!/bin/bash

GITHUB_PATH="$HOME/Documents/github"

if ! command -v zig >/dev/null; then
  if [[ "$(grep "^ID=" /etc/os-release | cut -d "=" -f 2)" == "fedora" ]]; then
    echo "Installing zig and dependencies to install ghostty..."
    sudo dnf install gtk4-devel zig libadwaita-devel blueprint-compiler
  else
    echo "Only Fedora is supported!"
  fi
fi

if [[ ! -d "$GITHUB_PATH/ghostty" ]]; then
  echo "Cloning ghostty repo..."
  mkdir -p "$GITHUB_PATH" && cd "$GITHUB_PATH" || exit 1
  git clone https://github.com/ghostty-org/ghostty
fi

cd "$GITHUB_PATH/ghostty" || exit 1
git pull >/dev/null

if [[ ! "$(ghostty --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)" == "$(git describe --tags "$(git rev-list --tags --max-count=1)" | sed 's/^v//')" ]]; then
  echo "Installing/updating ghostty..."
  git switch --detach "$(git describe --tags "$(git rev-list --tags --max-count=1)")"
  sudo zig build -p /usr -Doptimize=ReleaseFast
  echo "Ghostty is now installed in version: $(git describe --tags "$(git rev-list --tags --max-count=1)")"
else
  echo "The newest version of Ghostty ($(ghostty --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n1)) is already installed!"
fi

git switch main >/dev/null 2>&1
