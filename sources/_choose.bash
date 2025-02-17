function test_choose() {
  source "$DOROTHY/sources/bash.bash"

	__require_array 'mapfile'

	local data=()
	mapfile -t data < <(find ~/.config/dorothy -type f -maxdepth 1)

	__print_lines "${data[@]}"

	choose-path --required --question="Test run choose from script?" -- "${data[@]}"
}
# find /usr/bin -type f
