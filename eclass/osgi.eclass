
# -----------------------------------------------------------------------------
# @ebuild-function java-pkg_osgi
#
# Rewrites a jar, and produce an OSGi compliant jar.
# Note that currently the main goal of this eclass was to make jars that would work with Eclipse-3.3.
# It will call java-pkg_dojar at the end.
#
# @example
#	java-pkg_osgi dist/${PN}.jar "com.jcraft.jsch" "com.jcraft.jsch, com.jcraft.jsch.jce;x-internal:=true" "JSch" "JCraft, Inc."
#
# @param $1 - name of jar to repackage with OSGi
# @param $2 - bundle symbolic name
# @param $3 - export-package-header
# @param $4 - bundle name
# @param $5 - vendor name (this could always be set to 'Gentoo')
# ------------------------------------------------------------------------------
java-pkg_osgi() {
	
	[[ ${#} -lt 5 ]] && die "At least five arguments needed"	

	# Do with jar instead of unzip later

	mkdir "${T}/tmp_jar"
	mkdir "${T}/osgi"	
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

cat > "${T}/tmp_jar/plugin.properties" <<-EOF
bundleName=${4}
vendorName=${5}
EOF

	if [[ -n ${6} ]]; then
		echo ${6} >> "${T}/tmp_jar/META-INF/MANIFEST.MF" 
	fi

	jar cvfm "${T}/osgi/${jar_name}" "${T}/tmp_jar/META-INF/MANIFEST.MF" -C "${T}/tmp_jar/" . > /dev/null
}

# -----------------------------------------------------------------------------
# @ebuild-function java-pkg_doosgijar
#
# Rewrites a jar, and produce an OSGi compliant jar.
# Note that currently the main goal of this eclass was to make jars that would work with Eclipse-3.3.
# It will call java-pkg_dojar at the end.
#
# @example
#	java-pkg_doosgijar dist/${PN}.jar "com.jcraft.jsch" "com.jcraft.jsch, com.jcraft.jsch.jce;x-internal:=true" "JSch" "JCraft, Inc."
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
# It will call java-pkg_dojar at the end.
#
# @example
#	java-pkg_doosgijar dist/${PN}.jar "com.jcraft.jsch" "com.jcraft.jsch, com.jcraft.jsch.jce;x-internal:=true" "JSch" "JCraft, Inc."
#
# @param $1 - name of jar to repackage with OSGi
# @param $2 - bundle symbolic name
# @param $3 - export-package-header
# @param $4 - bundle name
# @param $5 - vendor name
# ------------------------------------------------------------------------------
java-pkg_newosgijar() {
	local jar_name="$(basename $1)"	
	java-pkg_osgi "$@"
	java-pkg_newjar "${T}/osgi/${jar_name}"
}

# -----------------------------------------------------------------------------
# @ebuild-function java-pkg_newosgijar-fromfile()
#
# This function produces an OSGi compliant jar from a given MANIFEST.MF file
# Note that currently the main goal of this eclass was to make jars that would work with Eclipse-3.3.
# It will call java-pkg_newjar at the end.
#
# @example
#	java-pkg_doosgijar dist/${PN}.jar "${FILESDIR}/MANIFEST.MF" "Standard Widget Toolkit for GTK 2.0"
#
# @param $1 - name of jar to repackage with OSGi
# @param $1 - path to Manifest file
# @param $2 - bundle name
#
# ------------------------------------------------------------------------------
java-pkg_newosgijar-fromfile() {
	
	[[ ${#} -lt 3 ]] && die "At least three arguments needed for java-pkg_newosgijar-fromfile()"	

	# Do with jar instead of unzip later

	mkdir "${T}/tmp_jar"
	mkdir "${T}/osgi"	
	unzip -q "$1" -d "${T}/tmp_jar"
	local jar_name="$(basename $1)"

	cat "${2}" > "${T}/tmp_jar/META-INF/MANIFEST.MF"

	# We hardcode Gentoo as the vendor name

	cat > "${T}/tmp_jar/plugin.properties" <<-EOF
bundleName=${3}
vendorName=Gentoo
EOF

	jar cvfm "${T}/osgi/${jar_name}" "${T}/tmp_jar/META-INF/MANIFEST.MF" -C "${T}/tmp_jar/" . > /dev/null

	java-pkg_newjar "${T}/osgi/${jar_name}"
}