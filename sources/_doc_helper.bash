#
#
#
#
#
#
#

# HACK: skiss on the call structure for the interactive UI
# dochelper = *
# ~ Run test file | sources *
#   ~ Call doc_helper on executed script.
#     ~ A. Play w test cases
#     ---
#     ~ B. Run main-browser (**)
#       ~ Call choose on DOC dir paths.
#         ~ Select path and run
#           ~ Calls doc_helper again.
#                     ? Now what ids will get-definitions collect???
#                     Options: Maybe use exec to replace the environment??
#                     arst
# ~ doc-helper standalone
#   ~ call (**)
#
#

# Add neovim dorothy binds/utils for adding and running in a new term.
# Eg. - run selected line/chunk in terminal and open it.
# ---
# Todo: Use doc_helper for the interactive bash man pages documentation file.
#
# TEST: [ ] move this to a standalone command where we avoid (subshell) syntax.
#           In commands.test
#       [ ] Run doc helper on multiple test files at once? All even?
#
# TODO: [*] jump back to main browser.
#           - decide where to put test files -> commands.tests
#           -
#       [ ] run all in seq
#       [ ] run print all and close
#       [ ] capture output fs-rm style.

# FIX: capture commands that fail

function doc_helper() {
	source "$DOROTHY/sources/bash.bash"
	__require_array 'mapfile'

	local \
		THIS_NAME="doc_helper" \
		DIR_DOC_TESTS="$DOROTHY/user/commands.tests"

	# =======================================================
	# Arguments

	function help {
		cat <<-EOF >/dev/stderr
			ABOUT:
			xxx
			Define test functions in a file and source run $THIS_NAME on last line.
			Optionally you can define a description function that returns a string
			before its respective test function suffixed with $(__description)

			USAGE:
			...
			function test__desc() {...)
			function test() {...}
			...
			  $THIS_NAME

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
		# '--format='*) option_format="${item#*=}" ;;
		# trim if you want to only show code contents
		'--trim') option_trim='yes' ;;
		'--colors') option_use_colors='yes' ;;
		'--func-header') option_func_name_as_title='yes' ;;
		# specify what syntax highliht to use for the descriptionn
		'--desc-hl='*) option_lang_hl="${item#*=}" ;;
		'--only-func-names') ;; # Only list function-names-formatted
		*) help "An unrecognised arg/flag was provided: $item" ;;
		esac
	done

	# =====================================================================
	# =====================================================================
	# =====================================================================

	# =======================================================
	# UI HELPERS

	# WARN: will these be picked up by declare -f.

	function run__refresh_test_cases {
		# setup background watcher that checks current targets for changes and
		# updates the content variables??
		todo try refresh test cases.
	}
	function run__doc_browser_main {
		echo todo doc browser main
		#
		local doc_test_commands=()
		mapfile -t doc_test_commands < <(find "$DIR_DOC_TESTS" -type f -maxdepth 1)
		# __print_lines "${doc_test_commands[@]}"
		choose-path --required --question="Select which [doc test]" -- "${doc_test_commands[@]}"
	}
	function run__all_current {
		echo todo run all current
	}
	function run__print_all_and_exit {
		echo todo print all and exit
	}

	# =====================================================================
	# =====================================================================
	# =====================================================================

	# =======================================================
	# SETUP SPECIAL UI ALTERNATIVES

	# TODO: handle this when computing indices??

	local results_mapped=(
		_refresh "[Reload alternatives - Is this possible somehow?]"
		_browse_all "[Browse all test files]"
		_run_all_current "[Run all tests sequentially]"
		_print_and_exit "[Print all test contents to tty and close]"
	)

	# =======================================================
	# COLLECT INFORMATION

	local \
		parsed_function_IDs=() \
		finalized_function_labels=() \
		code_funcs_count=0 \
		code_func_names=()

	mapfile -t parsed_function_IDs < <(get-definitions)
	# __print_lines "${parsed_function_IDs[@]}"

	local has_description='no'
	for function_name in "${parsed_function_IDs[@]}"; do
		local fn_name fn_body fn_code fn_descr
		local result_fn_code result_fn_desc result_final result_fn_formatted

		# echo ============================================

		# ---------
		# prepare names and description

		fn_name="$function_name"
		if [[ "$function_name" == *__* ]]; then
			fn_name="${function_name%__*}" # handle name__code case
		fi
		# check function is a __description
		if [[ "$function_name" == *'__description' || "$function_name" == *'__desc' ]]; then
			has_description='yes'
			continue
		fi
		fn_body="$(declare -f "$function_name")"
		code_funcs_count=$((code_funcs_count + 1))
		code_func_names+=("$fn_name")

		# ---------
		# process results code
		# TODO: Options to transform [CODE] contents
		# [ ] xx

		# results trim code
		if [[ "$option_trim" == 'yes' ]]; then
			result_fn_code="$(__print_lines "$fn_body" | sed '1,2d; $d')"
		fi
		# results code colors
		if [[ "$option_use_colors" == 'yes' ]]; then
			result_fn_code="$(__print_lines "$result_fn_code" | bat --style plain --color always --language bash --paging=never)"
		fi

		# ---------
		# process results description
		# TODO: Options to transform [DESCRIPTION] contents
		# [ ] xx

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

		# ---------
		# concat data

		# TODO: Options to transform final results.
		# [ ] add prefixes / suffixes?

		result_final="$result_fn_desc"$'\n'"$result_fn_code"
		finalized_function_labels+=("$result_final"$'\n')
		# echo "$result_final"

		has_description='no'
	done

	# echo ====
	# echo "cound code funcs: $code_funcs_count"
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

	# =====================================================================
	# =====================================================================
	# =====================================================================

	# =======================================================
	# SETUP UI
	#
	# TODO: UI
	# [ ] If choose is run once, then properly display the `code` above the output.
	# [ ] Capture the output of selected function and display it above the choose
	#       menu in the next iteration.
	#       - see fs-rm . display on top
	# [ ] ASK: how can we check if the function takes arguments?
	#     - Parse the code chunk and check for `[ $N|--*|--|.. ]`

	local sel is_meta='no' selected_fn_name

	while :; do

		# =================
		# setup choose
		#
		# ! If we use index, then we need to store all code chunks in an array so that
		# and obtain in by the index output of choose.

		sel="$(choose --required --linger 'Which function to execute?' --label -- "${results_mapped[@]}")"
		# 	# NOTE: match index is not on my local clone...
		# 	# index="$(choose --linger 'Which code to execute?' --default="$index" --match='$INDEX' --index -- "${function_labels[@]}")"
		# 	index="$(choose --linger 'Which code to execute?' --index -- "${function_labels[@]}")"

		# Handle selections

		if [[ "$sel" == _* ]]; then
			# meta option, eg. go-to-main; print-and-close; ..
			is_meta='yes'
			break

		else
			# runnable code
			selected_fn_name="$sel"

			echo "selected_fn_name: $selected_fn_name"

			# TODO: [ ] check if takes args.

			# # args="$(ask --linger 'Arguments to pass to the function?')"
			local output_header="output from [$selected_fn_name]"
			echo-style --h1 "$output_header"
			$selected_fn_name # $args
			echo-style --g1 "${output_header//?/ }"

		# # index=0 #
		# 	args="$(ask --linger 'Arguments to pass to the code?')"
		# 	code="${function_codes[index]}"
		# 	# debug-bash -- -c "$code" -- $args # debug-bash needs to be updated to support the -c option, then this would run the code against all bash versions on this machine
		# 	if ! confirm --ppid=$$ --positive -- 'Prompt again?'; then
		# 		break
		# 	fi
		# 	# if [[ $index -eq ${#function_labels[@]} ]]; then
		# 	# 	index=0
		# 	# else
		# 	# 	index=$((index + 1))
		# 	# fi
		fi
	done

	# =====

	if [[ "$is_meta" == 'yes' ]]; then
		function handle_meta_selections() {
			case "$1" in
			_browse_all) run__doc_browser_main ;;
			_print_and_exit) run__print_all_and_exit ;;
			_run_all_current) run__all_current ;; # NOTE: will this work with `ask`??
			# '--format='*) option_format="${item#*=}" ;;
			# '--trim') option_trim='yes' ;;
			# '--colors') option_use_colors='yes' ;;
			# '--func-header') option_func_name_as_title='yes' ;;
			# '--desc-hl='*) option_lang_hl="${item#*=}" ;;
			# '--only-func-names') ;; # Only list function-names-formatted
			esac
		}
		handle_meta_selections "$sel"
	fi

	# ============================================

}
