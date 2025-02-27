#!/bin/bash

# RESOURCES:
# https://stackoverflow.com/questions/11776468/create-associative-array-in-bash-3
# https://stackoverflow.com/questions/688849/associative-arrays-in-shell-scripts/4444841#4444841
# https://stackoverflow.com/questions/1494178/how-to-define-hash-tables-in-bash
#
# BEST ANSWER PROBABLY:
# https://stackoverflow.com/questions/1494178/how-to-define-hash-tables-in-bash

# NOTE: for optimal performance, everything should be managed with globally
# scoped arrays to a command.

# =============================================================================
# BASH DOCS
#
# declare [-aAfFgiIlnrtux] [-p] [name[=value] ...]
# typeset [-aAfFgiIlnrtux] [-p] [name[=value] ...]
#        Declare variables and/or give them attributes.  If no names are given then display the values of
#        variables.  The -p option will display the attributes and values of each name.  When -p is used
#        with name arguments, additional options, other than -f and -F, are ignored.  When -p is supplied
#        without name arguments, it will display the attributes and values of all variables having the
#        attributes specified by the additional options.  If no other options are supplied with -p, declare
#        will display the attributes and values of all shell variables.  The -f option will restrict the
#        display to shell functions.  The -F option inhibits the display of function definitions; only the
#        function name and attributes are printed.  If the extdebug shell option is enabled using shopt,
#        the source file name and line number where each name is defined are displayed as well.  The -F
#        option implies -f.  The -g option forces variables to be created or modified at the global scope,
#        even when declare is executed in a shell function.  It is ignored in all other cases.  The -I
#        option causes local variables to inherit the attributes (except the nameref attribute) and value
#        of any existing variable with the same name at a surrounding scope.  If there is no existing
#        variable, the local variable is initially unset.  The following options can be used to restrict
#        output to variables with the specified attribute or to give variables attributes:
#        -a     Each name is an indexed array variable (see Arrays above).
#        -A     Each name is an associative array variable (see Arrays above).
#        -f     Use function names only.
#        -i     The variable is treated as an integer; arithmetic evaluation (see ARITHMETIC EVALUATION
#               above) is performed when the variable is assigned a value.
#        -l     When the variable is assigned a value, all upper-case characters are converted to lower-
#               case.  The upper-case attribute is disabled.
#        -n     Give each name the nameref attribute, making it a name reference to another variable.  That
#               other variable is defined by the value of name.  All references, assignments, and attribute
#               modifications to name, except those using or changing the -n attribute itself, are
#               performed on the variable referenced by name's value.  The nameref attribute cannot be
#               applied to array variables.
#        -r     Make names readonly.  These names cannot then be assigned values by subsequent assignment
#               statements or unset.
#        -t     Give each name the trace attribute.  Traced functions inherit the DEBUG and RETURN traps
#               from the calling shell.  The trace attribute has no special meaning for variables.
#        -u     When the variable is assigned a value, all lower-case characters are converted to upper-
#               case.  The lower-case attribute is disabled.
#        -x     Mark names for export to subsequent commands via the environment.
#
#        Using `+' instead of `-' turns off the attribute instead, with the exceptions that +a and +A may
#        not be used to destroy array variables and +r will not remove the readonly attribute.  When used
#        in a function, declare and typeset make each name local, as with the local command, unless the -g
#        option is supplied.  If a variable name is followed by =value, the value of the variable is set to
#        value.  When using -a or -A and the compound assignment syntax to create array variables,
#        additional attributes do not take effect until subsequent assignments.  The return value is 0
#        unless an invalid option is encountered, an attempt is made to define a function using ``-f
#        foo=bar'', an attempt is made to assign a value to a readonly variable, an attempt is made to
#        assign a value to an array variable without using the compound assignment syntax (see Arrays
#        above), one of the names is not a valid shell variable name, an attempt is made to turn off
#        readonly status for a readonly variable, an attempt is made to turn off array status for an array
#        variable, or an attempt is made to display a non-existent function with -f.
# =============================================================================

declare -a keys   # Stores string keys
declare -a values # Stores associated values

# FIX: remove all subshells -> create a special global array instead.

# Function to encode a string key into a unique integer index
encode_key() {
	local key="$1"
	local sum=0
	local i
	for ((i = 0; i < ${#key}; i++)); do
		sum=$((sum + $(printf "%d" "'${key:i:1}"))) # Sum ASCII values
	done
	echo "$sum"
}

# Function to set a key-value pair
set_value() {
	local key="$1"
	local value="$2"
	local index
	index=$(encode_key "$key")

	keys[$index]="$key"
	values[$index]="$value"
}

# Function to get a value by key
get_value() {
	local key="$1"
	local index
	index=$(encode_key "$key")

	if [[ "${keys[$index]}" == "$key" ]]; then
		REPLY="${values[$index]}" # No subshell
		return 0
	else
		return 1 # Key not found
	fi
}

# Store values
set_value "apple" "red"
set_value "banana" "yellow"
set_value "grape" "purple"

# Retrieve values
get_value "banana" && echo "banana is $REPLY"
get_value "apple" && echo "apple is $REPLY"
get_value "grape" && echo "grape is $REPLY"
