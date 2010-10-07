# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Author John Jawed <johnjawed@gmail.com>
# Author Alex Tarkovsky <alextarkovsky@gmail.com>
# $Header: $

# This eclass provides enhanced input functions for ebuilds.

ESC_SEQ=$'\e['

BOLD="${ESC_SEQ}01m"
NORMAL="${ESC_SEQ}00m"

BLUE="${ESC_SEQ}34;01m"
BROWN="${ESC_SEQ}33m"
DARKBLUE="${ESC_SEQ}34m"
DARKGREEN="${ESC_SEQ}32m"
DARKRED="${ESC_SEQ}31m"
FUCHSIA="${ESC_SEQ}35;01m"
GREEN="${ESC_SEQ}32;01m"
PURPLE="${ESC_SEQ}35m"
RED="${ESC_SEQ}31;01m"
TEAL="${ESC_SEQ}36m"
TURQUOISE="${ESC_SEQ}36;01m"
YELLOW="${ESC_SEQ}33;01m"

EINPUT_COLORS=(
	$BLUE
	$BROWN
	$DARKBLUE
	$DARKGREEN
	$DARKRED
	$FUCHSIA
	$GREEN
	$PURPLE
	$RED
	$TEAL
	$TURQUOISE
	$YELLOW
)

# Stores the user input received by the last einput function called (with the
# exception of einput_confirm(), which stores the user's choice and its own exit
# status).
EINPUT_ANSWER=""

# Stores the user input received by the last einput function called (with the
# exception of einput_confirm(), which stores the user's choice and its own exit
# status). This answer is always in lower-case.
EINPUT_IANSWER=""

# Set EINPUT_NOCOLOR to "0" to disable colorized output, or "1" to allow it.
# After inheriting this eclass ebuilds may set this var directly, but it's
# preferred to rely on the value supplied here by portageq.
[[ "$(${ROOT}/sbin/consoletype 2> /dev/null)" == "serial" || $EINPUT_NOCOLOR == 1 ]] &&
	unset BOLD NORMAL BLUE BROWN DARKBLUE DARKGREEN DARKRED FUCHSIA GREEN \
		PURPLE RED TEAL TURQUOISE YELLOW EINPUT_COLORS

# Usage: einput_confirm question [ default_value ]
#
# Get confirmation from a user with a standard yes/no prompt. If the user simply
# presses Enter when prompted, the green-colored value (or if the NOCOLOR
# evnironment variable is set, the value in all capital letters) will be used.
# This default can be set with the optional default_value parameter; accepted
# values are "0" (corresponding to "no") and "1" (for "yes").
#
# Returns: Exit status 0 for "no", exit status 1 for "yes", stores user answer
# in $EINPUT_ANSWER and for case insensitive comparisons in $EINPUT_IANSWER
# Default: default_value if given, else 1
#
# Example: einput_confirm "Are you sure you want to rm -rf /?" "0"
#
einput_confirm() {
	local color_yes color_no
	local string_yes="Yes" string_no="No"
	if [[ "$2" == "0" ]] ; then
		if [[ $EINPUT_NOCOLOR == 1 ]] ; then
			string_yes="yes"
			string_no="NO"
		else
			color_yes=$RED
			color_no=$GREEN
		fi
	else
		if [[ $EINPUT_NOCOLOR == 1 ]] ; then
			string_yes="YES"
			string_no="no"
		else
			color_yes=$GREEN
			color_no=$RED
		fi
	fi
	while true ; do
		echo -n "${BOLD}${1}${NORMAL} [${color_yes}${string_yes}${NORMAL}/${color_no}${string_no}${NORMAL}] "
		read -r answer
		echo
		case "$answer" in
			[yY]*)
				EINPUT_ANSWER=${string_yes}
				EINPUT_IANSWER=`echo -n ${EINPUT_ANSWER} | tr [:upper:] [:lower:]`
				return 1 ;;

			[nN]*)
				EINPUT_ANSWER=${string_no}
				EINPUT_IANSWER=`echo -n ${EINPUT_ANSWER} | tr [:upper:] [:lower:]`
				return 0 ;;

			"")
				[[ "$2" == "0" ]] && EINPUT_ANSWER=${string_no} && \
				EINPUT_IANSWER=`echo -n ${EINPUT_ANSWER} | tr [:upper:] [:lower:]` && return 0
				EINPUT_ANSWER=${string_yes}
				EINPUT_IANSWER=`echo -n ${EINPUT_ANSWER} | tr [:upper:] [:lower:]`
				return 1 ;;

			*)
				echo "!!! Invalid answer, try again."
				echo
				;;
		esac
	done
}

# Usage: einput_list option1 description1 [ option2 description2 ... ] prompt
#
# Display a colorized (unless the environment variable NOCOLOR is set) selection
# list of options and their descriptions, along with a prompt line. Options may
# be alphanumeric and are handled as strings.
#
# Matching of user input against option strings is case-sensitive.
#
# Returns: The chosen option as a string, stored in global $EINPUT_ANSWER
# and lower case for case-insensitive comparisons in global $EINPUT_IANSWER.
# Default: none
#
# Example: einput_list "1" "List Entry" "2" "List File" "Choose a listing style"
#
einput_list() {
	local choices=( )
	local num_choices=$(( ($# - 1) / 2 ))
	echo "${BOLD}----------------------------------------------${NORMAL}"
	for (( i = 0, j = 0 ; i < num_choices ; i++, j++ )) ; do
		(( j == ${#EINPUT_COLORS[*]} )) && j=0
		echo "  ${EINPUT_COLORS[${j}]}${1})${NORMAL} ${2}"
		choices[$i]="$1"
		shift 2
	done
	echo "${BOLD}----------------------------------------------${NORMAL}"
	while true ; do
		echo -n "${BOLD}${1}${NORMAL}"
		read -rp ": " answer
		echo
		for choice in ${choices[*]} ; do
			if [[ "$choice" == "$answer" ]] ; then
				break 2
			elif [[ "$choice" == "${choices[$((num_choices - 1))]}" ]] ; then
				echo "!!! Invalid answer, try again."
				echo
			fi
		done
	done
	EINPUT_ANSWER="$answer"
	EINPUT_IANSWER=`echo -n ${EINPUT_ANSWER} | tr [:upper:] [:lower:]`
}

# Usage: einput_prompt prompt [ default_value ]
#
# Display a simple input prompt. If default_value is specified, its value will
# be displayed between brackets at the end of the prompt, highlighted in green
# letters (unless the environment variable NOCOLOR is set). If no default value
# is given, the brackets will be empty.
#
# Returns: The user's response as a string, stored in global $EINPUT_ANSWER
# and lower case for case-insensitive comparisons in global $EINPUT_IANSWER.
# Default: default_value if given, else an empty string ""
#
# Example: einput_prompt "Is Gentoo a good Linux distro?" "Yes it is Jim"
#
einput_prompt() {
	echo -n "${BOLD}${1}${NORMAL} [${GREEN}${2}${NORMAL}] "
	read -r answer
	echo
	if [[ -z "$answer" ]] ; then
		EINPUT_ANSWER="$2"
	else
		EINPUT_ANSWER="$answer"
	fi
	EINPUT_IANSWER=`echo -n ${EINPUT_ANSWER} | tr [:upper:] [:lower:]`
}

# Usage: einput_prompt_secret prompt
#
# Display a simple input prompt and hide the user's input as they type. Useful
# for when some operation requires a different set of user privileges.
#
# Returns: The user's response as a string, stored in global $EINPUT_ANSWER
# and lower case for case-insensitive comparisons in global $EINPUT_IANSWER.
# Default: none
#
# Example: einput_prompt_secret "Please enter your root password"
#
einput_prompt_secret() {
	echo -n "${BOLD}${1}${NORMAL}"
	read -rsp ": " answer
	echo
	echo
	EINPUT_ANSWER="$answer"
	EINPUT_IANSWER=`echo -n ${EINPUT_ANSWER} | tr [:upper:] [:lower:]`
}

# Usage: einput_multi_prompt prompt option1 [ option2 ... ] default_value
#
# Display an in-line input prompt with a set of options. 
# If default_value is specified, its value will be displayed between brackets
# at the end of the prompt, highlighted in green
# letters (unless the environment variable NOCOLOR is set). If no default value
# is given, the brackets will be empty.
#
# Returns: The user's response as a string, stored in global $EINPUT_ANSWER
# and lower case for case-insensitive comparisons in global $EINPUT_IANSWER
# Default: default_value if given, else an empty string ""
#
# Example: einput_multi_prompt "Please select your bindings" "C" "C++" "Python" "C"
#
einput_multi_prompt() {
	local choices=( )
	local num_choices=$(( ($# - 2) ))
	local prompt="${BOLD}${1}${NORMAL}"
	shift
	local display_choices=""
	for (( i = 0, j = 0 ; i < num_choices ; i++, j++ )) ; do
		(( j == ${#EINPUT_COLORS[*]} )) && j=0
		display_choices="${display_choices}${EINPUT_COLORS[${j}]}${1}"
		choices[$i]="$1"
		shift
		if [ $i -lt $# ];then
			display_choices="${display_choices}${NORMAL}/"
		fi
	done
	echo -n "${prompt} ${NORMAL}<${display_choices}${NORMAL}> "
	while true ; do
		echo -n "${NORMAL}[${GREEN}${1}${NORMAL}]"
		read -rp ": " answer
		echo
		for choice in ${choices[*]} ; do
			if [[ "$choice" == "$answer" ]] ; then
				break 2
			elif [[ "$choice" == "${choices[$((num_choices - 1))]}" ]] ; then
				echo "!!! Invalid answer, try again."
				echo
			fi
		done
	done
	EINPUT_ANSWER="$answer"
	EINPUT_IANSWER=`echo -n ${EINPUT_ANSWER} | tr [:upper:] [:lower:]`
}

# Usage: einput_add_init prompt
#
# Displays a simple predefined prompt with the package name ($1) asking if
# a packages init script should be added to the $2 runlevel. If an init
# script already exists, no prompt will be shown and the function will return
# 0.
#
# Returns: The exit code from rc-update if an existing entry does not exist.
# If an existing entry exists, returns 0.
# Default: none
#
# Example: einput_add_init "postgresql" "default"
#
einput_add_init() {
	check_if_exists=`${ROOT}/sbin/rc-update show $2 | grep $1 | wc -l`
	if [ "${check_if_exists}" == "0" ]; then
		if einput_confirm "Do you want to add $1 to your default runlevel?" "0";
		then
			${ROOT}/sbin/rc-update add $1 $2
			return $?
		fi
	else
		return 0
	fi
}
