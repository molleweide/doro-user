# reload shell
function rl() {
  source "$DOROTHY/sources/environment.sh"
  source "$DOROTHY/sources/interactive.sh"
}

# =======================================================
# shell switching
#

alias b="b"
alias bi="bash -i"
alias bil="bash -il"
alias xb="exec bash"
alias xbi="exec bash -i"
alias xbil="exec bash -il"

alias zi="zsh -i"
alias zil="zsh -il"
alias ez="exez zsh"
alias xzi="exec zsh -i"
alias xzil="exec zsh -il"

#---------------------------
#---       general       ---
#---------------------------

# # Use $XINITRC variable if file exists.
# [ -f "$XINITRC" ] && alias startx="startx $XINITRC"

# # # Colorize commands when possible.
# alias \
# 	# ls="ls -hN --color=auto --group-directories-first" \ # illegal on macos
# 	grep="grep --color=auto" \
# 	diff="diff --color=auto" \
# 	# ccat="highlight --out-format=ansi" # only linux

# alias \
# 	magit="nvim -c MagitOnly" \
# 	ref="shortcuts >/dev/null; source ${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc ; source ${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" \
# 	weath="less -S ${XDG_DATA_HOME:-$HOME/.local/share}/weatherreport" \

# # # These common commands are just too long! Abbreviate them.
# alias \
# 	ka="killall" \
# 	g="git" \
# 	trem="transmission-remote" \
# 	YT="youtube-viewer" \
# 	# sdn="sudo shutdown -h now" \ # scary ???
# 	# e="$EDITOR" \
# 	# v="$EDITOR" \
# 	# p="sudo pacman" \ # linux
# 	xi="sudo xbps-install" \
# 	xr="sudo xbps-remove -R" \
# 	xq="xbps-query" \
# 	# z="zathura" # linux

alias e="fg" # Resume background process
alias k="clear" # Clear screen
alias mm="man man"
alias tt="ttyper" # Typing test
# alias dbm="rake db:migrate && RAILS_ENV=test rake db:migrate"
# alias j=z # I'm used to autojump 'j' vs fasd 'z'
# alias less="less -r"
# alias sketch="magick $1 \( -clone 0 -negate -blur 0x5 \) -compose colordodge -composite -modulate 100,0,100 -auto-level $2"
# alias srync="rsync -vrazh"
# alias emacs="TERM=xterm-24bit emacs -nw"
alias cl="calcurse"
alias ei="cointop"
alias ctgr="ctags -R"
# # shortcuts
# alias vi='vim'
# alias nv='nvim'
# alias afind='ack -il'
# alias md="mkdir -p"
# alias rd="rmdir"
# alias please=sudo
alias po=popd
alias pu=pushd
# alias globurl='noglob urlglobber '
alias ZZ=exit

#---------------------------
#---       DOROTHY       ---
#---------------------------

alias d='dorothy'
alias dp='dorothy permissions'

alias dr='cd "$DOROTHY"'

alias sdri="setup-install"
alias sdr="setup-dorothy"
alias sdrp="setup-dorothy-permissions"
alias ssha="ssh-add-all"

alias dtr='cd "$DOROTHY" && ${VISUAL:-${EDITOR:-vim}} .'

# USER

alias dt='cd "$XDG_CONFIG_HOME/dorothy"'
alias dte='cd "$XDG_CONFIG_HOME/dorothy" && ${VISUAL:-${EDITOR:-vim}} .'

alias sup="setup-personal-stuff"
alias suc="setup-user-configs"

# ctags ==========================================

#--------------------------
#---       TILING       ---
#--------------------------

# reload macos yabai tiling
function reload_tiling() {
  brew services restart yabai
  brew services restart skhd
  limelight # there is a wierd err msg but it works...
}

#--------------------------
#---       locate       ---
#--------------------------

# TODO: handle this one
# # https://egeek.me/2020/04/18/enabling-locate-on-osx/
# if which glocate >/dev/null; then
#   alias locate="glocate -d $HOME/locatedb"
# fi
# alias loaddb="locatedb-load"

#--------------------------------
#---       SPREADSHEETS       ---
#--------------------------------

alias scm="sc-im"
alias scml="~/.local/bin/sc-im"

#---------------------------------------
#---       SEARCH & FIND FILES       ---
#---------------------------------------

# fo [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fo() {
  local files
  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# fh [FUZZY PATTERN] - Search in command history
fz() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# fuzzy grep via rg and open in vim with line number
fgr() {
  local file
  local line

  read -r file line <<<"$(rg --no-heading --line-number $@ | fzf -0 -1 | awk -F: '{print $1, $2}')"

  if [[ -n $file ]]; then
    vim $file +$line
  fi
}

# ------------------------
# ---       TMUX       ---
# ------------------------

# https://github.com/tmux-plugins
# https://github.com/tmux-plugins/list

# https://github.com/sainnhe/tmux-fzf
# https://github.com/wfxr/tmux-fzf-url
# https://github.com/Aloxaf/fzf-tab
# https://github.com/yardnsm/tmux-1password
# https://github.com/isuryanarayanan/tmuxinator-fzf-helper/blob/main/tmuxinator-helper.sh
# https://github.com/camspiers/tmuxinator-fzf-start
# https://github.com/danielpieper/telescope-tmuxinator.nvim
# https://github.com/Bajena/TmuxinatorMultiLaunch
# https://github.com/ethagnawl/rmuxinator
# https://github.com/roosta/tmux-fuzzback
# https://github.com/rafi/tmux-pass
# https://github.com/tomhoule/gitmoji-selector
# https://programmer.ink/think/creating-an-efficient-front-end-working-environment-tmuxinator.html
# https://github.com/drmad/tmux-git

# how to save current session?
# https://stackoverflow.com/questions/16752088/how-to-save-tmux-session-to-tmuxinator-project
# https://forum.upcase.com/t/save-and-reopen-tmux-session/5224/2
# https://github.com/search?q=tmux+save
# https://github.com/ynishi/tmux-save
# https://www.reddit.com/r/commandline/comments/2ocqw3/dont_you_wish_you_could_save_and_load_tmux/

# tmux tips
# https://www.sitepoint.com/10-killer-tmux-tips/

# tmux configs
# https://github.com/search?q=tmux+configuration

# [SESSION_NAME | FUZZY PATTERN] - create new tmux session, or switch to existing one.
# Running `tm` will let you fuzzy-find a session mame
# Passing an argument to `ftm` will switch to that session if it exists or create it otherwise
tns() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null ||
      (tmux new-session -d -s $1 && tmux $change -t "$1")
    return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&
    tmux $change -t "$session" || echo "No sessions found."
}

# tm [SESSION_NAME | FUZZY PATTERN] - delete tmux session
# Running `tm` will let you fuzzy-find a session mame to delete
# Passing an argument to `ftm` will delete that session if it exists
tks() {
  if [ $1 ]; then
    tmux kill-session -t "$1"
    return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&
    tmux kill-session -t "$session" || echo "No session found to delete."
}

alias tm="tmux"
alias tk="tmux kill-session"

#---------------------------
#---       dockers       ---
#---------------------------

alias dk="docker"
alias dkc="docker-compose"
alias dkwp="docker-compose run --rm wpcli"

#---------------------------------
#---       file browsers       ---
#---------------------------------

alias fh="fff" # File browser
alias fj="lf" # File browser
alias fk="ranger2" # File browser custom func
alias fn="nnn" # File browser

# switch cwd on exit

# ranger with some extras
# - Q to exit to current dir in CLI.
function ranger2() {
  local IFS=$'\t\n' tempfile ranger_cmd
  tempfile="$(mktemp -t tmp.XXXXXX)"
  ranger_cmd=(
    command
    ranger
    --cmd='map Q chain shell echo %d > '"$tempfile"'; quitall'
  )

  "${ranger_cmd[@]}" "$@"
  if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n "$(pwd)")" ]]; then
    cd -- "$(cat "$tempfile")" || return
  fi
  command rm -f -- "$tempfile" 2>/dev/null
}

# #-----------------------
# #---       VIM       ---
# #-----------------------

# # Use neovim for vim if present.
# [ -x "$(command -v nvim)" ] && alias vim="nvim" vimdiff="nvim -d"

# alias vim="nvim"
# alias v="nvim"
# alias vv="~/code/neovim/build/bin/nvim" # forked build
# alias vf="nvim -t" # search for tag
# alias vr="nvim -R"
# alias vh="nvim -headless"
# alias vNN="nvim -u NONE"
# alias vNC="nvim -u NORC"
# alias vh="nvim -headless"
# alias vp="nvim --cmd \"set rtp+=\$(pwd)\""

#-----------------------
#---       GIT       ---
#-----------------------

function fco() {
  git checkout $(git branch -a --sort=-committerdate |
    cut -c 3- |
    sed 's/^remotes\/[^/]*\///' |
    sort |
    uniq |
    grep -v HEAD |
    fzf-tmux -d 20)
}

# fbr [FUZZY PATTERN] - Checkout specified branch
# Include remote branches, sorted by most recent commit and limited to 30
fgb() {
  local branches branch
  branches=$(git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
    branch=$(echo "$branches" |
      fzf-tmux -d $((2 + $(wc -l <<<"$branches"))) +m) &&
    git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

alias m="git checkout molleweide"
alias M="git checkout molldev"
alias gcreb="git add --all && git commit -m 'REBASE ME!!!'"
alias gcun="git add notes/ && git commit -m 'user(molleweide): notes'"
alias sv="git add --all && git commit -m 'save'"
alias svp="git add --all && git commit -m 'save' && git push"
alias lg="lazygit"
alias gcbn="git-get-checked-out-branch-name"

# 1 = branch, 2 = sub path, 3 = new repo url
alias gbrkout="git-subdir-make-into-module"
# alias gsmv="git-submodule-mv"

# list branches by last date modified
alias gbld="git for-each-ref --sort=committerdate refs/heads/ --format='%(color: red)%(committerdate:short) %(color: cyan)%(refname:short)'"

#-----------------------
#---       GITHUB       ---
#-----------------------

alias ghfk="gh repo fork" # add this to `ghm`

alias ghprdev="gh pr create --base develop"

alias ghprmst="gh pr create --base master" # ???

# create public git repo
function ghrc() {
  gh repo create $1 --public
}

# create puflic git repo
function ghrcc() {
  gh repo create $1 --public -c
}

# -----------------------
# ---       GHQ       ---
# -----------------------

alias ghg="ghq get -p"
alias ghC="ghq create"
alias ghl="ghq list"
alias ghr="ghq root"
alias ghh="ghq help"

#----------------------------------
#---       COMMUNICATIONS       ---
#----------------------------------

alias sig="gurk" # signal
# alias sg="gurk" # siggo has better support than gurk
alias nt="neomutt" # email
# tg for telegram is default..
# discord

#-----------------------
#---       QMK       ---
#-------------------------

# TODO: add qmk dir to environment
alias tfl="teensy_loader_cli -mmcu=atmega32u4 -w ergodox_ez_molleweide.hex"
alias qmkflash="cd $HOME/code/firmware/qmk-firmware/ && tfl"

#-----------------------------
#---       KARABINER       ---
#----------------------------

function krbcp() {
  # this works but if can take a while before the settings update.
  # force update by deselecting and then selecting the mod again.
  make
  cp public/json/molleweide.json ~/.config/karabiner/assets/complex_modifications
}

alias karb="/Library/Application\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli"
alias krb="open -a /Applications/Karabiner-Elements.app"

#--------------------------
#---       KMONAD       ---
#-------------------------
# DEPRECATED
# kmonad=~/.local/bin/kmonad
# layouts=~/code/tools/kmonad/keymap/user/molleweide
# alias kmo="kmonad_run"
# alias kmor="kmo -r"
# # old
# kmopro() { sudo $kmonad $layouts/macbook_pro_2012.kbd; }
# kmoair() { sudo $kmonad $layouts/macbook_air_2021_m1.kbd; }
# kmoez() { sudo $kmonad $layouts/ergodox_ez.kbd; }
# kmoproT() { sudo $kmonad $layouts/macbook_pro_2012.kbd -l debug; }
# kmoairT() { sudo $kmonad $layouts/macbook_air_2021_m1.kbd -l debug; }
# kmoezT() { sudo $kmonad $layouts/ergodox_ez.kbd -l debug; }

#-------------------------
#---       MEDIA       ---
#-------------------------

alias yt="mpsyt"

#-----------------------
#---       GPG       ---
#-----------------------

alias gpglk="gpg --list-keys"
alias gpglkp="gpg --list-public-keys"
alias gpglks="gpg --list-secret-keys"
alias gpge="gpg --edit-keys"

#---------------------------
#---       HASKELL       ---
#---------------------------

alias rh="runhaskell"

#----------------------------
#---     macos / OSX      ---
#----------------------------

# https://apple.stackexchange.com/questions/178313/change-accessibility-setting-on-mac-using-terminal
# https://apple.stackexchange.com/questions/366222/using-command-line-how-to-open-a-specific-section-of-gui-system-preferences
# https://pawelgrzybek.com/change-macos-user-preferences-via-command-line/
# https://www.shell-tips.com/mac/defaults/
# https://apple.stackexchange.com/questions/65794/how-do-you-access-network-preferences-from-the-terminal
# https://itectec.com/askdifferent/macos-how-to-change-mission-control-shortcuts-from-the-command-line/
# https://apple.stackexchange.com/questions/398561/how-to-set-system-keyboard-shortcuts-via-command-line

alias g="screenshot" # this does not capture applications ?! only background image?!
alias sl="computer-sleep"

alias defd="defaults domains | tr ',' '\n'"

# sl() {
#   osascript -e 'tell application "Finder" to sleep'
# }

# network
alias netwl="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s"
alias netws="networksetup -setairportnetwork en0" # <SSID_OF_NETWORK> <PASSWORD>

# ----------------------------
# ---       CRONJOBS       ---
# ----------------------------
alias cronbak="crontab -l > $DOROTHY/user/backups/crontab.bak"
alias cronuse="crontab $DOROTHY/user/backups/crontab.bak"

#------------------------------
#---       MACOS APPS       ---
#------------------------------

# OS X apps
alias md="open -a Markoff"

#--------------------------
#---       OTHERS       ---
#-------------------------

function pgrefresh() {
  rm -fr /usr/local/var/postgres/postmaster.pid
  brew services restart postgresql
}

function sslcert() {
  echo |
    openssl s_client -showcerts -servername $1 -connect $1:443 2>/dev/null |
    openssl x509 -inform pem -noout -text
}

function cheat() {
  curl cht.sh/$1
}

function opendir() {
  local file="$1"
  local dir=$(dirname "$file")
  open "$dir"
}

#---------------------------------
#---       OTHER ALIASES       ---
#--------------------------------

# # https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789#.vh7hhm6th
# # https://github.com/webpro/dotfiles/blob/master/system/.alias
# # https://github.com/mathiasbynens/dotfiles/blob/master/.aliases

#----------------------------
#---       ZSH ONLY       ---
#----------------------------

# alias ..='cd ../..'
# alias ...='cd ../../..'
# alias ....='cd ../../../..'
# alias .....='cd ../../../../..'

# if [[ -n ${ZSH_VERSION-} ]]; then
#   alias -- -='cd -'
#   alias 1='cd -'
#   alias 2='cd -2'
#   alias 3='cd -3'
#   alias 4='cd -4'
#   alias 5='cd -5'
#   alias 6='cd -6'
#   alias 7='cd -7'
#   alias 8='cd -8'
#   alias 9='cd -9'
#
#   alias ..='cd ..'
#   alias -g ..2='../..'
#   alias -g ..3='../../..'
#   alias -g ..4='../../../..'
#   alias -g ..5='../../../../..'
#   alias -g ...='../..'
#   alias -g ....='../../..'
#   alias -g .....='../../../..'
#   alias -g ......='../../../../..'
#
#   # alias zshrc='$VISUAL "${ZDOTDIR:-$HOME}"/.zshrc'
#   alias reload='source "${ZDOTDIR:-$HOME}"/.zshrc'
#   alias zbench='export LAZY_PROMPT=false; for i in $(seq 1 10); do; /usr/bin/time zsh -i -c exit; done; unset LAZY_PROMPT'
#   alias zdot='cd $ZDOTDIR'
#
#   # zsh pipes
#   alias -g H='| head'
#   alias -g T='| tail'
#   alias -g G='| grep -E'
#   alias -g S='| sort'
#   alias -g L='| less'
#   alias -g M='| more'
# fi

# # mask built-ins with better defaults
# # alias cp='cp -i'
# # alias mv='mv -i'
# # alias rm='rm -i'
# alias ls='ls -GF'
# alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
# alias ping='ping -c 5'

# be safe
# alias cpi='cp -i'
# alias mvi='mv -i'
# alias rmi='rm -i'

# Verbosity and settings that you pretty much just always are going to want.
# alias \
# 	cp="cp -iv" \
# 	mv="mv -iv" \
# 	rm="rm -vI" \
# 	bc="bc -ql" \
# 	mkd="mkdir -pv" \
# 	yt="youtube-dl --add-metadata -i" \
# 	yta="yt -x -f bestaudio/best" \
# 	ffmpeg="ffmpeg -hide_banner"

# single character shortcuts - be sparing!
alias dr='dirs -v | head -10'
# alias v='vim'
alias h='history'

# # more ways to ls
alias ll='ls -lFh'
# alias l='ls -F'
alias drs="dirs -v"
alias l="ls -la"
alias la='ls -lAFh'
alias ldot='ls -ld .*'

# fix typos
alias quit='exit'

# tools
alias te="${EDITOR-}"
alias ide="${VISUAL-}"

# # network
# alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
# alias iplocal="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"
# alias dnsflush="dscacheutil -flushcache && killall -HUP mDNSResponder"
alias speedtest="wget -O /dev/null http://speed.transip.nl/10mb.bin"
# alias pinging="command ping"

# # other aliases
# alias tarls="tar -tvf"
# alias untar="tar -xf"
# alias biggest='du -s ./* | sort -nr | awk '\''{print $2}'\'' | xargs du -sh'
# alias dux='du -x --max-depth=1 | sort -n'
# alias path='echo -e ${PATH//:/\\n}'
# alias linecount="grep -c '^'"
# alias ds="date +%Y%m%d"
# alias ts="date +%Y%m%d%H%M%S"
# alias timestamp="date '+%Y-%m-%d %H:%M:%S'"
# alias datestamp="date '+%Y-%m-%d'"
# alias fd='find . -type d -name'
# alias ff='find . -type f -name'
# alias dud='du -d 1 -h'
# alias duf='du -sh *'

# # auto-orient images based on exif tags
# alias autorotate="jhead -autorot"

# # Shortcuts

# alias reload="source ~/.bash_profile"
# alias _="sudo"
# alias g="git"
# alias rr="rm -rf"

# # Default options

# alias rsync="rsync -vh"
# alias json="json -c"
# alias psgrep="psgrep -i"

# # Global aliases

# if $(is-supported "alias -g"); then
#   alias -g G="| grep -i"
#   alias -g H="| head"
#   alias -g T="| tail"
#   alias -g L="| less"
# fi

# # List declared aliases, functions, paths

# alias aliases="alias | sed 's/=.*//'"
# alias functions="declare -f | grep '^[a-z].* ()' | sed 's/{$//'"
# alias paths='echo -e ${PATH//:/\\n}'

# # Directory listing/traversal

# LS_COLORS=$(is-supported "ls --color" --color -G)
# LS_TIMESTYLEISO=$(is-supported "ls --time-style=long-iso" --time-style=long-iso)
# LS_GROUPDIRSFIRST=$(is-supported "ls --group-directories-first" --group-directories-first)

# alias l="ls -lahA $LS_COLORS $LS_TIMESTYLEISO $LS_GROUPDIRSFIRST"
# alias ll="ls -lA $LS_COLORS"
# alias lt="ls -lhAtr $LS_COLORS $LS_TIMESTYLEISO $LS_GROUPDIRSFIRST"
# alias ld="ls -ld $LS_COLORS */"
# alias lp="stat -c '%a %n' *"

# unset LS_COLORS LS_TIMESTYLEISO LS_GROUPDIRSFIRST

# alias ..="cd .."
# alias ...="cd ../.."
# alias ....="cd ../../.."
# alias .....="cd ../../../.."
# alias -- -="cd -"                  # Go to previous dir with -
# alias cd.='cd $(readlink -f .)'    # Go to real dir (i.e. if current dir is linked)

# # npm

# alias ni="npm install"
# alias nu="npm uninstall"
# alias nup="npm update"
# alias nri="rm -r node_modules && npm install"
# alias ncd="npm-check -su"

# # Network

# alias ip="curl -s ipinfo.io | jq -r '.ip'"
# alias ipl="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"

# # Request using GET, POST, etc. method

# for METHOD in GET HEAD POST PUT DELETE TRACE OPTIONS; do
#   alias "$METHOD"="lwp-request -m '$METHOD'"
# done
# unset METHOD

# # Miscellaneous

# alias hosts="sudo $EDITOR /etc/hosts"
# alias quit="exit"
# alias week="date +%V"
# alias speedtest="wget -O /dev/null http://speed.transip.nl/100mb.bin"
# alias grip="grip -b"

# #!/bin/bash

# # colors, yay!
# alias ls='ls --color=auto'
# alias svndiff="svn diff --diff-cmd=colordiff"
# alias grep='grep --colour'

# # run php on cli with special config for profiling
# alias phprofile='php -c /etc/php5/cli/profile/'

# # shortcut
# alias compile++='g++ -Wall -pedantic -ansi'

# # run program in gdb
# # usage: debug APP APP_ARGS
# alias debug='QT_XCB_NO_GRAB_SERVER=1 gdb -q --eval-command="run" --args'
# alias debug_main='QT_XCB_NO_GRAB_SERVER=1 gdb -q --eval-command="break main" --eval-command="run" --args'
# alias debug_catch='QT_XCB_NO_GRAB_SERVER=1 gdb -q --eval-command="catch throw" --eval-command="run" --args'

# # sometimes I want to clean all files which are not tracked by svn
# alias svnclean="svn status | grep "^?" | cut -c 3- | xargs rm -Rf"

# if [ -f /etc/arch-release ]; then
#   # arch linux specific aliases
#   alias upgradesystem='CMAKE_GENERATOR="Unix Makefiles" pikaur -Syu'
#   # ack is called ack-grep under debian, and I got used to that name...
#   alias ack-grep='ack'
# fi

# alias free="free -h"

# # mplayer with cache, e.g. for sshfs mounted shares and the like
# alias netmplayer="mplayer -cache 8192"

# alias kde-update-pim="kde-update akonadi nepomuk-core nepomuk-widgets kdepimlibs kdepim-runtime kdepim"
# alias kde-update-kdev="kde-update kate kdevplatform kdevelop kdev-php kdev-php-docs kdev-qmake"

# alias isomount="sudo mount -o loop -t iso9660"
# alias enable_icc="source ~/.bin/enable_icc.sh"

# alias webkit-debug="export QTWEBKIT_INSPECTOR_SERVER=9999"

# alias kdab-berlin-vpn="sudo openvpn /etc/openvpn/client/office-berlin.ovpn"

# alias nvidia-run="vblank_mode=0 primusrun"

# alias screen-omap5432="screen /dev/ttyUSB0 115200 8N1"

# alias dropcaches="echo 3 | sudo tee /proc/sys/vm/drop_caches"

# alias clazy-demo="CLAZY_CHECKS='level0,level1,level2,level3' clazy -I/usr/include/qt -I/usr/include/qt/QtCore -c -o /dev/null -std=c++11 -fPIC"
# alias clazy-demo-gcc="g++ -Wall -Wpedantic -I/usr/include/qt -I/usr/include/qt/QtCore -c -o /dev/null -std=c++11 -fPIC"

# alias aslr-disable="echo 0 | sudo tee /proc/sys/kernel/randomize_va_space"
# alias aslr-enable="echo 2 | sudo tee /proc/sys/kernel/randomize_va_space"

# alias toplev="python2 $HOME/projects/src/pmu-tools/toplev.py"
# alias top="htop"

# alias memcheck="valgrind --smc-check=all-non-file --track-origins=yes"

# alias kde_reboot="qdbus org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.logout 0 1 0"
# alias kde_shutdown="qdbus org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.logout 0 2 0"

# alias minmaxavgstats="datamash -W min 1 max 1 mean 1 median 1 q1 1 q3 1 sstdev 1"

# alias icemon="icemon -s 192.168.150.185"

# alias restart_icecream="sudo systemctl restart icecream"

# alias ls="lsd --group-dirs=first --icon=never"

# alias diff="colordiff -u"

# alias clang-ast-dump="clang -cc1 -ast-dump"

#--------------------------
#---       heroku       ---
#-------------------------

alias hk="heroku"
alias hkl="heroku local web"

# CHECK SYSTEM INFORMATION
# display free memory / linux `free` equiv https://superuser.com/questions/521681/what-is-the-mac-osx-equivalent-of-free-m
# make equivalents for linux: dmidecode # lshw # hwinfo # lscpu # lspci # /proc/cpuinfo
function freem() {
  if is-mac; then
    echo $(($(sysctl -a | awk '/memsize/{print $2}') / 2 ** 30))
  else
    echo "freem only supported on macos.."
  fi
}
#

# fi
