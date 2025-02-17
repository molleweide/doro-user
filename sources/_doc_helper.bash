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
	local item option_format='' option_trim='no' option_use_colors='no' option_func_name_as_title='no'
	while [[ $# -ne 0 ]]; do
		item="$1"
		shift
		case "$item" in
		'--help' | '-h') help ;;
		'--format='*) option_format="${item#*=}" ;;
		'--trim') option_trim='yes' ;;
		'--colors') option_use_colors='yes' ;;
		'--func-header') option_func_name_as_title='yes' ;;
		*) help "An unrecognised arg/flag was provided: $item" ;;
		esac
	done

	# =======================================================
	# COLLECT INFORMATION

	local function_names=() function_bodies=()

	mapfile -t function_names < <(get-definitions)

	local body
	for function_name in "${function_names[@]}"; do

		# echo ============================================

		result_label="$(declare -f "$function_name")"

		if [[ "$option_trim" == 'yes' ]]; then
			result_label="$(__print_lines "$result_label" | sed '1,2d; $d')"
		fi

		if [[ "$option_use_colors" == 'yes' ]]; then
			result_label="$(__print_lines "$result_label" | bat --style plain --color always --language bash --paging=never)"
		fi

		if [[ "$option_func_name_as_title" == 'yes' ]]; then
			# function_label="$(bat --style plain --color always --language bash --paging=never \
			# 	<<<"$function_description"$'\n'"$function_code")"
			local name_formatted
			name_formatted="${function_name//_/ }"
			name_formatted="${name_formatted^}"
			result_label="$name_formatted"$'\n'"$result_label"
		fi

		# echo "$result_label"
		function_bodies+=("$result_label"$'\n')

		# if [[ "$option_format" == "inner" ]]; then
		# 	function_bodies+=("$(declare -f "$function_name" | sed '1,2d; $d' |
		# 		bat --style plain --color always --language bash --paging=never)")
		# elif [[ "$option_format" == "new" ]]; then
		# 	:
		# else
		# 	function_bodies+=("$(declare -f "$function_name")")
		# fi

	done

	# exit

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
