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
# ------------------------------------------------------------------------------
java-pkg_osgi() {
	
	[[ ${#} -lt 4 ]] && die "At least four arguments needed"	

	# We could replace unzip with jar
	
	mkdir "${T}/tmp_jar"
	[[ -d "${T}/osgi" ]] || mkdir "${T}/osgi"
	
	unzip -q "$1" -d "${T}/tmp_jar"
	local jar_name="$(basename $1)"
	
	# Required arguments: symbolicName	

	cat > "${T}/tmp_jar/META-INF/MANIFEST.MF" <<-EOF
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

	cat > "${T}/tmp_jar/plugin.properties" <<-EOF
bundleName=${4}
vendorName=Gentoo
EOF

	jar cfm "${T}/osgi/${jar_name}" "${T}/tmp_jar/META-INF/MANIFEST.MF" -C "${T}/tmp_jar/" . > /dev/null
	rm -rf "${T}/tmp_jar"
}

# -----------------------------------------------------------------------------
# @ebuild-function java-pkg_doosgijar
#
# Rewrites a jar, and produce an OSGi compliant jar.
# Note that currently the main goal of this eclass was to make jars that would work with Eclipse-3.3.
# It will call java-pkg_dojar at the end.
#
# @example
#	java-pkg_doosgijar dist/${PN}.jar "com.jcraft.jsch" "com.jcraft.jsch, com.jcraft.jsch.jce;x-internal:=true" "JSch"
#
# ------------------------------------------------------------------------------
java-pkg_doosgijar() {
	local jar_name="$(basename $1)"	
	java-pkg_osgi "$@"
	java-pkg_dojar "${T}/osgi/${jar_name}"
}


# -----------------------------------------------------------------------------
# @ebuild-function java-pkg_newosgijar
#
# Rewrites a jar, and produce an OSGi compliant jar.
# Note that currently the main goal of this eclass was to make jars that would work with Eclipse-3.3.
# It will call java-pkg_newjar at the end.
#
# @example
#	java-pkg_newosgijar dist/${PN}.jar "com.jcraft.jsch" "com.jcraft.jsch, com.jcraft.jsch.jce;x-internal:=true" "JSch"
#
# ------------------------------------------------------------------------------
java-pkg_newosgijar() {
	local jar_name="$(basename $1)"	
	java-pkg_osgi "$@"
	java-pkg_newjar "${T}/osgi/${jar_name}"
}

# -----------------------------------------------------------------------------
# @ebuild-function java-pkg_osgijar-fromfile
#
# This is an internal function, not to be called directly.
#
# @example
#	java-pkg_osgijar-fromfile dist/${PN}.jar "${FILESDIR}/MANIFEST.MF" "JSch"
#
# @param $1 - name of jar to repackage with OSGi
# @param $2 - path to the Manifest file
# @param $3 - bundle name
#
# It can accept an additional option, --noversion
# ------------------------------------------------------------------------------

java-pkg_osgijar-fromfile() {
	local counter=0
	local noversion=0	
	
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

	mkdir "${T}/tmp_jar"
	[[ -d "${T}/osgi" ]] || mkdir "${T}/osgi"

	unzip -q "${arguments[0]}" -d "${T}/tmp_jar"
	local jar_name="$(basename ${arguments[0]})"

	# We automatically change the version unless --noversion is present

	if [[ noversion == 1 ]]; then
		cat "${arguments[1]}" > "${T}/tmp_jar/META-INF/MANIFEST.MF"
	else
		cat "${arguments[1]}" | sed "s/Bundle-Version:.*/Bundle-Version: ${PV}/" > "${T}/tmp_jar/META-INF/MANIFEST.MF"
	fi
	
	# We hardcode Gentoo as the vendor name

	cat > "${T}/tmp_jar/plugin.properties" <<-EOF
bundleName="${arguments[2]}"
vendorName=Gentoo
EOF

	jar cfm "${T}/osgi/${jar_name}" "${T}/tmp_jar/META-INF/MANIFEST.MF" -C "${T}/tmp_jar/" . > /dev/null
	rm -rf "${T}/tmp_jar"
}


# -----------------------------------------------------------------------------
# @ebuild-function java-pkg_newosgijar-fromfile()
#
# This function produces an OSGi compliant jar from a given MANIFEST.MF file
# Note that currently the main goal of this eclass was to make jars that would work with Eclipse-3.3.
# It will call java-pkg_newjar at the end.
#
# @example
#	java-pkg_newosgijar dist/${PN}.jar "${FILESDIR}/MANIFEST.MF" "Standard Widget Toolkit for GTK 2.0"
#
#
# ------------------------------------------------------------------------------
java-pkg_newosgijar-fromfile() {
	local jar_name="$(basename $1)"	
	if [[ ${#} > 3 ]]; then
		local newName="$2"
		local arguments=("$@")
		unset arguments[1]
		java-pkg_osgijar-fromfile "${arguments[@]}"
		java-pkg_newjar "${T}/osgi/${jar_name}"	"${newName}"	
	else
		java-pkg_osgijar-fromfile "$@"
		java-pkg_newjar "${T}/osgi/${jar_name}"		
	fi
}

# -----------------------------------------------------------------------------
# @ebuild-function java-pkg_doosgijar-fromfile()
#
# This function produces an OSGi compliant jar from a given MANIFEST.MF file
# Note that currently the main goal of this eclass was to make jars that would work with Eclipse-3.3.
# It will call java-pkg_dojar at the end.
#
# @example
#	java-pkg_doosgijar dist/${PN}.jar "${FILESDIR}/MANIFEST.MF" "Standard Widget Toolkit for GTK 2.0"
#
#
# ------------------------------------------------------------------------------

java-pkg_doosgijar-fromfile() {
	local jar_name="$(basename $1)"	
	java-pkg_osgijar-fromfile "$@"
	java-pkg_dojar "${T}/osgi/${jar_name}"
}