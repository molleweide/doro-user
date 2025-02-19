# TEST: Re-use the same choose command loaded without having to re-initialize
# it every time, since it takes a bit of time??

# Add neovim dorothy binds/utils for adding and running in a new term.
# Eg. - run selected line/chunk in terminal and open it.
# ---
# Todo: Use doc_helper for the interactive bash man pages documentation file.


# TODO:
#       [ ] Put eval output above result entries in next choose iteration
#           - concat output to the next title.
#           - use --truncate-body
#       ===
#       [ ] prefix description with the FUNC_BODY indices, so that you can
#            visually see which number you were running.
#            - This requires injecting the index intelligently into:
#               ~ handle if func_name_format
#               ~ handle if has_description
#               ~~ alt 1: maybe if func_name_format -> prefix with # and add index after??
#               ~~ alt 2: put index before and indend the desc.
#               ~~ easiest: ( ) just inject index before
#       ===
#       [*] run all in seq
#       [ ] run print all and close
#       [ ] run doc-helper standalone -> fire up main browser.
#       ===
#       [ ] Run the meta selections in its own choose menu
#           - allow for flipping back and forth between the menu and the test cases.
#       ===
#       [ ] Load multiple doc tests at once. Create a large choosee menu.
#           This could be nice to do with --fzf.

function doc_helper() {
	source "$DOROTHY/sources/bash.bash"
	__require_array 'mapfile'

	local \
		THIS_NAME="[doc_helper]" \
		DIR_DOC_TESTS="$DOROTHY/user/commands.tests" \
		doc_test_caller_path \
		caller_path_dirname \
		caller_basename \
		doc_helper_title_prefix="DOC HELPER"

	doc_test_caller_path="${BASH_SOURCE[1]}"
	caller_path_dirname="$(basename "$(dirname "$doc_test_caller_path")")"
	caller_basename="$(basename "$doc_test_caller_path")"

	# =======================================================
	# Arguments

	function help {
		cat <<-EOF >/dev/stderr
			ABOUT:
			Define test functions in a file and source run $THIS_NAME on last line.
			Optionally you can define a description function that returns a string
			before its respective test function suffixed with $(__description)
			Put all your doc tests in [commands.tests/*]

			Can be run as a standalone command.

			USAGE:
			(inside my_doc_test file)
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
	local item option_debug='no' option_trim_fn_body='no' option_use_colors='no' option_func_name_as_title='no' option_lang_hl='markdown'

	# If no args supplied, then fallthrough to `main menu` below
	while [[ $# -ne 0 ]]; do
		item="$1"
		shift
		case "$item" in
		'--help' | '-h') help ;;
		# trim if you want to only show code contents
		'--trim') option_trim_fn_body='yes' ;;
		'--colors') option_use_colors='yes' ;;
		'--func-header') option_func_name_as_title='yes' ;;
		# specify what syntax highliht to use for the descriptionn
		'--desc-hl='*) option_lang_hl="${item#*=}" ;;
		'--only-func-names') ;; # Only list function-names-formatted
		'--debug') option_debug='yes' ;;
		'--'*) help "An unrecognised arg/flag was provided: $item" ;;
		*) help "An unrecognised arg/flag was provided: $item" ;;
		esac
	done

	# =====================================================================
	# =====================================================================
	# =====================================================================
	# helpers

	function eval_code() {
		local func_name="$1" target_code="$2" _setup_fn_bodies=() capture_results=()
		local eval_string divider="# ============================================"
		eval_string="$divider"$'\n'"# $doc_helper_title_prefix: eval string [$func_name]"$'\n'
		for f in "${setup_ids[@]}"; do
			local fn
			fn="$(declare -f "$f")"
			eval_string="$eval_string$fn"$'\n'
		done
		eval_string="$eval_string# FUNC NAME = [$func_name]"$'\n'
		eval_string="$eval_string"$'\n'"$target_code"$'\n'"$divider"
		# __print_lines "$eval_string"

		# NOTE:
		# 1. Need to pull latest w/support for -c
		#     debug-bash -- -c "$eval_string"
		#     debug-bash -- -c "$code" -- $args # debug-bash needs to be updated to
		#     support the -c option, then this would run the code against all bash
		#     versions on this machine
		# 2. Need to use eval_capture so that we can obtain the exit status.
		# 3. Evaluate whether the code accepts arguments.
		# 	    args="$(ask --linger 'Arguments to pass to the code?')"
		local capture_results="$(bash -c "$eval_string")"

		local output_header="CAPTURED OUTPUT: ($func_name)"
		echo-style --h1 "$output_header"
		echo "last status: $?"
		__print_lines "${capture_results[@]}"
		echo-style --g1 "${output_header//?/ }"

		# debug-bash --
	}

	# =======================================================
	# UI META FUNCTIONS

	function run__refresh_test_cases {
		# setup background watcher that checks current targets for changes and
		# updates the content variables??
		todo try refresh test cases.
		# Shouldn't this be possible if i just resource??

		# TODO:
		# re-run current executing command..
	}

	function run__doc_browser_main {
		# NOTE: Using get-definitions and declare -f in subsequent runs of a dot test
		# seems to work. QUESTION: Does this increase memory load for each run?
		# Should we use `exec` or `env` to reset the environment?

		local doc_test_commands=() selected_test_doc
		local title="$doc_helper_title_prefix | MAIN BROWSER: Select which [doc test]"
		mapfile -t doc_test_commands < <(find "$DIR_DOC_TESTS" -type f -maxdepth 1)
		selected_test_doc="$(choose-path --required --question="$title" -- "${doc_test_commands[@]}")"
		"$selected_test_doc"
	}

	function run__all_current {
		echo todo run all current
		for i in "${FUNCTION_BODIES[@]}"; do
			eval_code "$i"
		done
	}

	function run__print_all_and_exit {
		echo todo print all and exit
		for i in "${FUNCTION_BODIES[@]}"; do
			eval_code "$i"
		done
		exit
	}

	# =====================================================================
	# =====================================================================
	# =====================================================================

	# =======================================================
	# SETUP SPECIAL UI ALTERNATIVES

	# TODO: How do we handle these menu entries when using choose index instead of labels.

	local META_FUNCS=(
		run__refresh_test_cases
		run__doc_browser_main
		run__all_current
		run__print_all_and_exit
	)
	local META_LABELS=(
		"[Reload alternatives - Is this possible somehow?]"
		"[Browse all test files]"
		"[Run all tests sequentially]"
		"[Print all test contents to tty and close]"
	)
	local META_FUNCS_COUNT="${#META_LABELS[@]}"

	local RESULT_LABELS=(
	)

	# =======================================================
	# COLLECT INFORMATION

	local \
		parsed_function_IDs=() \
		finalized_function_labels=() \
		code_funcs_count=0 \
		code_func_names=() \
		FUNCTION_BODIES=() \
		FUNCTION_LABELS=() \
		DOC_TEST_NAME="$caller_path_dirname/$caller_basename"

	mapfile -t parsed_function_IDs < <(get-definitions)

	if [[ "$option_debug" == 'yes' ]]; then
		echo
		echo
		echo ============================================
		echo "DEBUG START"
		echo "CALLER PATH: $doc_test_caller_path"
		echo
		echo -- ids --
		__print_lines "${parsed_function_IDs[@]}"
	fi

	# =======================================================
	# CAPTURE _SETUP FUNCTIONS

	local setup_ids=() FUNC_GET_IDS=() FUNC_NAMES=()

	# filter out all _setup funcs and put the real funcs
	# in a new array.
	for item in "${parsed_function_IDs[@]}"; do
		if [[ "$item" == _* ]]; then
			setup_ids+=("$item")
		else
			FUNC_GET_IDS+=("$item")
		fi
	done

	# =======================================================
	# PREPARE TEST CASE FUNCTIONS

	local has_description='no'
	for function_name in "${FUNC_GET_IDS[@]}"; do
		local fn_name fn_body fn_body_trimmed fn_code fn_descr
		local result_fn_code result_fn_desc result_final result_fn_formatted

		if [[ "$option_debug" == 'yes' ]]; then
			echo ============================================
		fi

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

		FUNC_NAMES+=("$fn_name")

		fn_body="$(declare -f "$function_name")"
		code_funcs_count=$((code_funcs_count + 1))
		code_func_names+=("$fn_name")

		if [[ "$option_debug" == 'yes' ]]; then
			echo "fn_name: [$fn_name], "
		fi

		# ---------
		# process results code

		result_fn_code=$(__print_lines "$fn_body")
		fn_body_trimmed=$(__print_lines "$result_fn_code" | sed '1,2d; $d')
		FUNCTION_BODIES+=("$fn_body_trimmed")

		# Either display the full function or the trimmed version.
		if [[ "$option_trim_fn_body" == 'yes' ]]; then
			result_fn_code="$fn_body_trimmed"
		fi

		# Apply code syntax highlight
		if [[ "$option_use_colors" == 'yes' ]]; then
			result_fn_code="$(__print_lines "$result_fn_code" | bat --style plain --color always --language bash --paging=never)"
		fi

		# ---------
		# Process description

		# If __desc func exists then use it, otherwise default to the func name.
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

		result_final="$result_fn_desc"$'\n'"$result_fn_code"$'\n'
		# finalized_function_labels+=("$result_final")
		FUNCTION_LABELS+=("$result_final")

		if [[ "$option_debug" == 'yes' ]]; then
			__print_lines "${result_final[@]}"
		fi

		has_description='no'
	done

	if [[ "$option_debug" == 'yes' ]]; then
		echo ============================================
		echo "DEBUG ENDED"
	fi

	# # NOTE: This is only used currently when we dont use INDEX with choose.
	# # This should be removed.
	# for index in "${!code_func_names[@]}"; do
	# 	RESULT_LABELS+=("${code_func_names[index]}" "${finalized_function_labels[index]}")
	# done

	# Use this for choose index
	for item in "${META_LABELS[@]}"; do
		RESULT_LABELS+=("$item")
	done
	for item in "${FUNCTION_LABELS[@]}"; do
		RESULT_LABELS+=("$item")
	done

	# # debug result labels
	# for elem in "${RESULT_LABELS[@]}"; do
	# 	__print_lines "$elem"
	# done
	# exit

	# local RESULT_LABELS_COUNT="${#RESULT_LABELS[@]}"
	# local FUNCTION_BODIES_COUNT=${#FUNCTION_BODIES[@]}

	# =====================================================================
	# =====================================================================
	# =====================================================================

	# =======================================================
	# SETUP UI

	# FIX: choose support start index without shifting tty?

	local sel='' is_meta='no' selected_fn_name='' index="$((${#META_LABELS[@]}))"
	local choose_title="$doc_helper_title_prefix: Select [$DOC_TEST_NAME]"
	while :; do
		index="$(
			choose "$choose_title" --default="$index" \
				--match='$INDEX' --index -- "${RESULT_LABELS[@]}"
		)"

		local index_pre=$index

		if [[ "$index" -lt "$META_FUNCS_COUNT" ]]; then
			break
		else
			index=$((index - (META_FUNCS_COUNT)))
			eval_code "${FUNC_NAMES[$index]}" "${FUNCTION_BODIES[$index]}"
			if ! confirm --ppid=$$ --positive -- 'Prompt again?'; then
				break
			fi
			if ((index == ${#FUNCTION_BODIES[@]} - 1)); then
				index="$((${#META_LABELS[@]}))"
			else
				index=$((index_pre + 1))
			fi
		fi
	done

	# Broke out of while loop to call meta funcs
	# !! For some meta funcs we might want to stay in the while loop
	# >> check conditionally based on the meta func if we want to break or not
	"${META_FUNCS[$index]}"

}
