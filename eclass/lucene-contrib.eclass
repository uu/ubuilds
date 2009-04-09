# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

if ! [[ -n "${LUCENE_MODULE}" ]]; then LUCENE_MODULE="${PN/lucene-/}"; fi
JAVA_PKG_IUSE="source test"
JAVA_PKG_BSFIX_NAME="build.xml common-build.xml contrib-build.xml"
inherit java-pkg-2 java-ant-2 java-osgi

case "${EAPI:-0}" in
	0)
		die "EAPI 0 is not supported by lucene-contrib eclass."
		;;
	1)
		EXPORT_FUNCTIONS src_unpack src_compile src_test src_install
		;;
	*)
		EXPORT_FUNCTIONS src_unpack src_prepare src_compile src_test src_install
		;;
esac

# -----------------------------------------------------------------------------
# @eclass-begin
# @eclass-shortdesc Lucene-Contrib packages eclass
#
# This eclass is the base for all of the packages in lucene's contrib dir for
# SLOTS 2.* and higher (This does not handler 1.* SLOTS)
# -----------------------------------------------------------------------------
if [[ "${SLOT/.*}" -lt "2" ]]; then return 1; fi

# -----------------------------------------------------------------------------
# @variable-preinherit LUCENE_MODULE
# @variable-default PN minus lucene-
#
# If the name of the lucene-contrib package differs from "lucene-foo' specify
# this variable
# -----------------------------------------------------------------------------
#LUCENE_MODULE

# -----------------------------------------------------------------------------
# @variable-preinherit WANT_JAVA_VER
# @variable-default 1.4
#
# Set this variable to the minimum Java version required, which will affect the
# DEPEND and RDEPEND of the package. Note: this should be staticly set before
# inherit. It should not be dynamicly set based on useflags (setting it
# dynamically based on useflags is prohibitied).
# -----------------------------------------------------------------------------
WANT_JAVA_VER="${WANT_JAVA_VER:-1.4}"

# -----------------------------------------------------------------------------
# @variable-preinherit SLOT
# @variable-default unset
#
# Please define the SLOT of each package before inherit
# -----------------------------------------------------------------------------
#SLOT

HOMEPAGE="http://lucene.apache.org/"
SRC_URI="mirror://apache/lucene/java/lucene-${PV}-src.tar.gz"
LICENSE="Apache-2.0"

DEPEND=">=virtual/jdk-${WANT_JAVA_VER}
	dev-java/lucene:${SLOT}
	test? ( dev-java/ant-junit dev-java/junit:0 )"
RDEPEND=">=virtual/jre-${WANT_JAVA_VER}
	dev-java/lucene:${SLOT}"

# -----------------------------------------------------------------------------
# @variable-preinherit LUCENE_MODULE_DEPS
# @variable-default unset
#
# Contains a space delimited list of lucene-contrib packages without the
# associated "lucene-" prefix. Use this instead of declaring them in an
# [R]DEPEND
# -----------------------------------------------------------------------------
for dep in ${LUCENE_MODULE_DEPS}; do
	DEPEND="${DEPEND} dev-java/lucene-${dep}:${SLOT}"
	RDEPEND="${RDEPEND} dev-java/lucene-${dep}:${SLOT}"
done

# -----------------------------------------------------------------------------
# @variable LUCENE_EXTRA_DEPS
# @variable-default unset
#
# Contains a space delimited list of packages (which can be either just a
# package name or a package-name-SLOT) that this package needs to have in its
# classpath. Unlike LUCENE_MODULE_DEPS, declaring such deps in [R]DEPEND in the
# ebuild is mandatory.
# -----------------------------------------------------------------------------

S="${WORKDIR}/lucene-${PV}"

# ------------------------------------------------------------------------------
# @internal-function lucene-contrib_getlucenejar_
#
# gets the lucene-core.jar
# ------------------------------------------------------------------------------
lucene-contrib_getlucenejar_() {
	java-pkg_getjar lucene-"${SLOT}" lucene-core.jar
}

# ------------------------------------------------------------------------------
# @internal-function lucene-contrib_symlinklucenejar_
#
# symlinks the lucene-core.jar for use during the contrib ebuild
# ------------------------------------------------------------------------------
lucene-contrib_symlinklucenejar_() {
	java-pkg_jar-from lucene-"${SLOT}" lucene-core.jar lucene-core-"${PV}".jar
}

# ------------------------------------------------------------------------------
# @internal-function lucene-contrib_classpath_
#
# Generates the LUCENE_MODULE specific classpath based on LUCENE_MODULE_DEPS and
# LUCENE_EXTRA_DEPS (see variable definition above). This function doesn't take
# any args. returns classpath
# ------------------------------------------------------------------------------
lucene-contrib_classpath_() {
	for dep in ${LUCENE_MODULE_DEPS}; do
		local pdep=$(java-pkg_getjars "lucene-${dep}-${SLOT}" )
		gcp="${gcp}:${pdep}"
	done

	for dep in ${LUCENE_EXTRA_DEPS}; do
		local pdep=$(java-pkg_getjars "${dep}" )
		gcp="${gcp}:${pdep}"
	done

	echo "${gcp}"
}


# ------------------------------------------------------------------------------
# @eclass-src_unpack
#
# Default src_unpack for lucene-contrib packages
# ------------------------------------------------------------------------------
lucene-contrib_src_unpack() {
	unpack ${A}
	cd "${S}" || die
	has ${EAPI:-0} 0 1 && lucene-contrib_src_prepare
	cd "${WORKDIR}" || die
}

# ------------------------------------------------------------------------------
# @eclass-src_prepare
#
# Default src_prepare for lucene-contrib packages
# ------------------------------------------------------------------------------
lucene-contrib_src_prepare() {
	einfo "Removing bundled jars."
	find "${S}" -name "*.jar" -delete -print
	
	mkdir build || die
	cd build || die

	lucene-contrib_symlinklucenejar_
	for dep in ${LUCENE_MODULE_DEPS}; do
		mkdir -p contrib/"${dep}" || die
		cd contrib/"${dep}" || die
		java-pkg_jar-from "lucene-${dep}-${SLOT}" lucene-"${dep}".jar \
		lucene-"${dep}-${PV}".jar
	done
}

# ------------------------------------------------------------------------------
# @eclass-src_compile
#
# Default src_compile for lucene-contrib packages
# ------------------------------------------------------------------------------
lucene-contrib_src_compile() {
	local lucene_jar=$(lucene-contrib_getlucenejar_)
	cd contrib/"${LUCENE_MODULE}" || die

	local lucene_cp="$(lucene-contrib_classpath_)"

	eant -Dversion="${PV}" \
		-Dproject.classpath="${lucene_cp}:${lucene_jar}" \
		-Dlucene.jar="${lucene_jar}" \
		jar-core
	cd "${S}" || die
}

# ------------------------------------------------------------------------------
# @eclass-src_test
#
# Default src_test for lucene-contrib packages
# ------------------------------------------------------------------------------
lucene-contrib_src_test() {
	cd contrib/"${LUCENE_MODULE}" || die

	local lucene_jar=$(lucene-contrib_getlucenejar_)
	local gcp="${lucene_jar}"
	gcp="${gcp}:$(java-pkg_getjars junit)"

	local lucene_cp="$(lucene-contrib_classpath_)"
	lucene_cp="${gcp}:${lucene_cp}"

	ANT_TASKS="ant-junit" eant -Dversion="${PV}" \
		-Dproject.classpath="${lucene_cp}" \
		-Dlucene.jar="${lucene_jar}" test
}

# ------------------------------------------------------------------------------
# @eclass-src_install
#
# Default src_install for lucene-contrib packages
# ------------------------------------------------------------------------------
lucene-contrib_src_install() {
	java-pkg_newjar "build/contrib/${LUCENE_MODULE}/lucene-${LUCENE_MODULE}-${PV}.jar" "${PN}.jar"
	cd contrib/"${LUCENE_MODULE}" || die

	DDOCS="README.txt README readme.txt readme"
	for doc in "${DDOCS}"; do
		[[ -f ${doc} ]] && DOCS="${DOCS} ${doc}"
	done

	if [[ -n "${DOCS}" ]]; then
		dodoc ${DOCS} || die
	fi
	use source && java-pkg_dosrc src/java/*
}

# ------------------------------------------------------------------------------
# @eclass-end
# ------------------------------------------------------------------------------
