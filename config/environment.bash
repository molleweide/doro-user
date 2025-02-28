#!/usr/bin/env bash
# shellcheck disable=SC2034
# place all `export` keyword declarations at the start for bash v3 compatibility
export NVM_DIR HOMEBREW_ARCH BROWSER PAGER TERMINAL TZ LANG LANGUAGE LC_ALL PYTHON_CONFIGURE_OPTS PYTHON_CONFIGURE_OPTS PYENV_VIRTUALENV_DISABLE_PROMPT XDG_CONFIG_HOME XDG_CACHE_HOME XDG_DATA_HOME XDG_STATE_HOME XDG_DATA_DIRS XDG_CONFIG_DIRS XDG_DESKTOP_DIR XDG_DOCUMENTS_DIR XDG_DOWNLOAD_DIR XDG_MUSIC_DIR XDG_PICTURES_DIR XDG_VIDEOS_DIR ADOTDIR ALSA_CONFIG_PATH ANDROID_SDK_HOME ANSIBLE_CONFIG ANTIGEN_COMPDUMP ANTIGEN_DEBUG_LOG ANTIGEN_LOG ANTIGEN_BUNDLES CABAL_CONFIG CABAL_DIR CARGO_HOME RUSTUP_HOME ELECTRUMDIR GEM_HOME GEM_SPEC_CACHE GNUPGHOME GOPATH GTK2_RC_FILES INPUTRC IRBRC KODI_DATA MBSYNCRC NOTMUCH_CONFIG NPM_CONFIG_USERCONFIG NVM_DIR OCTAVE_HISTFILE PASSWORD_STORE_DIR PYENV_ROOT STACK_ROOT TMUX_TMPDIR TMUX_PLUGIN_MANAGER_PATH UNISON WEECHAT_HOME WGETRC WINEPREFIX XAUTHORITY XINITRC ZDOTDIR HISTFILE LESSHISTFILE HISTFILE LOCATE_PATH PHONE_NUMBER GPG_TTY GHCUP_USE_XDG_DIRS STACK_XDG CPATH SDKROOT VIRTUAL_ENV_DISABLE_PROMPT
export GHQ_ROOT GHQ_GITHUB
export PATH

export ZSH ZSH_CACHE_DIR

export REAPER_DIR REAPER_APP_DIR REAPER_PACKAGES_DIR REAPER_PROJECTS_DIR REAPER_TMP_DIR REAPER_BACKUP_DIR REAPER_SAMPLES_DIR
export LOCATE_PATH
export DISABLE_AUTO_TITLE
export TERM

# Add Dorothy Command Aliases (DCA) to path
path='' alias_dirs=()
mapfile -t alias_dirs < <(find "$DOROTHY/user/commands.aliases" -type d)
for p in "${alias_dirs[@]}"; do
  echo "Add [$p] to path">/dev/tty
	path+="$p:"
done
PATH="$path$PATH"

# DCA_DIR="$DOROTHY/user/commands.aliases"
# PATH+=":$DCA_DIR"
# for d in "$DCA_DIR"/*/; do
# 	echo "Add [$d] to path" >/dev/tty
# 	PATH+=":$d"
# done

# DOROTHY_THEME="starship"
VIRTUAL_ENV_DISABLE_PROMPT=1

GHQ_ROOT="$HOME/code/repos"
GHQ_GITHUB="$GHQ_ROOT/github.com"

# add bob-nvim to path
# NOTE: What is this????????
# if test -d "$XDG_DATA_HOME/neovim/bin"; then
#   PATH="$XDG_DATA_HOME/neovim/bin:$PATH"
# fi

# NVM_DIR="$HOME/.nvm"

# choose your architecture for apple silicon
# HOMEBREW_ARCH='x86_64' # 'arm64e'

BROWSER="brave"
TERMINAL="Alacritty" # or kitty | linux >> "st"

# timezone
TZ="America/New_York"
LANG="en_US.UTF-8"
LANGUAGE="en"
LC_ALL="en_US.UTF-8"

# https://github.com/HaleTom/dotfiles/blob/master/bash/.config/bash/xdg

# mac
if is-mac; then
	XDG_DESKTOP_DIR="$HOME/Desktop"
	XDG_DOCUMENTS_DIR="$HOME/Documents"
	XDG_DOWNLOAD_DIR="$HOME/Downloads"
	XDG_MUSIC_DIR="$HOME/Music"
	XDG_PICTURES_DIR="$HOME/Pictures"
	XDG_VIDEOS_DIR="$HOME/Videos"
fi

# TMUX_TMPDIR="$XDG_RUNTIME_DIR"
# XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority" # This line will break some DMs.
ADOTDIR="$XDG_DATA_HOME/antigen"
ALSA_CONFIG_PATH="$XDG_CONFIG_HOME/alsa/asoundrc"
ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"
ANSIBLE_CONFIG="$XDG_CONFIG_HOME/ansible/ansible.cfg"
ANTIGEN_BUNDLES="${ADOTDIR}/bundles"
ANTIGEN_COMPDUMP="${ADOTDIR}/.zcompdump"
ANTIGEN_DEBUG_LOG="${ADOTDIR}/antigen_debug.log"
ANTIGEN_LOG="${ADOTDIR}/antigen.log"
CABAL_CONFIG="$XDG_CONFIG_HOME/cabal/config"
CABAL_DIR="$XDG_CACHE_HOME/cabal"
CARGO_HOME="$XDG_DATA_HOME/cargo"
ELECTRUMDIR="$XDG_DATA_HOME/electrum"
GEM_HOME="$XDG_DATA_HOME/gem"
GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"
GNUPGHOME="$XDG_DATA_HOME/gnupg"
GOPATH="$XDG_DATA_HOME/go"
GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
IRBRC="$XDG_CONFIG_HOME/irb/irbrc"
KODI_DATA="$XDG_DATA_HOME/kodi"
MBSYNCRC="$XDG_CONFIG_HOME/mbsync/config"
NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch-config"
NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
NVM_DIR="$XDG_DATA_HOME/nvm"
OCTAVE_HISTFILE="$XDG_CACHE_HOME/octave-hsts"
PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
PYENV_ROOT="$XDG_DATA_HOME/pyenv"
RUSTUP_HOME="$XDG_DATA_HOME/rustup"

# STACK_ROOT="$XDG_DATA_HOME/stack" # legacy method
STACK_XDG=1 # force stack to use XDG

TMUX_PLUGIN_MANAGER_PATH="$XDG_CONFIG_HOME/tmux/plugins"
UNISON="$XDG_DATA_HOME/unison"
WEECHAT_HOME="$XDG_CONFIG_HOME/weechat"
WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
XINITRC="$XDG_CONFIG_HOME/x11/xinitrc"
# ZDOTDIR="$XDG_CONFIG_HOME/zsh"

GHCUP_USE_XDG_DIRS=true # force XDG

HISTFILE="$XDG_DATA_HOME/history"
LESSHISTFILE="-"
if test "$shell" = 'zsh'; then
	HISTFILE="$XDG_STATE_HOME/zsh/history"
	mkdir -p "$XDG_STATE_HOME/zsh"
	touch "$HISTFILE"
fi

# Why do I check the path?
[[ -f "$HOME/locatedb" ]] && LOCATE_PATH="$HOME/locatedb"

# =======================================================
# RUBY
PATH="$HOME/.rvm/bin:$PATH"

# =======================================================
# OH MY ZSH
# https://github.com/ohmyzsh/ohmyzsh/wiki/Settings
ZSH="$XDG_DATA_HOME/oh-my-zsh"
ZSH_CACHE_DIR="$XDG_CACHE_HOME/oh-my-zsh"
DISABLE_AUTO_TITLE="true" # apparently this is a thing pertaining to ohmyzsh

# =======================================================
# PYTHON
# is-mac && export PYTHON_CONFIGURE_OPTS="--enable-framework"
# is-linux && export PYTHON_CONFIGURE_OPTS="--enable-shared"
# is-mac && PYTHON_CONFIGURE_OPTS="--enable-framework"
# is-linux && PYTHON_CONFIGURE_OPTS="--enable-shared"
# PYENV_VIRTUALENV_DISABLE_PROMPT=1
# echo_and_eval_var_set PATH "$PYENV_ROOT/bin:$PATH"
# export PYENV_VIRTUALENV_DISABLE_PROMPT=1
# export PATH="$PYENV_ROOT/bin:$PATH"

# personal TODO: move to config.local
PHONE_NUMBER="+46702281490"

# CC=$(which gcc-12)

# treesitter fixes
export CPATH="${CPATH:-}:/Library/Developer/CommandLineTools/usr/include/c++/v1/:/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/"
export SDKROOT=$(xcrun --show-sdk-path --sdk macosx)

# shell settings
# what is this??
export SHELL_SESSIONS_DISABLE=1

# terminal settings
TERM=xterm-256color

# REAPER
REAPER_DIR="$HOME/reaper"
REAPER_APP_DIR="$REAPER_DIR/app"
REAPER_PACKAGES_DIR="$REAPER_DIR/packages"
REAPER_PROJECTS_DIR="$REAPER_DIR/projects"
REAPER_TMP_DIR="$REAPER_DIR/tmp"
REAPER_BACKUP_DIR="$REAPER_DIR/backup"
REAPER_SAMPLES_DIR="$REAPER_DIR/samples"

# =======================================================
# PAGER

PAGER='less' # alt. `most`
# # Set the default Less options.
# # Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# # Remove -X to enable it.
# export LESS='-g -i -M -R -S -w -X -z-4'

# # Set the Less input preprocessor.
# # Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
# if (( $#commands[(i)lesspipe(|.sh)] )); then
#   export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
# fi
