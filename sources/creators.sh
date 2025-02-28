
function __reload_env {
  source "$DOROTHY/sources/environment.sh"
}

function aliases {
  aliases-helper "$@" || __reload_env
}

function new {
  dorothy-new "$@" || __reload_env
}
