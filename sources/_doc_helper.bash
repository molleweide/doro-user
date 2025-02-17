function doc_helper() {
  source "$DOROTHY/sources/bash.bash"
	# function_bodies=()

	# local item cmd=() exit_status_local exit_status_variable='exit_status_local' stdout_variable='' stderr_variable='' output_variable='' stdout_pipe='/dev/stdout' stderr_pipe='/dev/stderr'
	# while [[ $# -ne 0 ]]; do
	# 	item="$1"
	# 	shift
	# 	case "$item" in
	# 	'--help')
	# 		cat <<-EOF >/dev/stderr
	# 			ABOUT:
	# 			Capture or ignore exit status, without disabling errexit, and without a subshell.
	# 			Copyright 2023+ Benjamin Lupton <b@lupton.cc> (https://balupton.com)
	# 			Written for Dorothy (https://github.com/bevry/dorothy)
	# 			Licensed under the CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/)
	# 			For more information: https://github.com/bevry/dorothy/blob/master/docs/bash/errors.md
	#
	# 			USAGE:
	# 			local status=0 stdout='' stderr='' output=''
	# 			eval_capture [--statusvar=status] [--stdoutvar=stdout] [--stderrvar=stderr] [--outputvar=output] [--stdoutpipe=/dev/stdout] [--stderrpipe=/dev/stderr] [--outputpipe=...] [--no-stdout] [--no-stderr] [--no-output] [--] cmd ...
	#
	# 			QUIRKS:
	# 			Using --stdoutvar will set --stdoutpipe=/dev/null
	# 			Using --stderrvar will set --stderrpipe=/dev/null
	# 			Using --outputvar will set --stdoutpipe=/dev/null --stderrpipe=/dev/null
	#
	# 			WARNING:
	# 			If [eval_capture] triggers something that still does function invocation via [if], [&&], [||], or [!], then errexit will still be disabled for that invocation.
	# 			This is a limitation of bash, with no workaround (at least at the time of bash v5.2).
	# 			Refer to https://github.com/bevry/dorothy/blob/master/docs/bash/errors.md for guidance.
	# 		EOF
	# 		return 22 # EINVAL 22 Invalid argument
	# 		;;
	# 	'--statusvar='* | '--status-var='*)
	# 		exit_status_variable="${item#*=}"
	# 		;;
	# 	'--stdoutvar='* | '--stdout-var='*)
	# 		stdout_variable="${item#*=}"
	# 		stdout_pipe='/dev/null'
	# 		;;
	# 	'--stderrvar='* | '--stderr-var='*)
	# 		stderr_variable="${item#*=}"
	# 		stderr_pipe='/dev/null'
	# 		;;
	# 	'--outputvar='* | '--output-var='*)
	# 		output_variable="${item#*=}"
	# 		stdout_pipe='/dev/null'
	# 		stderr_pipe='/dev/null'
	# 		;;
	# 	'--no-stdout' | '--ignore-stdout' | '--stdout=no')
	# 		stdout_pipe='/dev/null'
	# 		;;
	# 	'--no-stderr' | '--ignore-stderr' | '--stderr=no')
	# 		stderr_pipe='/dev/null'
	# 		;;
	# 	'--no-output' | '--ignore-output' | '--output=no')
	# 		stdout_pipe='/dev/null'
	# 		stderr_pipe='/dev/null'
	# 		;;
	# 	'--stdoutpipe='* | '--stdout-pipe='*)
	# 		stdout_pipe="${item#*=}"
	# 		;;
	# 	'--stderrpipe='* | '--stderr-pipe='*)
	# 		stderr_pipe="${item#*=}"
	# 		;;
	# 	'--outputpipe='* | '--output-pipe='*)
	# 		stdout_pipe="${item#*=}"
	# 		stderr_pipe="$stdout_pipe"
	# 		;;
	# 	'--')
	# 		cmd+=("$@")
	# 		shift $#
	# 		break
	# 		;;
	# 	'-'*)
	# 		# __print_line "ERROR: $0: ${FUNCNAME[0]}: $LINENO: An unrecognised flag was provided: $item" >/dev/stderr
	# 		return 22 # EINVAL 22 Invalid argument
	# 		;;
	# 	*)
	# 		cmd+=(
	# 			"$item"
	# 			"$@"
	# 		)
	# 		shift $#
	# 		break
	# 		;;
	# 	esac
	# done

	local function_names=() function_bodies=()

	# handle input
	while read -r line; do
		# while IFS= read -r line; do
		function_names+=("$line")
		function_bodies+=("$(declare -f "$line")")
	done

	# # bodies
	# for function_name in "${function_names[@]}"; do
	# 	function_bodies+=("$(declare -f "$function_name")")
	# done

	# echo "${function_bodies[@]}"

	# NOTE: parts:
	# ~ function *
	# ~ code (subset of *) **
	# ~ label rendered (subset of **)
	#
	# from the code

	# prepare data for choose
	function_names_with_bodies=()
	for index in "${!function_names[@]}"; do
		function_names_with_bodies+=("${function_names[index]}" "${function_bodies[index]}")
		# echo "${function_names[index]}"
		# echo "${function_bodies[index]}"
	done

	# local idx=0
	# for item in "${function_names_with_bodies[@]}"; do
	# 	idx=$((idx + 1))
	# 	echo "IDX: $idx --------"
	# 	echo "$item"
	# done

	# echo "${function_names_with_bodies[@]}"

	# fn="$(choose --required --linger 'Which function to execute?' --label -- "${function_names_with_bodies[@]}")"
	# args="$(ask --linger 'Arguments to pass to the function?')"
	# $fn $args

}
