# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: Petteri Räty <betelgeuse@gentoo.org>
# Purpose: Virtuals for Java
#

inherit java-utils-2

JAVA_VIRTUALS_HELPER=/home/betelgeuse/python/combinations.py

java-virtuals_get-provider() {
	debug-print-function ${FUNCNAME} $*
	${JAVA_VIRTUALS_HELPER} virtual/${1} | while read name slot; do
		local to_match
		if [[ ${SLOT} = 0 ]]; then
			to_match=${name}
		else
			to_match=${name}-${slot}
		fi
		if [[ -e "/usr/share/${to_match}" ]]; then
			debug-print "Using ${to_match} to provide ${1}"
			echo ${to_match}
		fi
	done
	return 1
}

java-virtuals_provided-by-jdk() {
	debug-print-function ${FUNCNAME} $*
	local pkg=${1}
	${JAVA_VIRTUALS_HELPER} virtual/${pkg} | while read name slot; do
		local to_match
		if [[ ${SLOT} = 0 ]]; then
			to_match=${name}
		else
			to_match=${name}-${slot}
		fi
		[[ ${GENTOO_VM} = ${to_match} ]]
		if [[ $? = 0 ]]; then
			debug-print "Current GENTOO_VM (${GENTOO_VM}) provides ${pkg}"
			return 0
		fi
	done
	debug-print "Current GENTOO_VM (${GENTOO_VM}) doesn't provide ${pkg}"
	return 1
}

java-virtuals_jar-from() {
	debug-print-function ${FUNCNAME} $*
	local pkg=${1}
	java-virtuals_provided-by-jdk ${pkg} && return
	shift 1
	java-pkg_jar-from --disable-depcheck $(java-virtuals_get-provider ${pkg}) "${@}"
}

java-virtuals_get-jars() {
	debug-print-function ${FUNCNAME} $*
	local pkg=${1}
	java-virtuals_provided-by-jdk ${pkg} && return
	shift 1
	java-pkg_getjars --disable-depcheck $(java-virtuals_get-provider ${pkg}) "${@}"
}

