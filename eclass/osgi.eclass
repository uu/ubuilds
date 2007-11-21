# Base eclass for Java packages that needs to be OSGi compliant
# 
# Note that the main goal of this eclass was to make jars that would work with Eclipse-3.3.
# In the future however, we could imagine that a lot of packages would use this class, so that the Gentoo Java system would work very well with OSGi.
#
# Copyright (c) 2007, Jean-Noël Rivasseau <elvanor@gmail.com>
# Copyright (c) 2007, Gentoo Foundation
#
# Licensed under the GNU General Public License, v2
#
# $Header: /var/cvsroot/gentoo-x86/eclass/java-utils-2.eclass,v 1.92 2007/08/05 08:17:05 betelgeuse Exp $

# -----------------------------------------------------------------------------
# @ebuild-function java-pkg_osgi
#
# This is an internal function, not to be called directly.
#
# @example
#	java-pkg_osgi dist/${PN}.jar "com.jcraft.jsch" "com.jcraft.jsch, com.jcraft.jsch.jce;x-internal:=true" "JSch"
#
# @param $1 - name of jar to repackage with OSGi
# @param $2 - bundle symbolic name
# @param $3 - export-package-header
# @param $4 - bundle name
#
# ------------------------------------------------------------------------------
java-pkg_osgi() {

	# We define myT so that it does not contain a slash at the end.
	# According to Paludis guys, there is currently a proposal for EAPIs that would require all variables to end with a slash.

	local myT="${T/%\//}"
	
	[[ ${#} -lt 4 ]] && die "At least four arguments needed"	

	# We could replace unzip with jar
	
	mkdir "${myT}/tmp_jar"
	[[ -d "${myT}/osgi" ]] || mkdir "${myT}/osgi"
	
	unzip -q "$1" -d "${myT}/tmp_jar"
	local jar_name="$(basename $1)"

	cat > "${myT}/tmp_jar/META-INF/MANIFEST.MF" <<-EOF
Manifest-Version: 1.0
Bundle-ManifestVersion: 2
Bundle-Name: %bundleName
Bundle-Vendor: %vendorName
Bundle-Localization: plugin
Bundle-SymbolicName: ${2}
Bundle-Version: ${PV}
Export-Package: ${3}
EOF

	# We hardcode Gentoo as the vendor name

	cat > "${myT}/tmp_jar/plugin.properties" <<-EOF
bundleName=${4}
vendorName=Gentoo
EOF

	jar cfm "${myT}/osgi/${jar_name}" "${myT}/tmp_jar/META-INF/MANIFEST.MF" -C "${myT}/tmp_jar/" . > /dev/null
	rm -rf "${myT}/tmp_jar"
}

# -----------------------------------------------------------------------------
# @ebuild-function java-pkg_doosgijar
#
# Rewrites a jar, and produce an OSGi compliant jar from arguments given on the command line.
# The arguments given correspond to the minimal set of headers that must be present on a Manifest file of an OSGi package.
# If you need more headers, you should use the *-fromfile functions below, that create the Manifest from a file.
# It will call java-pkg_dojar at the end.
#
# @example
#	java-pkg_doosgijar "dist/${PN}.jar" "com.jcraft.jsch" "com.jcraft.jsch, com.jcraft.jsch.jce;x-internal:=true" "JSch"
#
# @param $1 - name of jar to repackage with OSGi
# @param $2 - bundle symbolic name
# @param $3 - export-package-header
# @param $4 - bundle name
#
# ------------------------------------------------------------------------------
java-pkg_doosgijar() {
	local myT="${T/%\//}"	
	local jar_name="$(basename $1)"	
	java-pkg_osgi "$@"
	java-pkg_dojar "${myT}/osgi/${jar_name}"
}

# -----------------------------------------------------------------------------
# @ebuild-function java-pkg_newosgijar
#
# Rewrites a jar, and produce an OSGi compliant jar.
# The arguments given correspond to the minimal set of headers that must be present on a Manifest file of an OSGi package.
# If you need more headers, you should use the *-fromfile functions below, that create the Manifest from a file.
# It will call java-pkg_newjar at the end.
#
# @example
#	java-pkg_newosgijar "dist/${PN}.jar" "com.jcraft.jsch" "com.jcraft.jsch, com.jcraft.jsch.jce;x-internal:=true" "JSch"
#
# @param $1 - name of jar to repackage with OSGi
# @param $2 - bundle symbolic name
# @param $3 - export-package-header
# @param $4 - bundle name
#
# ------------------------------------------------------------------------------
java-pkg_newosgijar() {
	local myT="${T/%\//}"
	local jar_name="$(basename $1)"	
	java-pkg_osgi "$@"
	java-pkg_newjar "${myT}/osgi/${jar_name}"
}

# -----------------------------------------------------------------------------
# @ebuild-function java-pkg_osgijar-fromfile
#
# This is an internal function, not to be called directly.
#
# @example
#	java-pkg_osgijar-fromfile "dist/${PN}.jar" "${FILESDIR}/MANIFEST.MF" "JSch" --noversion
#
# @param $1 - name of jar to repackage with OSGi
# @param $2 - path to the Manifest file
# @param $3 - bundle name
# --noversion This option disables automatic rewriting of the version in the Manifest file
#
# ------------------------------------------------------------------------------

java-pkg_osgijar-fromfile() {
	local counter=0
	local noversion=0
	local myT="${T/%\//}"

	while [[ -n "${1}" ]]; do
		if [[ "${1}" == "--noversion" ]]; then
			noversion=1
		else
			arguments[${counter}]="${1}"
			((++counter))
		fi
		shift 1
	done

	((${#arguments[@]} < 3)) && die "At least three arguments (not counting --noversion) are needed for java-pkg_osgijar-fromfile()"

	# We could replace unzip with jar

	mkdir "${myT}/tmp_jar"
	[[ -d "${myT}/osgi" ]] || mkdir "${myT}/osgi"

	unzip -q "${arguments[0]}" -d "${myT}/tmp_jar"
	local jar_name="$(basename ${arguments[0]})"

	# We automatically change the version unless --noversion is present

	if [[ "${noversion}" == 1 ]]; then
		cat "${arguments[1]}" > "${myT}/tmp_jar/META-INF/MANIFEST.MF"
	else
		cat "${arguments[1]}" | sed "s/Bundle-Version:.*/Bundle-Version: ${PV}/" > "${myT}/tmp_jar/META-INF/MANIFEST.MF"
	fi

	# We hardcode Gentoo as the vendor name

	cat > "${myT}/tmp_jar/plugin.properties" <<-EOF
bundleName="${arguments[2]}"
vendorName=Gentoo
EOF

	jar cfm "${myT}/osgi/${jar_name}" "${myT}/tmp_jar/META-INF/MANIFEST.MF" -C "${myT}/tmp_jar/" . > /dev/null
	rm -rf "${myT}/tmp_jar"
}


# -----------------------------------------------------------------------------
# @ebuild-function java-pkg_newosgijar-fromfile()
#
# This function produces an OSGi compliant jar from a given manifest file.
# The Manifest Bundle-Version header will be replaced by the current version of the package, unless the --noversion argument is given.
# It will call java-pkg_newjar at the end.
#
# @example
#	java-pkg_newosgijar "dist/${PN}.jar" "${FILESDIR}/MANIFEST.MF" "Standard Widget Toolkit for GTK 2.0"
#
# @param $1 - name of jar to repackage with OSGi
# @param $2 (optional) - name of the target jar. It will default to package name if not specified.
# @param $3 - path to the Manifest file
# @param $4 - bundle name
# --noversion This option disables automatic rewriting of the version in the Manifest file
#
# ------------------------------------------------------------------------------
java-pkg_newosgijar-fromfile() {
	local myT="${T/%\//}"
	local jar_name="$(basename $1)"
	if [[ ${#} > 3 ]]; then
		local newName="$2"
		local arguments=("$@")
		unset arguments[1]
		java-pkg_osgijar-fromfile "${arguments[@]}"
		java-pkg_newjar "${myT}/osgi/${jar_name}"	"${newName}"
	else
		java-pkg_osgijar-fromfile "$@"
		java-pkg_newjar "${myT}/osgi/${jar_name}"
	fi
}

# -----------------------------------------------------------------------------
# @ebuild-function java-pkg_doosgijar-fromfile()
#
# This function produces an OSGi compliant jar from a given manifestfile.
# The Manifest Bundle-Version header will be replaced by the current version of the package, unless the --noversion argument is given.
# It will call java-pkg_dojar at the end.
#
# @example
#	java-pkg_doosgijar "dist/${PN}.jar" "${FILESDIR}/MANIFEST.MF" "Standard Widget Toolkit for GTK 2.0"
#
# @param $1 - name of jar to repackage with OSGi
# @param $2 - path to the Manifest file
# @param $3 - bundle name
# --noversion This option disables automatic rewriting of the version in the Manifest file
#
# ------------------------------------------------------------------------------

java-pkg_doosgijar-fromfile() {
	local myT="${T/%\//}"
	local jar_name="$(basename $1)"
	java-pkg_osgijar-fromfile "$@"
	java-pkg_dojar "${myT}/osgi/${jar_name}"
}