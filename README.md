# Welcome to my dotfiles

Note that there are some initial steps you'll need to clone my entire config.

## Prerequisites

- Git
- stow

## Usage

1. Clone this repository in our home directory.
1. Change dir to the root directory of this repos.
1. Run `./setup.sh`.

## Brew

1. [Install brew][brew].
1. Go into `~/.brew` subdirectory.
1. Run `brew bundle`.

## Tmux

1. [Install tpm][tpm].
1. Add plugins to `~/.tmux.conf`.
1. Run tmux (or reload tmux env `tmux source ~/.tmux.conf`).
1. Install plugins with `prefix + I` (capital i).

[tpm]: https://github.com/tmux-plugins/tpm?tab=readme-ov-file#installation
[brew]: https://brew.sh/
