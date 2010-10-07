# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: root
# Purpose: To handle the postgresql selection related tasks.
#

inherit versionator
ECLASS="postgresql"
INHERITED="$INHERITED $ECLASS"

# Usage: postgresql_version_in_range [version[ min_version[ max_version]]]
# Returns $?=0 if in range
postgresql_version_in_range() {
	local v="$1" min="$2" max="$3"
	if [[ ! -z "$min" ]] ; then
		version_compare "$min" "$v"
		[[ "$?" = "3" ]] && return 1
	fi
	if [[ ! -z "$max" ]] ; then
		version_compare "$max" "$v"
		[[ "$?" = "1" ]] && return 2
	fi
	return 0
}

# Usage: postgresql_get_versions_range [ min_version[ max_version]]
postgresql_get_versions_range() {
	local min="$1" max="$2"
	for s in /usr/lib/eselect-postgresql/slots/* ; do
		[[ -d "$s" ]] || continue
		local v="$(basename $s)"
		postgresql_version_in_range "$v" "$min" "$max" || continue
		echo "$v"
	done
}
# Usage: postgresql_get_sorted_versions [ min_version[ max_version]]
postgresql_get_sorted_versions() {
	version_sort $(postgresql_get_versions_range "$1" "$2")
}

# Usage: postgresql_find_version [min_version[ max_version[ strategy]]]
#	min_version - minimum supported version (empty string if any)
#	max_version - maximum supported version (empty string if any)
#	strategy	- best, worst (that is, if eselected version isn't in range)
#				  (best is default)
# Returns selected version string
postgresql_find_version() {
	local min="$1" max="$2" strategy="$3"
	local eselected="$(eselect postgresql show)"
	if [[ "$eselected" != "(none)" ]] ; then
		postgresql_version_in_range "$eselected" "$min" "$max" && { echo "$eselected" ; return 0; }
	fi
	local vers=( $(postgresql_get_sorted_versions "$min" "$max") )
	case "$strategy" in
		worst)
			echo "${vers[0]}"
			;;
		*)
			echo "${vers[${#vers[@]}-1]}"
			;;
	esac
}

# Usage: postgresql_get_bindir_for_slot slot
# Returns path to binaries for exact slot
postgresql_get_bindir_for_slot() {
	(for f in /usr/lib/eselect-postgresql/slots/$1/* ; do source $f ; done ; echo $postgres_bindir)
}

# Usage: postgresql_get_pgconfig_for_slot slot
# Returns path to pg_config for exact slot
postgresql_get_pgconfig_for_slot() {
	echo "$(for f in /usr/lib/eselect-postgresql/slots/$1/* ; do source $f ; done ; echo $postgres_bindir)/pg_config"
}

# Usage: postgresql_get_prefix_for_slot slot
# Returns the install prefix for exact slot
postgresql_get_prefix_for_slot() {
	(for f in /usr/lib/eselect-postgresql/slots/$1/* ; do source $f ; done ; echo $postgres_prefix)
}

# Usage: postgresql_get_service_for_slot slot
# Returns the name of init.d service for exact slot
postgresql_get_service_for_slot() {
	(for f in /usr/lib/eselect-postgresql/slots/$1/* ; do source $f ; done ; echo $postgres_service)
}

# Usage: postgresql_get_datadir_for_slot slot
# Returns the data(share) dir location for exact slot
postgresql_get_datadir_for_slot() {
	(for f in /usr/lib/eselect-postgresql/slots/$1/* ; do source $f ; done ; echo $postgres_datadir)
}

# Usage: postgresql_get_bindir [min_version[ max_version[ strategy]]]
#	See postgresql_find_version
# Returns path to binaries
postgresql_get_bindir() {
	postgresql_get_bindir_for_slot "$(postgresql_find_version "$1" "$2" "$3")"
}

# Usage: postgresql_get_pgconfig [min_version[ max_version[ strategy]]]
#	See postgresql_find_version
# Returns path to pg_config
postgresql_get_pgconfig() {
	echo "$(postgresql_get_bindir)/pg_config"
}
