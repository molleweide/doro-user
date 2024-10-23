# The MIT License (MIT)
#
# Copyright (c) 2024 Junegunn Choi
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# NOTE: This script loads keybinds that map to fzf git selector FZF_GIT_SELECTOR_ACTIONS (*).
# The first char is used for the binding for each (*)
FZF_GIT_SELECTOR_ACTIONS=(
  branches
  each_ref
  files
  hashes
  lreflogs
  remotes
  stashes
  tags
  worktrees
)


# NOTE:
# list all zsh binds with: bindkey -L
# -------
# list of articles on zsh's bindkey:
# https://jdhao.github.io/2019/06/13/zsh_bind_keys/
# https://www.thegeekdiary.com/bindkey-command-examples-add-keybindings-to-z-shell/

# TODO: It feels like the core also should be moved into a dorothy command so
# that you can use reuse this easilly.

# TODO: we could use


# NOTE: Should these binds be callable if one is not runnig a git command?
# Eg. should it work to run C-gC-e if the prompt is empty, ie. just triggering
# the fzf helper standalone.

# BUG: Find why I need to use `set -e` in zsh (and bash?)

# shellcheck disable=SC2039
[[ $0 = - ]] && return

# echo-style --h1="add git fzf support"

# echo "\$0 = $0"
# echo "\$- = $-"
# echo "\$1 = $1"
# echo "\$2 = $2"

DEBUG_FZF="yes"

# =======================================================
# Helpers

__print_lines(){
        printf "%s\n" "$1"
      }

__debug_lines(){
      if (( "$DEBUG_FZF" == "yes" )); then
        __print_lines "$1"
      fi
}


__fzf_git_color() {
  if [[ -n $NO_COLOR ]]; then
    echo never
  elif [[ $# -gt 0 ]] && [[ -n $FZF_GIT_PREVIEW_COLOR ]]; then
    echo "$FZF_GIT_PREVIEW_COLOR"
  else
    echo "${FZF_GIT_COLOR:-always}"
  fi
}

__fzf_git_cat() {
  if [[ -n $FZF_GIT_CAT ]]; then
    echo "$FZF_GIT_CAT"
    return
  fi

  local bat_opts=(
    --style="'${BAT_STYLE:-full}'"
    --color="$(__fzf_git_color .)"
    --pager="never"
  )

  # Sometimes bat is installed as batcat
  if command -v batcat > /dev/null; then
    echo "batcat ${bat_opts[*]}"
  elif command -v bat > /dev/null; then
    echo "bat ${bat_opts[*]}"
  else
    echo cat
  fi
}

__fzf_git_pager() {
  local pager
  pager="${FZF_GIT_PAGER:-${GIT_PAGER:-$(git config --get core.pager 2>/dev/null)}}"
  echo "${pager:-cat}"
}




# TODO: Maybe this chunk could be moved into its own file?
#
# NOTE: We only enter here when this script is called from the
# fzf_action handlers. Thus, echoing here for test purposes will not
# show any output.
#
# Allows the fzf git functions to perform and use specific git logic.
# This could maybe go into dorothy commands?
#
# NOTE: new name -> `fzf-git-support-helpers`

# Calling script with ONE arg
if [[ $# -eq 1 ]]; then
  branches() {
    git branch "$@" --sort=-committerdate --sort=-HEAD \
      --format=$'%(HEAD) %(color:yellow)%(refname:short) %(color:green)(%(committerdate:relative))\t%(color:blue)%(subject)%(color:reset)' \
      --color=$(__fzf_git_color) | column -ts$'\t'
  }
  refs() {
    git for-each-ref "$@" --sort=-creatordate --sort=-HEAD --color=$(__fzf_git_color) --format=$'%(if:equals=refs/remotes)%(refname:rstrip=-2)%(then)%(color:magenta)remote-branch%(else)%(if:equals=refs/heads)%(refname:rstrip=-2)%(then)%(color:brightgreen)branch%(else)%(if:equals=refs/tags)%(refname:rstrip=-2)%(then)%(color:brightcyan)tag%(else)%(if:equals=refs/stash)%(refname:rstrip=-2)%(then)%(color:brightred)stash%(else)%(color:white)%(refname:rstrip=-2)%(end)%(end)%(end)%(end)\t%(color:yellow)%(refname:short) %(color:green)(%(creatordate:relative))\t%(color:blue)%(subject)%(color:reset)' | column -ts$'\t'
  }
  hashes() {
    git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=$(__fzf_git_color) "$@"
  }
  case "$1" in
    branches)
      echo $'CTRL-O (open in browser) ╱ ALT-A (show all branches)\n'
      branches
      ;;
    all-branches)
      echo $'CTRL-O (open in browser)\n'
      branches -a
      ;;
    hashes)
      echo $'CTRL-O (open in browser) ╱ CTRL-D (diff)\nCTRL-S (toggle sort) ╱ ALT-A (show all hashes)\n'
      hashes
      ;;
    all-hashes)
      echo $'CTRL-O (open in browser) ╱ CTRL-D (diff)\nCTRL-S (toggle sort)\n'
      hashes --all
      ;;
    refs)
      echo $'CTRL-O (open in browser) ╱ ALT-E (examine in editor) ╱ ALT-A (show all refs)\n'
      refs --exclude='refs/remotes'
      ;;
    all-refs)
      echo $'CTRL-O (open in browser) ╱ ALT-E (examine in editor)\n'
      refs
      ;;
    nobeep) ;;
    *) exit 1 ;;
  esac
elif [[ $# -gt 1 ]]; then
  # Calling script with multiple args.

  # this is only when the scripting is initiating on shell load.
  # maybe should unset the vars instead.
  if [[ $1 =~ "interactive"* || $2 =~ "interactive"* ]]; then
    :
  else

    branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    if [[ $branch = HEAD ]]; then
      branch=$(git describe --exact-match --tags 2> /dev/null || git rev-parse --short HEAD)
    fi

    # Only supports GitHub for now
    case "$1" in
      commit)
        hash=$(grep -o "[a-f0-9]\{7,\}" <<< "$2")
        path=/commit/$hash
        ;;
      branch|remote-branch)
        branch=$(sed 's/^[* ]*//' <<< "$2" | cut -d' ' -f1)
        remote=$(git config branch."${branch}".remote || echo 'origin')
        branch=${branch#$remote/}
        path=/tree/$branch
        ;;
      remote)
        remote=$2
        path=/tree/$branch
        ;;
      file) path=/blob/$branch/$(git rev-parse --show-prefix)$2 ;;
      tag)  path=/releases/tag/$2 ;;
      *)    exit 1 ;;
    esac

    remote=${remote:-$(git config branch."${branch}".remote || echo 'origin')}
    remote_url=$(git remote get-url "$remote" 2> /dev/null || echo "$remote")

    if [[ $remote_url =~ ^git@ ]]; then
      url=${remote_url%.git}
      url=${url#git@}
      url=https://${url/://}
    elif [[ $remote_url =~ ^http ]]; then
      url=${remote_url%.git}
    fi

    case "$(uname -s)" in
      Darwin) open "$url$path"     ;;
      *)      xdg-open "$url$path" ;;
    esac
    exit 0
  fi
fi

# Only allow this to run in interactive mode.
if [[ $- =~ i ]]; then

# =======================================================
# Helpers


# TODO: refactor this into a fzf vars option config array

__fzf_cmd__base() {
  fzf --height=50% --tmux 90%,70% \
    --layout=reverse --multi --min-height=20 --border \
    --border-label-pos=2 \
    --color='header:italic:underline,label:blue' \
    --preview-window='right,50%,border-left' \
    --bind='ctrl-/:change-preview-window(down,50%,border-top|hidden|)' "$@"
}

__fzf_ensure_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1 && return
  [[ -n $TMUX ]] && tmux display-message "Not in a git repository"
  return 1
}

# Function handle to "this" script that will be something like:
# (1) /Users/hjalmarjakobsson/.local/share/dorothy/user/sources/git_fzf_support.sh
# (2) /Users/hjalmarjakobsson/.config/dorothy/sources/git_fzf_support.sh
#
# 1. First it gets  the symlinked into dorothy user path
# 2. Then, it is converted to the absolute path.
#
# NOTE: the purpose of this statement is to find the location of the
# script that is being called. But if this is located in dorothy, do we need
# this then?
# >> This variable will be accessible in the cli.
#
# Is this what fs-absolute does in dorothy?
# And especially if this script is

__fzf_git_script=${BASH_SOURCE[0]:-${(%):-%x}}
__fzf_git_script=$(readlink -f "$__fzf_git_script" 2> /dev/null || \
  /usr/bin/ruby --disable-gems -e 'puts File.expand_path(ARGV.first)' "$__fzf_git_script" 2> /dev/null)

# =======================================================
# Git types

# TODO: try
# --cycle

_fzf_git_files() {
  __fzf_ensure_git_repo || return
  local root query
  root=$(git rev-parse --show-toplevel)
  [[ $root != "$PWD" ]] && query='!../ '

  (git -c color.status=$(__fzf_git_color) status --short --no-branch
   git ls-files "$root" | grep -vxFf <(git status -s | grep '^[^?]' | cut -c4-; echo :) | sed 's/^/   /') |
  __fzf_cmd__base -m --ansi --nth 2..,.. \
    --border-label '📁 Files' \
    --header $'CTRL-O (open in browser) ╱ ALT-E (open in editor)\n\n' \
    --bind "ctrl-o:execute-silent:bash $__fzf_git_script file {-1}" \
    --bind "alt-e:execute:${EDITOR:-vim} {-1} > /dev/tty" \
    --query "$query" \
    --preview "git diff --no-ext-diff --color=$(__fzf_git_color .) -- {-1} | $(__fzf_git_pager); $(__fzf_git_cat) {-1}" "$@" |
  cut -c4- | sed 's/.* -> //'
}

_fzf_git_branches() {
  __fzf_ensure_git_repo || return
  local str_preview_cmd="git log --oneline --graph --date=short --color=$(__fzf_git_color .) \
            --pretty='format:%C(auto)%cd %h%d %s' \$(sed s/^..// <<< {} | cut -d' ' -f1) --"
  bash "$__fzf_git_script" branches |
  __fzf_cmd__base --ansi \
    --border-label '🌲 Branches' \
    --header-lines 2 \
    --tiebreak begin \
    --preview-window down,border-top,40% \
    --color hl:underline,hl+:underline \
    --no-hscroll \
    --bind 'ctrl-/:change-preview-window(down,70%|hidden|)' \
    --bind "ctrl-o:execute-silent:bash $__fzf_git_script branch {}" \
    --bind "alt-a:change-border-label(🌳 All branches)+reload:bash \"$__fzf_git_script\" all-branches" \
    --preview "$str_preview_cmd" \
    "$@" | sed 's/^..//' | cut -d' ' -f1
}

_fzf_git_tags() {
  __fzf_ensure_git_repo || return
  git tag --sort -version:refname |
  __fzf_cmd__base --preview-window right,70% \
    --border-label '📛 Tags' \
    --header $'CTRL-O (open in browser)\n\n' \
    --bind "ctrl-o:execute-silent:bash $__fzf_git_script tag {}" \
    --preview "git show --color=$(__fzf_git_color .) {} | $(__fzf_git_pager)" "$@"
}

_fzf_git_hashes() {
  __fzf_ensure_git_repo || return
  bash "$__fzf_git_script" hashes |
  __fzf_cmd__base --ansi --no-sort --bind 'ctrl-s:toggle-sort' \
    --border-label '🍡 Hashes' \
    --header-lines 3 \
    --bind "ctrl-o:execute-silent:bash $__fzf_git_script commit {}" \
    --bind "ctrl-d:execute:grep -o '[a-f0-9]\{7,\}' <<< {} | head -n 1 | xargs git diff --color=$(__fzf_git_color) > /dev/tty" \
    --bind "alt-a:change-border-label(🍇 All hashes)+reload:bash \"$__fzf_git_script\" all-hashes" \
    --color hl:underline,hl+:underline \
    --preview "grep -o '[a-f0-9]\{7,\}' <<< {} | head -n 1 | xargs git show --color=$(__fzf_git_color .) | $(__fzf_git_pager)" "$@" |
  awk 'match($0, /[a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]*/) { print substr($0, RSTART, RLENGTH) }'
}

_fzf_git_remotes() {
  __fzf_ensure_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  __fzf_cmd__base --tac \
    --border-label '📡 Remotes' \
    --header $'CTRL-O (open in browser)\n\n' \
    --bind "ctrl-o:execute-silent:bash $__fzf_git_script remote {1}" \
    --preview-window right,70% \
    --preview "git log --oneline --graph --date=short --color=$(__fzf_git_color .) --pretty='format:%C(auto)%cd %h%d %s' '{1}/$(git rev-parse --abbrev-ref HEAD)' --" "$@" |
  cut -d$'\t' -f1
}

_fzf_git_stashes() {
  __fzf_ensure_git_repo || return
  git stash list | __fzf_cmd__base \
    --border-label '🥡 Stashes' \
    --header $'CTRL-X (drop stash)\n\n' \
    --bind 'ctrl-x:reload(git stash drop -q {1}; git stash list)' \
    -d: --preview "git show --color=$(__fzf_git_color .) {1} | $(__fzf_git_pager)" "$@" |
  cut -d: -f1
}

# ref logs (it starts with `l` so that we can use `l` as the keybind.
_fzf_git_lreflogs() {
  __fzf_ensure_git_repo || return
  git reflog --color=$(__fzf_git_color) --format="%C(blue)%gD %C(yellow)%h%C(auto)%d %gs" | __fzf_cmd__base --ansi \
    --border-label '📒 Reflogs' \
    --preview "git show --color=$(__fzf_git_color .) {1} | $(__fzf_git_pager)" "$@" |
  awk '{print $1}'
}

_fzf_git_each_ref() {
  __fzf_ensure_git_repo || return
  bash "$__fzf_git_script" refs | __fzf_cmd__base --ansi \
    --nth 2,2.. \
    --tiebreak begin \
    --border-label '☘️  Each ref' \
    --header-lines 2 \
    --preview-window down,border-top,40% \
    --color hl:underline,hl+:underline \
    --no-hscroll \
    --bind 'ctrl-/:change-preview-window(down,70%|hidden|)' \
    --bind "ctrl-o:execute-silent:bash $__fzf_git_script {1} {2}" \
    --bind "alt-e:execute:${EDITOR:-vim} <(git show {2}) > /dev/tty" \
    --bind "alt-a:change-border-label(🍀 Every ref)+reload:bash \"$__fzf_git_script\" all-refs" \
    --preview "git log --oneline --graph --date=short --color=$(__fzf_git_color .) --pretty='format:%C(auto)%cd %h%d %s' {2} --" "$@" |
  awk '{print $2}'
}

_fzf_git_worktrees() {
  __fzf_ensure_git_repo || return
  git worktree list | __fzf_cmd__base \
    --border-label '🌴 Worktrees' \
    --header $'CTRL-X (remove worktree)\n\n' \
    --bind 'ctrl-x:reload(git worktree remove {1} > /dev/null; git worktree list)' \
    --preview "
      git -c color.status=$(__fzf_git_color .) -C {1} status --short --branch
      echo
      git log --oneline --graph --date=short --color=$(__fzf_git_color .) --pretty='format:%C(auto)%cd %h%d %s' {2} --
    " "$@" |
  awk '{print $1}'
}

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
    bind -m emacs-standard '"\er":  redraw-current-line'
    bind -m emacs-standard '"\C-z": vi-editing-mode'
    bind -m vi-command     '"\C-z": emacs-editing-mode'
    bind -m vi-insert      '"\C-z": emacs-editing-mode'

    local o c
    for o in "$@"; do
      c=${o:0:1}
      bind -m emacs-standard '"\C-g\C-'$c'": " \C-u \C-a\C-k`_fzf_git_'$o'`\e\C-e\C-y\C-a\C-y\ey\C-h\C-e\er \C-h"'
      bind -m vi-command     '"\C-g\C-'$c'": "\C-z\C-g\C-'$c'\C-z"'
      bind -m vi-insert      '"\C-g\C-'$c'": "\C-z\C-g\C-'$c'\C-z"'
      bind -m emacs-standard '"\C-g'$c'":    " \C-u \C-a\C-k`_fzf_git_'$o'`\e\C-e\C-y\C-a\C-y\ey\C-h\C-e\er \C-h"'
      bind -m vi-command     '"\C-g'$c'":    "\C-z\C-g'$c'\C-z"'
      bind -m vi-insert      '"\C-g'$c'":    "\C-z\C-g'$c'\C-z"'
    done
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
      local zsh_bind_func_handle="fzf-git-$o-widget"
      local fzf_action="_fzf_git_$o"

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
      local eval_str__zsh_create_func_handle="\
        $zsh_bind_func_handle() { local result=\$($fzf_action | __fzf_git_join_lines); \
        zle reset-prompt; \
        LBUFFER+=\$result \
      }"
      __debug_lines "$eval_str__zsh_create_func_handle"

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
        eval "bindkey -M $m '^g^${o[1]}' $zsh_bind_func_handle"
        eval "bindkey -M $m '^g${o[1]}' $zsh_bind_func_handle"
      done
    done
  }
  set +e
fi

__fzf_git_init "${FZF_GIT_SELECTOR_ACTIONS[@]}"
fi
