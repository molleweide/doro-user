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
# [ ] Capture the output of selected function and display it above the choose
#       menu in the next iteration.
# [ ] option_select: Add entry to run all tests if possible? in sequence?
# [ ] option_select: Simply print out all cases to stdout
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
	local item option_format='' option_trim='no' option_use_colors='no' option_func_name_as_title='no' option_lang_hl='markdown'
	while [[ $# -ne 0 ]]; do
		item="$1"
		shift
		case "$item" in
		'--help' | '-h') help ;;
		'--format='*) option_format="${item#*=}" ;;
		'--trim') option_trim='yes' ;;
		'--colors') option_use_colors='yes' ;;
		'--func-header') option_func_name_as_title='yes' ;;
		'--desc-hl='*) option_lang_hl="${item#*=}" ;;
		'--only-func-names') ;; # Only list function-names-formatted
		*) help "An unrecognised arg/flag was provided: $item" ;;
		esac
	done

	# =======================================================
	# COLLECT INFORMATION

	local parsed_function_IDs=() finalized_function_labels=() results_mapped=()
	local code_func_names=() count_code_funcs=0

	mapfile -t parsed_function_IDs < <(get-definitions)

	# __print_lines "${parsed_function_IDs[@]}"

	local has_description='no'
	for function_name in "${parsed_function_IDs[@]}"; do
		local fn_name fn_body fn_code fn_descr
		local result_fn_code result_fn_desc result_final result_fn_formatted

		# echo ============================================

		# ---------------------------------
		# prepare names and description

		fn_name="$function_name"
		if [[ "$function_name" == *__* ]]; then
			fn_name="${function_name%__*}" # handle name__code case
		fi
		# check function is a __description
		if [[ "$function_name" == *'__description' ]]; then
			has_description='yes'
			continue
		fi
		fn_body="$(declare -f "$function_name")"
		count_code_funcs=$((count_code_funcs + 1))
		code_func_names+=("$fn_name")

		# ---------------------------------
		# process results code

		# results trim code
		if [[ "$option_trim" == 'yes' ]]; then
			result_fn_code="$(__print_lines "$fn_body" | sed '1,2d; $d')"
		fi
		# results code colors
		if [[ "$option_use_colors" == 'yes' ]]; then
			result_fn_code="$(__print_lines "$result_fn_code" | bat --style plain --color always --language bash --paging=never)"
		fi

		# ---------------------------------
		# process results description

		if [[ "$option_func_name_as_title" == 'yes' || "$has_description" != 'yes' ]]; then
			# no description
			result_fn_desc="${function_name//_/ }"
			result_fn_desc="${result_fn_desc^}"
		else
			result_fn_desc="$("${fn_name}__description")"
			if [[ "$option_use_colors" == 'yes' ]]; then
				result_fn_desc="$(bat --style plain --color always --language markdown --paging=never <<<"$result_fn_desc")"
			fi
		fi

		# ---------------------------------
		# concat data

		result_final="$result_fn_desc"$'\n'"$result_fn_code"
		finalized_function_labels+=("$result_final"$'\n')
		# echo "$result_final"

		has_description='no'
	done

	# echo ====
	# echo "cound code funcs: $count_code_funcs"
	# echo "#code_func_names: ${#code_func_names[@]}"
	# echo =====

	for index in "${!code_func_names[@]}"; do
	  # echo "${code_func_names[index]}"
	  # echo ""
		results_mapped+=("${code_func_names[index]}" "${finalized_function_labels[index]}")
	done

	# exit

	# # LOG DATA
	# for elem in "${results_mapped[@]}"; do
	# 	echo "$elem"
	# done

	# ============================================
	# SETUP UI

	selected_fn_name="$(choose --required --linger 'Which function to execute?' --label -- "${results_mapped[@]}")"

	echo "selected_fn_name: $selected_fn_name"

	# # args="$(ask --linger 'Arguments to pass to the function?')"
	local output_header="output from [$selected_fn_name]"
	echo-style --h1 "$output_header"
	$selected_fn_name # $args
	echo-style --g1 "${output_header//?/ }"

	# ============================================

}
