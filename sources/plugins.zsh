# PURE_PROMPT_SYMBOL="%%"

# NOTE: rename this file to zsh-plugins, because it deals with adding
# plugins to the zsh.
#
# TODO: https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
# |------
# | - ( ) check out nice plugins
# | - ( ) copy git plugin and try migrating.

# FIX: Many of these things should be made compatible with multiple shells
# so that I can use all of th aliases from any shell.
# https://superuser.com/questions/826333/is-there-a-way-to-source-a-sh-script-from-the-fish-shell
# >>> create subdir where i migrate aliases to commands so that they become
# available in any shell.

# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins
# https://travis.media/top-10-oh-my-zsh-plugins-for-productive-developers/

# if test -f "$ADOTDIR/antigen.zsh"; then

# NOTE: What is the .zwc extensio
# https://unix.stackexchange.com/questions/454126/automatically-use-zwc-version-of-a-sourced-file
# […] If a file named ‘file.zwc’ is found, is newer than file, and is the
# compiled form (created with the zcompile builtin) of file, then commands are
# read from that file instead of file.

# echo "user -> sources/ >> load antigen"

# echo "zsh cache before antigen: $ZSH_CACHE_DIR"

# TODO: put together some functions to make life easier
#
# TODO: Maybe migrate to new plugin manager:
# Antidote is the successor to antigen. It should be much fastern
# https://github.com/mattmc3/antidote
# ...
# Or even just pull all of the oh-my-zsh plugins into my own dotfiles??

source "$ADOTDIR/antigen.zsh"

# # remove bundle with: antigen purge <bundle>
# ANTIGEN_PLUGINS=(
# git
# nvm
# pyenv
# rvm
# vi-mode
# dbalatero/fzf-git
# DarrinTisdale/zsh-aliases-exa
# chriskempson/base16-shell
# wookayin/fzf-fasd
# # rupa/z z.sh
# twang817/zsh-ssh-agent
# zsh-users/zsh-completions
# zdharma/fast-syntax-highlighting
# hlissner/zsh-autopair
# )
#
# function antigen_install() {
#   for f in "${ANTIGEN_PLUGINS[@]}"; do
#     antigen bundle "$f"
#   done
#   antigen apply
# }

# antigen cleanup

# omz_plugins=(git nvm pyenv rvm vi-mode)
# for p in "${omz_plugins[@]}"; do
#   echo "purge plugin: $p"
#   antigen purge "$p" --force
# done

# antigen purge robbyrussell/oh-my-zsh --force
# antigen reset

# echo "zsh cache before bundle OMZ: $ZSH_CACHE_DIR"

# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
# source code: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/git/git.plugin.zsh
# patch alias to list all aliases.
antigen bundle git

antigen bundle nvm
antigen bundle pyenv
antigen bundle rvm
# antigen bundle vi-mode
# echo "zsh cache after bundle OMZ: $ZSH_CACHE_DIR"

# NOTE: replace with https://github.com/Aloxaf/fzf-tab
# antigen bundle dbalatero/fzf-git
antigen bundle Aloxaf/fzf-tab

# THIS IS SPECIFICALLY A ZSH PLUGIN
# https://github.com/DarrinTisdale/zsh-aliases-exa
antigen bundle DarrinTisdale/zsh-aliases-exa

# I HAVE NO IDEA WHAT THIS DOES..
# antigen bundle chriskempson/base16-shell

antigen bundle wookayin/fzf-fasd

# antigen bundle rupa/z z.sh

antigen bundle twang817/zsh-ssh-agent

antigen bundle zsh-users/zsh-completions

# antigen bundle zdharma/fast-syntax-highlighting

antigen bundle hlissner/zsh-autopair

# echo "zsh cache before antigen apply: $ZSH_CACHE_DIR"
antigen apply
# echo "zsh cache after antigen apply: $ZSH_CACHE_DIR"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(direnv hook zsh)"
eval "$(fasd --init auto)"

# echo "zsh cache after antigen: $ZSH_CACHE_DIR"
# fi
