#!/usr/bin/env bash
# shellcheck disable=2034,1091
# use inline `export VAR=...` statements, for fish compatibility`

export DOROTHY_THEME="starship"

# load defaultn
source "$DOROTHY/config/interactive.bash"

# load cross shell `sh` files
source "$DOROTHY/user/config/interactive.sh"

for f in "$DOROTHY/user/sources/"*.bash; do

  # do not load sources prefixed with underscore
  if [[ "$f" == _* ]]; then
    continue
  fi

  source "$f"
done
