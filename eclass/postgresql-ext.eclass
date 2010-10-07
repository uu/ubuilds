# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: root
# Purpose: Installing postgresql extension for all available slots
#

ECLASS="postgresql-ext"
INHERITED="$INHERITED $ECLASS"
inherit postgresql multislot
EXPORT_FUNCTIONS src_unpack src_compile src_test src_install

MULTISLOT_ECLASSES="postgresql-ext ${MULTISLOT_ECLASSES}"

postgresql-ext_slots_enumerate() {
	postgresql_get_versions_range ${WANT_POSTGRES_SLOTS}
}

postgresql-ext_src_unpack() {
	multislot_src_unpack "$@"
}
postgresql-ext_src_compile() {
	multislot_src_compile "$@"
}
postgresql-ext_src_install() {
	multislot_src_install "$@"
}
postgresql-ext_src_test() {
	multislot_src_test "$@"
}

postgresql-ext_slot_src_unpack() {
	PATH="$(postgresql_get_bindir_for_slot $SLOTSLOT):${PATH}" multislot_run_fun pgslot_src_unpack "$@"
}
postgresql-ext_slot_src_compile() {
	PATH="$(postgresql_get_bindir_for_slot $SLOTSLOT):${PATH}" multislot_run_fun pgslot_src_compile "$@"
}
postgresql-ext_slot_src_test() {
	PATH="$(postgresql_get_bindir_for_slot $SLOTSLOT):${PATH}" multislot_run_fun pgslot_src_test "$@"
}
postgresql-ext_slot_src_install() {
	PATH="$(postgresql_get_bindir_for_slot $SLOTSLOT):${PATH}" multislot_run_fun pgslot_src_install "$@"
}

postgresql-ext_pgslot_src_unpack() {
	multislot_slot_src_unpack
}
postgresql-ext_pgslot_src_compile() {
	multislot_slot_src_compile
}
postgresql-ext_pgslot_src_test() {
	multislot_slot_src_test
}
postgresql-ext_pgslot_src_install() {
	multislot_slot_src_install
}

postgresql-ext_pg_slots_depend() {
	local vers=( ${WANT_POSTGRES_SLOTS} )
	if [[ -z "${vers[0]}" ]] ; then
		echo 'virtual/postgresql-server'
	else
		echo ">=virtual/postgresql-server-${vers[0]}"
		if [[ ! -z "${vers[1]}" ]] ; then
			echo "<=virtual/postgresql-server-${vers[1]}"
		fi
	fi
}

DEPEND="$(postgresql-ext_pg_slots_depend)"
RDEPEND="$(postgresql-ext_pg_slots_depend)"
