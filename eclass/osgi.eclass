
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
# @param $1 - name of jar to repackage with OSGi
# @param $2 - bundle symbolic name
# @param $3 - export-package-header
# @param $4 - bundle name
# @param $5 - vender name
# ------------------------------------------------------------------------------
java-pkg_doosgijar() {
	
	[[ ${#} -lt 5 ]] && die "At least five arguments needed"	

	# Do with jar instead of unzip later

	mkdir "${T}/tmp_jar"
	unzip -q "$1" -d "${T}/tmp_jar"
	local jar_name="$(basename $1)"
	
# Required arguments: symbolicName	

cat > "${T}/tmp_jar/META-INF/MANIFEST.MF" <<-EOF
Manifest-Version: 1.0
Bundle-ManifestVersion: 2
Bundle-Name: %pluginName
Bundle-Vendor: %providerName
Bundle-Localization: plugin
Bundle-Version: ${PV}
Bundle-SymbolicName: "${2}"
Export-Package: "${3}"
EOF

cat > "${T}/tmp_jar/plugin.properties" <<-EOF
bundleName="${4}"
venderName="${5}"
EOF

	if [[ -n ${6} ]]; then
		einfo "Using OSGi"
		echo ${6} >> "${T}/tmp_jar/META-INF/MANIFEST.MF" 
	fi

	# Here this should not be ${PN}, but the name of the original jar

	jar cvfm "${T}/${jar_name}" "${T}/tmp_jar/META-INF/MANIFEST.MF" -C "${T}/tmp_jar/" . > /dev/null
	java-pkg_dojar "${T}/${jar_name}"
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
# @param $5 - vender name
# ------------------------------------------------------------------------------
java-pkg_newosgijar() {
	
	[[ ${#} -lt 5 ]] && die "At least five arguments needed"	

	# Do with jar instead of unzip later

	mkdir "${T}/tmp_jar"
	unzip -q "$1" -d "${T}/tmp_jar"
	local jar_name="$(basename $1)"
	
# Required arguments: symbolicName	

cat > "${T}/tmp_jar/META-INF/MANIFEST.MF" <<-EOF
Manifest-Version: 1.0
Bundle-ManifestVersion: 2
Bundle-Name: %pluginName
Bundle-Vendor: %providerName
Bundle-Localization: plugin
Bundle-Version: ${PV}
Bundle-SymbolicName: "${2}"
Export-Package: "${3}"
EOF

cat > "${T}/tmp_jar/plugin.properties" <<-EOF
bundleName="${4}"
venderName="${5}"
EOF

	if [[ -n ${6} ]]; then
		einfo "Using OSGi"
		echo ${6} >> "${T}/tmp_jar/META-INF/MANIFEST.MF" 
	fi

	# Here this should not be ${PN}, but the name of the original jar

	jar cvfm "${T}/${jar_name}" "${T}/tmp_jar/META-INF/MANIFEST.MF" -C "${T}/tmp_jar/" . > /dev/null
	java-pkg_newjar "${T}/${jar_name}"
}