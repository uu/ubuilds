# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: root
# Purpose: Build extensions or plugins supporting multiple versions of framework
# simultaneously by building the package for all available slots
#

ECLASS="multislot"
INHERITED="$INHERITED $ECLASS"
EXPORT_FUNCTIONS src_unpack src_compile src_test src_install

# Return the list of functions to try (the first match takes precedence)
# multislot_funs <function_name> <parameters>
multislot_run_fun() {
	local fun="${1}"
	shift
	for e in '' ${MULTISLOT_ECLASSES} multislot ; do
		[[ -z "$e" ]] || e="${e}_"
		if [[ "$(type -t "${e}$fun")" == function ]] ; then
			${e}$fun "$@"
			return $?
		fi
	done
}

# Store unslotted workdir for future reference if it wasn't stored yet.
multislot_storeWD() {
	[[ -z "${MULTISLOT_UNSLOTTED_WORKDIR}" ]] && MULTISLOT_UNSLOTTED_WORKDIR="${WORKDIR}"
}
# Discover what slots are we building for
multislot_storeSlots() {
	[[ -z "${MULTISLOT_SLOTS}" ]] && MULTISLOT_SLOTS="$(multislot_run_fun slots_enumerate)"
}

# Set up WORKDIR, S and SLOTSLOT variables for particular slot
# Usage: multislot_slot_vars <slot>
multislot_slot_vars() {
	multislot_storeWD
	local new_wd="${MULTISLOT_UNSLOTTED_WORKDIR}/$1"
	S="${S/${WORKDIR}/${new_wd}}"
	WORKDIR="${new_wd}"
	SLOTSLOT="$1"
}

multislot_foreach_slot() {
	multislot_storeSlots
	local slot
	for slot in ${MULTISLOT_SLOTS} ; do
		multislot_slot_vars $slot
		eval "$@"
	done
}

multislot_src_unpack() {
	multislot_foreach_slot 'mkdir -p "$WORKDIR" ; cd "$WORKDIR" ; multislot_run_fun slot_src_unpack'
}

multislot_src_compile() {
	multislot_foreach_slot 'cd "$S"||cd "$WORKDIR"; multislot_run_fun slot_src_compile'
}
multislot_src_test() {
	multislot_foreach_slot 'cd "$S"||cd "$WORKDIR"; multislot_run_fun slot_src_test'
}
multislot_src_install() {
	multislot_foreach_slot 'cd "$S"||cd "$WORKDIR"; multislot_run_fun slot_src_install'
}

multislot_slot_src_unpack() {
	unpack ${A}
}
