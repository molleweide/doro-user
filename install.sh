#!/usr/bin/env bash

source "${BASH_SOURCE%/*}/installers/shared.sh"

require_installer homebrew
require_installer git
require_installer devtools
require_installer zsh
require_installer python
require_installer ruby
require_installer tmux
require_installer fonts
require_installer neovim

echo "Installing nvim plugins"
nvim +PlugInstall
