# https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/osx/osx.plugin.zsh
#
#
# TODO: move these to DCAs
#
#
alias lmk="say 'Process complete.'"
alias showfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Recursively clean files
alias cleands="find . -name '.DS_Store' -depth -exec rm {} \;"

# Canonical hex dump; some systems have this symlinked
command -v hd > /dev/null || alias hd="hexdump -C"
