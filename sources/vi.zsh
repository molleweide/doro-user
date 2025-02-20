#
# ==================================================================
# configure VI bindings for ZSh
# ==================================================================
#
# Vim style ^W del word backwards
autoload -U select-word-style
select-word-style bash
export WORDCHARS='.-'

# custom cursor
# function zle-keymap-select () {
#     case $KEYMAP in
#         vicmd) echo -ne '\e[1 q';;      # block
#         viins|main) echo -ne '\e[5 q';; # beam
#     esac
# }
# zle -N zle-keymap-select
# zle-line-init() {
#     zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
#     echo -ne "\e[5 q"
# }
# zle -N zle-line-init
# echo -ne '\e[5 q' # Use beam shape cursor on startup.
# preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use jk to exit insert mode on the command line
bindkey -M viins 'zx' vi-cmd-mode

# Vim style ^W del word backwards
autoload -U select-word-style
select-word-style bash
export WORDCHARS='.-'

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
