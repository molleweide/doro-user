#
# TODO: move this to a standalone command where we avoid (subshell) syntax.
#
# TODO: ARGS
# [ ] Use entry title
#     - based on func name?
#     - based on defined heredocs?
# [ ] How to format fn/code body
#     - full func
#     - trim surroundings
#     - [ ] CODE VS DESCRIPTION
#         ~ only descriptions need the `__|__desc` suffix, right?
#             check if index - 1 contains __desc
#         ~ descr is assumed to come before `code`
#         ~ use rg to capture comments above each function.
# [ ]
# [ ]
#
#
# TODO: UI
# [ ] If choose is run once, then properly display the `code` above the output.
# [ ] capture the output of selected function and display it above the choose
# menu in the next iteration.
# [ ] ASK: how can we check if the function takes arguments?
#

function doc_helper() {
	source "$DOROTHY/sources/bash.bash"

	# =======================================================
	# arguments

	function help {
		cat <<-EOF >/dev/stderr
			ABOUT:
			xxx

			USAGE:
			xxx

			OPTIONS:
			xxx

		EOF
		if [[ $# -ne 0 ]]; then
			echo-error "$@"
		fi
		return 22 # EINVAL 22 Invalid argument
	}

	# process
	local item option_format=''
	while [[ $# -ne 0 ]]; do
		item="$1"
		shift
		case "$item" in
		'--help' | '-h') help ;;
		'--format='*) option_format="${item#*=}" ;;
		# '--global') option_flags+='g' ;;
		# '--ignore-case') option_flags+='i' ;;
		# # currently just default to echo-regexp
		# '--echo-regexp') option_echo_regexp='yes' ;;
		# '--contents') option_get_func_contsents='yes' ;;
		# '--target-func='*) option_target_func="${item#*=}" ;;
		'--')
			option_inputs+=("$@")
			shift $#
			break
			;;
		*) option_args+=("$item") ;;
		esac
	done

	# =======================================================
	# COLLECT INFORMATION

	local function_names=() function_bodies=()

	mapfile -t function_names < <(get-definitions)

	for function_name in "${function_names[@]}"; do
		if [[ "$option_format" == "inner" ]]; then
			function_bodies+=("$(declare -f "$function_name" | sed '1,2d; $d' | bat --style plain --color always --language bash --paging=never)")
		elif [[ "$option_format" == "new" ]]; then
		  :
		else
			function_bodies+=("$(declare -f "$function_name")")
		fi

	done

	# prepare data for choose
	function_names_with_bodies=()

  # WARN: fails because i havent handled the `new` formatting yet
	for index in "${!function_names[@]}"; do
		function_names_with_bodies+=("${function_names[index]}" "${function_bodies[index]}")
	done

	# # LOG DATA
	# for elem in "${function_names_with_bodies[@]}"; do
	# 	echo "$elem"
	# done

	# ============================================
	# SETUP UI

	selected_fn_name="$(choose --required --linger 'Which function to execute?' --label -- "${function_names_with_bodies[@]}")"

	echo "selected_fn_name: $selected_fn_name"

	# # args="$(ask --linger 'Arguments to pass to the function?')"
	local output_header="output from [$selected_fn_name]"
	echo-style --h1 "$output_header"
	$selected_fn_name # $args
	echo-style --g1 "${output_header//?/ }"

	# ============================================

}
