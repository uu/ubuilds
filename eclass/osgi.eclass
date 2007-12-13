# Base eclass for Java packages that needs to be OSGi compliant
#
# Copyright (c) 2007, Jean-Noël Rivasseau <elvanor@gmail.com>
# Copyright (c) 2007, Gentoo Foundation
#
# Licensed under the GNU General Public License, v2
#
# $Header: /var/cvsroot/gentoo-x86/eclass/java-utils-2.eclass,v 1.92 2007/08/05 08:17:05 betelgeuse Exp $

# -----------------------------------------------------------------------------
# @eclass-begin
# @eclass-shortdesc Java OSGi eclass
# @eclass-maintainer java@gentoo.org
#
# This eclass provides functionality which is used by
# packages that need to be OSGi compliant. This means
# that the generated jars will have special headers in their manifests.
# Currently this is used only by Eclipse-3.3 - later
# we could extend this so that Gentoo Java system would be
# fully OSGi compliant.
#
# -----------------------------------------------------------------------------

inherit java-utils-2

# We define _OSGI_T so that it does not contain a slash at the end.
# According to Paludis guys, there is currently a proposal for EAPIs that
# would require all variables to end with a slash.

_OSGI_T="${T/%\//}"

# -----------------------------------------------------------------------------
# @ebuild-function _java-pkg_osgi-plugin
#
# This is an internal function, not to be called directly.
#
# @example
#	_java-pkg_osgi-plugin "JSch"
#
# @param $1 - bundle name
#
# ------------------------------------------------------------------------------

_java-pkg_osgi-plugin() {
	# We hardcode Gentoo as the vendor name

	cat > "${_OSGI_T}/tmp_jar/plugin.properties" <<-EOF
	bundleName="${1}"
	vendorName="Gentoo"
	EOF
}

# -----------------------------------------------------------------------------
# @ebuild-function _java-pkg_osgijar
#
# This is an internal function, not to be called directly.
#
# @example
#	_java-pkg_osgijar "dist/${PN}.jar" "com.jcraft.jsch" "JSch" "com.jcraft.jsch, com.jcraft.jsch.jce;x-internal:=true" 
#
# @param $1 - name of jar to repackage with OSGi
# @param $2 - bundle symbolic name
# @param $3 - bundle name
# @param $4 - export-package header
#
# ------------------------------------------------------------------------------

_java-pkg_osgijar() {
	debug-print-function ${FUNCNAME} "$@"

	(( ${#} < 4 )) && die "Four arguments are needed for java-pkg_osgijar()"

	local absoluteJarPath="$(readlink -f ${1})"
	local jarName="$(basename $1)"

	mkdir "${_OSGI_T}/tmp_jar" || die "Unable to create directory ${_OSGI_T}/tmp_jar"
	[[ -d "${_OSGI_T}/osgi" ]] || mkdir "${_OSGI_T}/osgi" || die "Unable to create directory ${_OSGI_T}/osgi"

	cd "${_OSGI_T}/tmp_jar" && jar xf "${1}" && cd - > /dev/null \
		 || die "Unable to uncompress correctly the original jar"

	cat > "${_OSGI_T}/tmp_jar/META-INF/MANIFEST.MF" <<-EOF
	Manifest-Version: 1.0
	Bundle-ManifestVersion: 2
	Bundle-Name: %bundleName
	Bundle-Vendor: %vendorName
	Bundle-Localization: plugin
	Bundle-SymbolicName: ${2}
	Bundle-Version: ${PV}
	Export-Package: ${4}
	EOF

	_java-pkg_osgi-plugin "${3}"

	jar cfm "${_OSGI_T}/osgi/${jarName}" "${_OSGI_T}/tmp_jar/META-INF/MANIFEST.MF" \
		-C "${_OSGI_T}/tmp_jar/" . > /dev/null || die "Unable to recreate the OSGi compliant jar"
	rm -rf "${_OSGI_T}/tmp_jar"
}

# -----------------------------------------------------------------------------
# @ebuild-function java-pkg_doosgijar
#
# Rewrites a jar, and produce an OSGi compliant jar from arguments given on the command line.
# The arguments given correspond to the minimal set of headers
# that must be present on a Manifest file of an OSGi package.
# If you need more headers, you should use the *-fromfile functions below,
# that create the Manifest from a file.
# It will call java-pkg_dojar at the end.
#
# @example
#	java-pkg_doosgijar "dist/${PN}.jar" "com.jcraft.jsch" "com.jcraft.jsch, com.jcraft.jsch.jce;x-internal:=true" "JSch"
#
# @param $1 - name of jar to repackage with OSGi
# @param $2 - bundle symbolic name
# @param $3 - bundle name
# @param $4 - export-package-header
#
# ------------------------------------------------------------------------------

java-pkg_doosgijar() {
	debug-print-function ${FUNCNAME} "$@"
	local jarName="$(basename ${1})"
	_java-pkg_osgijar "$@"
	java-pkg_dojar "${_OSGI_T}/osgi/${jarName}"
}

# -----------------------------------------------------------------------------
# @ebuild-function java-pkg_newosgijar
#
# Rewrites a jar, and produce an OSGi compliant jar.
# The arguments given correspond to the minimal set of headers
# that must be present on a Manifest file of an OSGi package.
# If you need more headers, you should use the *-fromfile functions below,
# that create the Manifest from a file.
# It will call java-pkg_newjar at the end.
#
# @example
#	java-pkg_newosgijar "dist/${PN}.jar" "com.jcraft.jsch" "com.jcraft.jsch, com.jcraft.jsch.jce;x-internal:=true" "JSch"
#
# @param $1 - name of jar to repackage with OSGi
# @param $2 (optional) - name of the target jar. It will default to package name if not specified.
# @param $3 - bundle symbolic name
# @param $4 - bundle name
# @param $5 - export-package header
#
# ------------------------------------------------------------------------------

java-pkg_newosgijar() {
	debug-print-function ${FUNCNAME} "$@"
	local jarName="$(basename $1)"

	if (( ${#} > 4 )); then
		_java-pkg_osgijar "${1}" "${3}" "${4}"
		java-pkg_newjar "${_OSGI_T}/osgi/${jarName}" "${2}"
	else
		_java-pkg_osgijar "$@"
		java-pkg_newjar "${_OSGI_T}/osgi/${jarName}"
	fi
}

# -----------------------------------------------------------------------------
# @ebuild-function _java-pkg_osgijar-fromfile
#
# This is an internal function, not to be called directly.
#
# @example
#	_java-pkg_osgijar-fromfile "dist/${PN}.jar" "${FILESDIR}/MANIFEST.MF" "JSch" 1
#
# @param $1 - name of jar to repackage with OSGi
# @param $2 - path to the Manifest file
# @param $3 - bundle name
# @param $4 - automatic version rewriting (0 or 1)
#
# ------------------------------------------------------------------------------

_java-pkg_osgijar-fromfile() {
	debug-print-function ${FUNCNAME} "$@"

	((${#} < 4)) && die "Four arguments are needed for java-pkg_osgijar-fromfile()"

	local absoluteJarPath="$(readlink -f ${1})"
	local jarName="$(basename ${1})"
	
	mkdir "${_OSGI_T}/tmp_jar" || die "Unable to create directory ${_OSGI_T}/tmp_jar"
	[[ -d "${_OSGI_T}/osgi" ]] || mkdir "${_OSGI_T}/osgi" || die "Unable to create directory ${_OSGI_T}/osgi"

	cd "${_OSGI_T}/tmp_jar" && jar xf "${absoluteJarPath}" && cd - > /dev/null \
		|| die "Unable to uncompress correctly the original jar"

	[[ -e "${2}" ]] || die "Manifest file ${2} not found"

	# We automatically change the version if automatic version rewriting is on
					
	if (( ${4} )); then
		cat "${2}" > "${_OSGI_T}/tmp_jar/META-INF/MANIFEST.MF"
	else
		cat "${2}" | sed "s/Bundle-Version:.*/Bundle-Version: ${PV}/" > \
			"${_OSGI_T}/tmp_jar/META-INF/MANIFEST.MF"
	fi

	_java-pkg_osgi-plugin "${3}"

	jar cfm "${_OSGI_T}/osgi/${jarName}" "${_OSGI_T}/tmp_jar/META-INF/MANIFEST.MF" \
		-C "${_OSGI_T}/tmp_jar/" . > /dev/null || die "Unable to recreate the OSGi compliant jar"
	rm -rf "${_OSGI_T}/tmp_jar"
}

# -----------------------------------------------------------------------------
# @ebuild-function java-pkg_newosgijar-fromfile()
#
# This function produces an OSGi compliant jar from a given manifest file.
# The Manifest Bundle-Version header will be replaced by the current version
# of the package, unless the --no-auto-version option is given.
# It will call java-pkg_newjar at the end.
#
# @example
#	java-pkg_newosgijar "dist/${PN}.jar" "${FILESDIR}/MANIFEST.MF" "Standard Widget Toolkit for GTK 2.0"
#
# @param $opt
#	--no-auto-version - This option disables automatic rewriting of the 
#		version in the Manifest file#
# @param $1 - name of jar to repackage with OSGi
# @param $2 (optional) - name of the target jar. It will default to package name if not specified.
# @param $3 - path to the Manifest file
# @param $4 - bundle name
#
# ------------------------------------------------------------------------------

java-pkg_newosgijar-fromfile() {
	debug-print-function ${FUNCNAME} "$@"
	local versionRewriting=1

	if [[ "${1}" == "--no-auto-version" ]]; then
		versionRewriting=0
		shift
	fi
	local jarName="$(basename ${1})"
	
	if (( ${#} > 3 )); then
		_java-pkg_osgijar-fromfile "${1}" "${3}" "${4}" "${versionRewriting}"
		java-pkg_newjar "${_OSGI_T}/osgi/${jarName}" "${2}"
	else
		_java-pkg_osgijar-fromfile "$@" "${versionRewriting}"
		java-pkg_newjar "${_OSGI_T}/osgi/${jarName}"
	fi
}

# -----------------------------------------------------------------------------
# @ebuild-function java-pkg_doosgijar-fromfile()
#
# This function produces an OSGi compliant jar from a given manifestfile.
# The Manifest Bundle-Version header will be replaced by the current version
# of the package, unless the --no-auto-version option is given.
# It will call java-pkg_dojar at the end.
#
# @example
#	java-pkg_doosgijar "dist/${PN}.jar" "${FILESDIR}/MANIFEST.MF" "Standard Widget Toolkit for GTK 2.0"
#
# @param $opt
#	--no-auto-version - This option disables automatic rewriting of the 
#		version in the Manifest file
# @param $1 - name of jar to repackage with OSGi
# @param $2 - path to the Manifest file
# @param $3 - bundle name
#
# ------------------------------------------------------------------------------

java-pkg_doosgijar-fromfile() {
	debug-print-function ${FUNCNAME} "$@"
	local versionRewriting=1

	if [[ "${1}" == "--no-auto-version" ]]; then
		versionRewriting=0
		shift
	fi
	local jarName="$(basename ${1})"
	
	_java-pkg_osgijar-fromfile "$@" "${versionRewriting}"
	java-pkg_dojar "${_OSGI_T}/osgi/${jarName}"
}
