# TEST: Can this script be used as a middleman just to ensure that FZF
# closes properly?

LOG_FILE="$DOROTHY/user/fzf_log.txt"

# Calling script with multiple args.
open_in_browser() {

  # echo "???????"
  echo "open in browser" >"$LOG_FILE"

  # TODO: Getting the data below should go into a dorothy command.

  # This is only when the scripting is initiating on shell load.
  # maybe should unset the vars instead. ??? What did i mean by this?!?!
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [[ $branch = HEAD ]]; then
    branch=$(git describe --exact-match --tags 2>/dev/null || git rev-parse --short HEAD)
  fi

  # Only supports GitHub for now
  case "$1" in
  commit)
    hash=$(grep -o "[a-f0-9]\{7,\}" <<<"$2")
    path=/commit/$hash
    ;;
  branch | remote-branch)
    branch=$(sed 's/^[* ]*//' <<<"$2" | cut -d' ' -f1)
    remote=$(git config branch."${branch}".remote || echo 'origin')
    branch=${branch#$remote/}
    path=/tree/$branch
    ;;
  remote)
    remote=$2
    path=/tree/$branch
    ;;
  file) path=/blob/$branch/$(git rev-parse --show-prefix)$2 ;;
  tag) path=/releases/tag/$2 ;;
  *) exit 1 ;;
  esac

  remote=${remote:-$(git config branch."${branch}".remote || echo 'origin')}
  remote_url=$(git remote get-url "$remote" 2>/dev/null || echo "$remote")

  if [[ $remote_url =~ ^git@ ]]; then
    url=${remote_url%.git}
    url=${url#git@}
    url=https://${url/://}
  elif [[ $remote_url =~ ^http ]]; then
    url=${remote_url%.git}
  fi

  exit 0

  # TODO: This should be a dorothy command!
  case "$(uname -s)" in
  Darwin) open "$url$path" ;;
  *) xdg-open "$url$path" ;;
  esac

  exit 0
}
