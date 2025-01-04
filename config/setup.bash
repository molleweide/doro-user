#!/usr/bin/env bash
# shellcheck disable=SC2034
# do not use `export` keyword in this file

source "$DOROTHY/config/setup.bash"

# NOTE: Cool projects:
# https://github.com/Slackadays/Clipboard

APK_INSTALL=(
  'tree'
)

# APT_REMOVE=(
# 	aisleriot
# 	gnome-mahjongg
# 	gnome-mines
# 	gnome-sudoku
# 	gnomine
# 	imagemagick
# 	"libreoffice*"
# 	rhythmbox
# 	shotwell
# 	thunderbird
# )

# https://code.visualstudio.com/docs/setup/linux
# if [[ "$(get-arch)" == 'x'* ]]; then
# 'code --classic'
# deno
SNAP_INSTALL=(
)

GO_INSTALL=(
  'changkun.de/x/rmtrash'
  'github.com/gennaro-tedesco/boilit'
)

# fzf
# gnuplot
# libxml2
# libzip
# lua
# luarocks
# ncurses
# neofetch
# zsh-completions
HOMEBREW_FORMULAS=(
  ack
  asdf
  blueutil
  cabal-install
  calcurse
  cmacrae/formulae/spacebar
  code-minimap
  cointop
  dbus
  diff-so-fancy
  direnv
  fasd
  fff
  figlet
  findutils
  fswatch
  gcc
  ghc
  git-extras
  gnu-tar
  gnuplot
  gpg-tui
  heroku/brew/heroku
  himalaya
  hub
  imagemagick
  irssi
  isync
  koekeishiya/formulae/skhd
  koekeishiya/formulae/yabai
  lazygit
  lf
  libxml2
  libzip
  lua
  luarocks
  mongocli
  most
  mps-youtube
  msmtp
  ncurses
  neofetch
  neomutt
  ninja
  nnn
  pandoc
  pass
  pass-otp
  paul-nameless/repo/tg
  pinentry-mac
  podman
  postgresql
  ranger
  readline
  reattach-to-user-namespace
  redis
  sc-im
  signal-cli
  sl
  sox
  spotify-tui
  stripe/stripe-cli/stripe
  subversion
  terminal-notifier
  the_silver_searcher
  tmux
  universal-ctags
  urlview
  watchman
  wp-cli
  zstd
)
HOMEBREW_SLOW_FORMULAS=(
  gpg
  shellcheck
)

# 1password-cli
# acorn
# adguard
# airparrot
# appzapper
# atom
# audio-hijack
# backblaze
# bartender
# burn
# caption
# ccleaner
# contexts
# dat
# devdocs
# fantastical
# 'google-cloud-sdk'
# firefox
# freedom
# geekbench
# github-desktop
# gitter
# google-chrome
# google-hangouts
# jaikoz
# java
# julia
# keybase
# kodi
# little-snitch
# loopback
# micro-snitch
# numi
# opera
# paragon-ntfs
# plex-media-server
# pomello
# reflector
# screenflow
#   'logseq'
# chromedriver
# sketch
# skype
# soundsource
# undercover
# usage
# 'notion'
# visual-studio-code
# vlc
# vmware-fusion
# webtorrent
# windscribe
# workflowy
# xld
# calibre
# 	'dmenu-mac'
#
# 'mullvadvpn'
#   'autodesk-fusion360'
#     'appflowy'
HOMEBREW_CASKS=(
  'wezterm'
  'ghostty'
  'aerial'
  'alinoftimer'
  'breaktimer'
  'discord'
  'element'
  'gimp'
  'kitty'
  'licecap'
  'loopback'
  'michaelvillar-timer'
  'minitimer'
  'mpv'
  'native-access'
  'obsidian'
  'qtpass'
  'qutebrowser'
  'spotify'
  'supercollider'
  'thefuck'
  'timer'
  'ubersicht'
  'utm'
  'xquartz'
)

# TODO: remove unused ruby packages

# 'git-up' # This is an objective-C proj, dunno why it was located under GEM?
# I also believe that I have stopped using `sass` completely..
GEM_INSTALL=(
  'awesome_print'
  'bundler'
  'cani'
  'compass'
  'ffi'
  'hirb'
  'pry'
  'sass'
  'twurl'
  'yard'
  'zeus'
)

# pip
# @todo swap PyPDF2 fro one of the following
# > https://stackoverflow.com/a/63557138/130638
# - https://github.com/pymupdf/PyMuPDF
# - https://github.com/pikepdf/pikepdf
# - https://github.com/pdfminer/pdfminer.six
PIPX_INSTALL=(
  'git+https://github.com/boppreh/mouse.git'
  'pyobjc-framework-Quartz'
  'openbb'
)

# 'diff-so-fancy'
NPM_INSTALL=(
  'bash-language-server'
  'eslint'
  'gulp-cli'
  'json'
  'tern'
  'typescript'
  'vim-node-rpc'
	'@bevry/testen'
	'@bevry/github-api'
	'boundation'
	'serve'
	'eslint'
	'json'
	'typescript'
)

# rust/cargo/crates.io
# --locked: Require Cargo.lock is up to date
# as rust packages can be supported by many package managers, and as cargo requires downloading every dependency, most rust packages are better installed via SETUP_UTILS
CARGO_INSTALL=(
  # cargo install --git https://github.com/boxdot/gurk-rs
  proximity-sort
  ttyper
  ast-grep
  stylua
  bob-nvim
)

SETUP_UTILS=(
  1password
  alacritty
  aria2
  bandwhich
  bash
  bat
  bottom
  brave
  curl
  delta
  deno
  devel
  docker
  dust
  eza
  fd
  fish
  fzf
  gh
  ghcup
  git
  glab
  gocryptfs
  grex
  hammerspoon
  httpie
  hyperfine
  jq
  mas
  micro
  neovim
  obs
  prettier
  procs
  ps
  ripgrep
  rmesg
  screen
  sd
  shellcheck
  signal
  strongbox
  syncthing
  tealdeer
  tokei
  tree
  unziptar
  vim
  vscode
  wget
  zoxide
)

# heroku plugins:install heroku-repo

# 937984704      # "Amphetamine"
# 425264550      # "Blackmagic Disk Speed Test"
# 948176063      # "Boom 2"
# 696977615      # "Capo 3"
# 975937182      # "Fantastical 2"
# 682658836      # "GarageBand"
# 634148309      # "Logic Pro X"
# 1084713122     # "Markoff"
# 967805235      # "Paste 2"
# 407963104      # "Pixelmator"
# 803453959      # "Slack"
# 402592703      # "Timeout"
# 425424353      # "The Unarchiver"
MAS_INSTALL=(
)

# LUA_ROCKS_INSTALL=(
# loop
# dkjson
# inspect
# --server=http://luarocks.org/dev lua-lsp
# luacheck
# lcf
# )

STACK_INSTALL=(
  "yesod-bin --install-ghc"
)
HOMEBREW_ENCODING_INSTALL=no
HOMEBREW_FONTS=(
  'font-cantarell'
  'font-cascadia-code'
  'font-fira-code'
  'font-fira-code-nerd-font'
  'font-fira-mono'
  'font-fira-mono-nerd-font'
  'font-hack' # many editors require this
  'font-hasklig'
  'font-ibm-plex' # many editors require this
  'font-inconsolata-go-nerd-font'
  'font-inter' # many apps require this
  'font-jetbrains-mono'
  'font-jetbrains-mono-nerd-font'
  'font-lato'
  'font-maven-pro'
  'font-monoid'
  'font-montserrat'
  'font-open-sans'
  'font-oxygen'
  'font-oxygen-mono'
  'font-roboto'
  'font-roboto-mono'
  'font-source-code-pro' # many editors require this
  'font-ubuntu'
  'font-meslo-lg-nerd-font'
)
GO_LINTING_INSTALL='no'
APT_INSTALL=(
  # 'alacritty'
  'atomicparsley'
  'btrfs-progs'
  'gnome-keyring'
  'kitty'
  'libnotify-bin'
  'ranger'
  'tmux'
  'traceroute'
)

# HASKEL_INSTALL=(
#   'yesod-bin'
# )
