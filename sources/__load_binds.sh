# NOTE: REFACTOR STRATEGY:
# - __keybinds.<shell>
# - command called `__keybind_actions.sh` that hosts a users custom bindings logic.
# >>> __keybind_actions should also be moved into a dorothy command

# NOTE: This script loads keybinds that map to fzf git selector FZF_GIT_SELECTOR_ACTIONS (*).

# TODO: It feels like the core also should be moved into a dorothy command so
# that you can use reuse this easilly.

DEBUG_FZF="yes"

__print_lines(){
        printf "%s\n" "$1"
      }

__debug_lines(){
      if (( "$DEBUG_FZF" == "yes" )); then
        __print_lines "[sources/load_binds]: $1"
      fi
}

# NOTE: Should these binds be callable if one is not runnig a git command?
# Eg. should it work to run C-gC-e if the prompt is empty, ie. just triggering
# the fzf helper standalone.

# echo-style --h1="add git fzf support"

# echo "\$0 = $0"
# echo "\$- = $-"
# echo "\$1 = $1"
# echo "\$2 = $2"


# NOTE:
# list all zsh binds with: bindkey -L
# -------
# list of articles on zsh's bindkey:
# https://jdhao.github.io/2019/06/13/zsh_bind_keys/
# https://www.thegeekdiary.com/bindkey-command-examples-add-keybindings-to-z-shell/

# =======================================================
# Load fzf support bindings
#
# NOTE: I dont believe anything here calls anything above
# directly, so this could be kept alone in the source
# loaders script, and all of the above could be moved to its
# own lib/files, and further refactored for dorothy purposes.

# NOTE: I believe that we should have an improved system for making keybinds
# with dorothy so that it is a bit more automated. Maybe, this could go
# into somekind of keybinds.sh file.
# BUT i am not sure  all of this should be managed. so now i think that a good
# way is just to explore how such bindings work and stuff so that we can
# have some nice extra control bindings in the shell.

if [[ -n "${BASH_VERSION:-}" ]]; then
  __fzf_git_init() {
    __debug_lines "bash not supported yet"
    # bind -m emacs-standard '"\er":  redraw-current-line'
    # bind -m emacs-standard '"\C-z": vi-editing-mode'
    # bind -m vi-command     '"\C-z": emacs-editing-mode'
    # bind -m vi-insert      '"\C-z": emacs-editing-mode'
    #
    # local o c
    # for o in "$@"; do
    #   c=${o:0:1}
    #   bind -m emacs-standard '"\C-g\C-'$c'": " \C-u \C-a\C-k`_fzf_git_'$o'`\e\C-e\C-y\C-a\C-y\ey\C-h\C-e\er \C-h"'
    #   bind -m vi-command     '"\C-g\C-'$c'": "\C-z\C-g\C-'$c'\C-z"'
    #   bind -m vi-insert      '"\C-g\C-'$c'": "\C-z\C-g\C-'$c'\C-z"'
    #   bind -m emacs-standard '"\C-g'$c'":    " \C-u \C-a\C-k`_fzf_git_'$o'`\e\C-e\C-y\C-a\C-y\ey\C-h\C-e\er \C-h"'
    #   bind -m vi-command     '"\C-g'$c'":    "\C-z\C-g'$c'\C-z"'
    #   bind -m vi-insert      '"\C-g'$c'":    "\C-z\C-g'$c'\C-z"'
    # done
  }
elif [[ -n "${FISH_VERSION:-}" ]]; then

# FIX: Because `fish` is not posix, this file cant be sourced in fish, and
# therefore we are required to split this into multiple files, so that you
# can define user keybinds separately.

  __fzf_git_init() {
    # https://fishshell.com/docs/current/cmds/bind.html
    #
    # I need to just read through this doc so that we can add this shit
    # for fish and then have that stuff made for ben later.
    __debug_lines "fish shell is not supported yet."

    # # bind \cd 'exit'
    # local o c
    # for o in "$@"; do
    #   # local fish_bind_func_handle="fzf-git-$o-widget"
    #   local fish_bind_func_handle="_fzf_git_$o"
    #   c=${o:0:1}
    #   bind "\cg\c$c" "$fish_bind_func_handle"
    #   # bind -m emacs-standard '"\C-g\C-'$c'": " \C-u \C-a\C-k`_fzf_git_'$o'`\e\C-e\C-y\C-a\C-y\ey\C-h\C-e\er \C-h"'
    #   # bind -m vi-command     '"\C-g\C-'$c'": "\C-z\C-g\C-'$c'\C-z"'
    #   # bind -m vi-insert      '"\C-g\C-'$c'": "\C-z\C-g\C-'$c'\C-z"'
    #   # bind -m emacs-standard '"\C-g'$c'":    " \C-u \C-a\C-k`_fzf_git_'$o'`\e\C-e\C-y\C-a\C-y\ey\C-h\C-e\er \C-h"'
    #   # bind -m vi-command     '"\C-g'$c'":    "\C-z\C-g'$c'\C-z"'
    #   # bind -m vi-insert      '"\C-g'$c'":    "\C-z\C-g'$c'\C-z"'
    # done
  }
elif [[ -n "${ZSH_VERSION:-}" ]]; then
  __fzf_git_join_lines() {
    local line
    while read line; do
      echo -n "${(q)line} "
    done
  }

  # there is some type of error that I have to figure out.
  set -e

  __fzf_git_init() {

    # local available_funcs=$(declare -f)
    # __print_lines "${available_funcs[@]}"

    local m o
    for o in "$@"; do

      # why do we have to generate custom functions???

      local key="${o:0:1}"
      local picker_name="${o:2}"

      local zsh_bind_func_handle="fzf-git-$picker_name-widget"

      local fzf_action="fzf-helper $picker_name"

      # >> `:Man zshzle`
      #
      # reset-prompt (unbound) (unbound) (unbound)
      #        Force the prompts on both the left and right of the screen to be
      #        re-expanded, then redisplay the edit buffer.  This reflects
      #        changes both to the prompt variables themselves and changes in
      #        the expansion of the values (for example, changes in time or
      #        directory, or changes to the value of variables referred to by
      #        the prompt).
      #
      #        Otherwise, the prompt is only expanded each time zle starts, and
      #        when the display has been interrupted by output from another
      #        part of the shell (such as a job notification) which causes the
      #        command line to be reprinted.
      #
      #        reset-prompt doesn't alter the special parameter LASTWIDGET.
      #

      # USER-DEFINED WIDGETS
      #        User-defined widgets, being implemented as shell functions, can
      #        execute any normal shell command.  They can also run other
      #        widgets (whether built-in or user-defined) using the zle builtin
      #        command. The standard input of the function is redirected from
      #        /dev/null to prevent external commands from unintentionally
      #        blocking ZLE by reading from the terminal, but read -k or read
      #        -q can be used to read characters.  Finally, they can examine
      #        and edit the ZLE buffer being edited by reading and setting the
      #        special parameters described below.
      #
      #        These special parameters are always available in widget
      #        functions, but are not in any way special outside ZLE.  If they
      #        have some normal value outside ZLE, that value is temporarily
      #        inaccessible, but will return when the widget function exits.
      #        These special parameters in fact have local scope, like
      #        parameters created in a function using local.
      #
      #        Inside completion widgets and traps called while ZLE is active,
      #        these parameters are available read-only.
      #
      #        Note that the parameters appear as local to any ZLE widget in
      #        which they appear.  Hence if it is desired to override them this
      #        needs to be done within a nested function:
      #
      #               widget-function() {
      #                 # $WIDGET here refers to the special variable
      #                 # that is local inside widget-function
      #                 () {
      #                    # This anonymous nested function allows WIDGET
      #                    # to be used as a local variable.  The -h
      #                    # removes the special status of the variable.
      #                    local -h WIDGET
      #                 }
      #               }
      #
      #
      #      LBUFFER (scalar)
      #              The part of the buffer that lies to the left of the cursor position.  If it is assigned to, only that part of the
      #              buffer is replaced, and the cursor remains between the new $LBUFFER and the old $RBUFFER.

      # Define function handles that are responsible for:
      # 1. run the fzf git func
      # 2. capture results
      # 3. put the results to the left of cursor with `zle`

              # TODO: use dorothy command to properly escape the string.

        # echo \"\$result\" >/dev/tty; \
      local eval_str__zsh_create_func_handle="\
        $zsh_bind_func_handle() { \
        local result=\$($fzf_action | __fzf_git_join_lines); \
        echo \"\${result[@]}\"; \
        zle reset-prompt; \
        LBUFFER+=\$result \
      }"
      __debug_lines "[input = $o -> key = $key | picker name = $picker_name]"

      # make the func handlers available in the shell.
      eval "$eval_str__zsh_create_func_handle"

      # >> Mark the func handlers as zsh-widgets
      # This seems to be required in order to enable the use of LBUFFER, inside of
      # the widget
      #
      #        zle -N widget [ function ]
      #               Create a user-defined widget.  If there is already a widget with
      #               the specified name, it is overwritten.  When the new widget is
      #               invoked from within the editor, the specified shell function is
      #               called.  If no function name is specified, it defaults to the
      #               same name as the widget.  For further information, see the
      #               section `Widgets' below.
      eval "zle -N $zsh_bind_func_handle" # what is the zle command?

      # I think that it is poorly documented how this syntax works in
      # the docs.
      for m in emacs vicmd viins; do
        eval "bindkey -M $m '^g^$key' $zsh_bind_func_handle"
        eval "bindkey -M $m '^g$key' $zsh_bind_func_handle"
      done
    done
  }
  set +e
fi

# The first char is used for the binding for each (*)
FZF_GIT_SELECTOR_ACTIONS=(
  b_branches
  e_each_ref
  f_files
  a_hashes
  g_reflogs
  r_remotes
  y_stashes
  t_tags
  w_worktrees
)

__fzf_git_init "${FZF_GIT_SELECTOR_ACTIONS[@]}"
