#
#
#
#
# TEST: Re-use the same choose command loaded without having to re-initialize
# it every time, since it takes a bit of time??
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

# TEST: [ ] move this to a standalone command where we avoid (subshell) syntax.
#           In commands.test
#       [ ] Run doc helper on multiple test files at once? All even?

# TODO:
#       [ ] choose return --index
#       [ ] collect _setup funcs.
#       [ ] eval code.
#           - pass code to debug-bash
#           - capture output.
#       [ ] capture output fs-rm style.
#           - truncate the output to only take up a maximum of N lines
#       ===
#       [*] run all in seq
#       [ ] run print all and close
#       [ ] run doc-helper standalone -> fire up main browser.
#       ===
#       [ ] Run the meta selections in its own choose menu
#           - allow for flipping back and forth between the menu and the test cases.
#       ===
#       ===
#       [ ] code evaluation
#           - trim func bodies if necessary
#           - check if code accepts arguments.
#       ===
#       [ ] Load multiple doc tests at once.

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
		local target_code="$1"
		# [ ] ASK: how can we check if the function takes arguments?
		#     - Parse the code chunk and check for `[ $N|--*|--|.. ]`
		# FIX: Capture/wrap test cases that fail
		local _setup_fn_bodies=()
		local eval_string="# $doc_helper_title_prefix: eval string"$'\n'
		for f in "${setup_ids[@]}"; do
			local fn
			fn="$(declare -f "$f")"
			eval_string="$eval_string$fn"$'\n'
		done
		eval_string="$eval_string"$'\n'"$target_code"

		__print_lines "$eval_string"

		# 	args="$(ask --linger 'Arguments to pass to the code?')"

		# debug-bash --
	}

	# =======================================================
	# UI META FUNCTIONS

	function run__refresh_test_cases {
		# setup background watcher that checks current targets for changes and
		# updates the content variables??
		todo try refresh test cases.
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
		finalized_function_labels+=("$result_final")
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

	local RESULT_LABELS_COUNT="${#RESULT_LABELS[@]}"
	local FUNCTION_BODIES_COUNT=${#FUNCTION_BODIES[@]}

	# =====================================================================
	# =====================================================================
	# =====================================================================

	# =======================================================
	# SETUP UI

	local sel='' is_meta='no' selected_fn_name='' index="$((${#META_LABELS[@]}))"
	local choose_title="$doc_helper_title_prefix: Select [$DOC_TEST_NAME]"
	while :; do

		# sel="$(choose --required --linger "$choose_title" --label -- "${RESULT_LABELS[@]}")"
		# 	# NOTE: match index is not on my local clone...

		# FIX: choose support start index without shifting tty
		index="$(
			choose --linger 'Which code to execute?' --default="$index" \
				--match='$INDEX' --index -- "${RESULT_LABELS[@]}"
		)"
		# 	index="$(choose --linger 'Which code to execute?' --index -- "${function_labels[@]}")"

		# __print_lines "Sel index -> $index" "# meta opts: ${#META_LABELS[@]}"
		local index_pre=$index

		if [[ "$index" -lt "$META_FUNCS_COUNT" ]]; then
			# echo "chose meta: $index -> ${META_FUNCS[$index]}"
			break
		else
			index=$((index - (META_FUNCS_COUNT)))

			echo "chose code: $index"
			echo "# func names: ${#FUNC_NAMES[@]}"
			echo "# func bodies: ${#FUNCTION_BODIES[@]}"

			# Run capture code
			local func_name="${FUNC_NAMES[$index]}"
			echo "selected_fn_name: $func_name"
			local output_header="output from [$func_name]"
			echo-style --h1 "$output_header"
			eval_code "${FUNCTION_BODIES[$index]}"
			echo-style --g1 "${output_header//?/ }"

			# # index=0 #
			# 	code="${function_codes[index]}"
			# 	# debug-bash -- -c "$code" -- $args # debug-bash needs to be updated to support the -c option, then this would run the code against all bash versions on this machine
			if ! confirm --ppid=$$ --positive -- 'Prompt again?'; then
				break
			fi

			echo " index | $((RESULT_LABELS_COUNT - 1))"

			# if [[ $index -eq ${#RESULT_LABELS[@]} ]]; then
			if (( index == FUNCTION_BODIES_COUNT - 1 )); then
			  echo "!!!!"
				index="$((${#META_LABELS[@]}))"
			else
				# 	index="$index"
				# else
				echo "???? $index"
				index=$((index_pre + 1))
			fi
		fi

		# 	# FIX: check if index is within META_ENTRIES range or not.
		#
		# 	# Handle selections
		# 	if [[ "$sel" == _* ]]; then
		# 		is_meta='yes'
		# 		break
		# 	else
		# 	fi
	done

	# Broke out of while loop to call meta funcs
	# !! For some meta funcs we might want to stay in the while loop
	# >> check conditionally based on the meta func if we want to break or not
	"${META_FUNCS[$index]}"

	#
	# # =====
	#
	# if [[ "$is_meta" == 'yes' ]]; then
	# 	function handle_meta_selections() {
	# 		case "$1" in
	# 		_browse_all) run__doc_browser_main ;;
	# 		_print_and_exit) run__print_all_and_exit ;;
	# 		_run_all_current) run__all_current ;; # NOTE: will this work with `ask`??
	# 		# '--format='*) option_format="${item#*=}" ;;
	# 		# '--trim') option_trim_fn_body='yes' ;;
	# 		# '--colors') option_use_colors='yes' ;;
	# 		# '--func-header') option_func_name_as_title='yes' ;;
	# 		# '--desc-hl='*) option_lang_hl="${item#*=}" ;;
	# 		# '--only-func-names') ;; # Only list function-names-formatted
	# 		esac
	# 	}
	# 	handle_meta_selections "$sel"
	# fi

}
