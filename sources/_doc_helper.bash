# Add neovim dorothy binds/utils for adding and running in a new term.
# Eg. - run selected line/chunk in terminal and open it.
# ---
# Todo: Use doc_helper for the interactive bash man pages documentation file.

# TODO:
#       ===
#       ( ) options:
#           - ( ) only print capture output
#           - (x) only concat to next title
#           - ( ) both
#       ===
#       ( ) prefix description with the FUNC_BODY indices, so that you can
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
#       ====
#       ( ) support chunking up the test file instead of having to define func names
#       and description.
#       >> this could make some things a lot easier.
#       >>>>> will need to check if the target file hosts FUNCS or CHUNKS
#             Use: IFS="========" read -ra sections <<< "$input"
#             ^ each chunk will now be a multiline string.
#       ====
#       ( ) CONTINUOUS CHOOSE MENU - VERY ADVANCED
#

function doc_helper() {
	source "$DOROTHY/sources/bash.bash"
	__require_array 'mapfile'

	local \
		THIS_NAME="[doc_helper]" \
		DIR_DOC_TESTS="$DOROTHY/user/commands.tests" \
		PREV_EVAL_OUTPUT='' \
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
		for f in "${SETUP_FUNC_IDS[@]}"; do
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

		function get_output() {
			local capture_status capture_results

			# direct eval
			capture_results="$(bash -c "$eval_string")"
			capture_status=$?

			# # eval capture
			# eval_capture --statusvar=capture_status --stdoutvar=capture_results -- bash -c "$eval_string"

			# local capture_results="$(eval_capture -- bash -c "$eval_string")"

			local output_header="PREVIOUS OUTPUT: ($func_name)"
			echo-style --h1 "$output_header"
			echo "Capture status: $capture_status, capture stdout:"
			__print_lines "${capture_results[@]}"
			# echo "-------------------------------------------------------"
			# echo-style --g1 "${output_header//?/ }"
		}

		PREV_EVAL_OUTPUT="$(get_output)"

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
		# 1. obtain the command name
		# 2. run the command
	}

	function run__doc_browser_main_menu {
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

	# =======================================================
	# SETUP META UI ALTERNATIVES

	local META_FUNCS=(
		run__refresh_test_cases
		run__doc_browser_main_menu
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

	local RESULT_LABELS=()

	if [[ "$option_debug" == 'yes' ]]; then
		echo
		echo
		echo ============================================
		echo "DEBUG START"
		echo "CALLER PATH: $doc_test_caller_path"
		echo
	fi

	# Standalone defaults to running the main menu.
	if [[ "$caller_basename" == "doc-helper" ]]; then
		run__doc_browser_main_menu
	fi

	# =======================================================
	# COLLECT INFORMATION

	local \
		parsed_function_IDs=() \
		code_funcs_count=0 \
		code_func_names=() \
		FUNCTION_BODIES=() \
		FUNCTION_LABELS=() \
		DOC_TEST_NAME="$caller_path_dirname/$caller_basename"

	mapfile -t parsed_function_IDs < <(get-definitions)

	# =======================================================
	# CAPTURE _SETUP FUNCTIONS

	local SETUP_FUNC_IDS=() FUNC_GET_IDS=() FUNC_NAMES=()

	if [[ "$option_debug" == 'yes' ]]; then
		echo -- ids --
		__print_lines "${parsed_function_IDs[@]}"
	fi

	# TODO: try doing this in a one-liner by using echo-regex.
	for item in "${parsed_function_IDs[@]}"; do
		if [[ "$item" == _* ]]; then
			SETUP_FUNC_IDS+=("$item")
		else
			FUNC_GET_IDS+=("$item")
		fi
	done

	# =======================================================
	# PREPARE TEST CASE FUNCTIONS

	local has_description='no'
	for function_name in "${FUNC_GET_IDS[@]}"; do
		local fn_name fn_body fn_body_trimmed
		local result_fn_code result_fn_desc result_final

		if [[ "$option_debug" == 'yes' ]]; then
			echo ============================================
		fi

		# ---------
		# Prepare names and description

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
		# Process results code

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

		# DESCRIPTION: If __desc func exists then use it, otherwise default to the func name.
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

		# concat data
		result_final="$result_fn_desc"$'\n'"$result_fn_code"$'\n'
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

	# =======================================================
	# Merge all labels

	if [[ "${#FUNCTION_LABELS}" -gt 0 ]]; then
		mapfile -t -d '' RESULT_LABELS < <(printf "%s\0" "${META_LABELS[@]}" "${FUNCTION_LABELS[@]}")
	else
	  __print_lines "No test functions were found. Exiting.."
	fi

	# =======================================================
	# SETUP UI

	# - (*) Move choose options to its own array
	# - ( ) use BOTH underline AND overline for choose main title, so that it is
	#       - specifically underline LAST TWO lines.
	#         Is it possible to disable underline across the whole title?
	# ===
	#       clearly separated from the previous code output.
	# - ( ) choose support start index without shifting tty?
	# - ( ) --truncate-body???

	local index="$((${#META_LABELS[@]}))" choose_title='' index_before_shifting
	while :; do
		if [[ -z "$PREV_EVAL_OUTPUT" ]]; then
			choose_title="$doc_helper_title_prefix: Select [$DOC_TEST_NAME]"
		else
			choose_title="$PREV_EVAL_OUTPUT"$'\n'"$doc_helper_title_prefix: Select [$DOC_TEST_NAME]"
		fi
		index="$(choose "$choose_title" --default="$index" --match='$INDEX' --index -- "${RESULT_LABELS[@]}")"
		index_before_shifting=$index
		if [[ "$index" -lt "$META_FUNCS_COUNT" ]]; then
			break
		else
			index=$((index - (META_FUNCS_COUNT)))
			eval_code "${FUNC_NAMES[$index]}" "${FUNCTION_BODIES[$index]}"
			# if ! confirm --ppid=$$ --positive -- 'Prompt again?'; then
			# 	break
			# fi
			if ((index == ${#FUNCTION_BODIES[@]} - 1)); then
				index="$((${#META_LABELS[@]}))"
			else
				index=$((index_before_shifting + 1))
			fi
		fi
	done

	"${META_FUNCS[$index]}"
}
