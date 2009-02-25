# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
if ! [[ -n "${LUCENE_MODULE}" ]]; then LUCENE_MODULE=${PN/lucene-/}; fi
JAVA_PKG_IUSE="source test"
JAVA_PKG_BSFIX_NAME="build.xml common-build.xml contrib-build.xml"
inherit java-pkg-2 java-ant-2 java-osgi

# -----------------------------------------------------------------------------
# @eclass-begin
# @eclass-shortdesc Lucene-Contrib packages eclass
#
# This eclass is the base for all of the packages in lucene's contrib dir
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# @variable-preinherit SLOT
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
WANT_JAVA_VER=${WANT_JAVA_VER:-1.4}

# -----------------------------------------------------------------------------
# @variable-preinherit SLOT
# @variable-default unset
#
# Please define the SLOT of each package before inherit
# -----------------------------------------------------------------------------
#SLOT

HOMEPAGE="http://jakarta.apache.org/lucene"
SRC_URI="mirror://apache/lucene/java/lucene-${PV}-src.tar.gz"
LICENSE="Apache-2.0"

DEPEND=">=virtual/jdk-${WANT_JAVA_VER}
	dev-java/lucene:${SLOT}
	test? ( dev-java/ant-junit dev-java/junit:0 )"
RDEPEND=">=virtual/jre-${WANT_JAVA_VER}
	 dev-java/lucene:${SLOT}"

for dep in ${LUCENE_MODULE_DEPS}; do
	DEPEND="${DEPEND} dev-java/lucene-${dep}:${SLOT}"
	RDEPEND="${RDEPEND} dev-java/lucene-${dep}:${SLOT}"
done
S="${WORKDIR}/lucene-${PV}"

# ------------------------------------------------------------------------------
# @internal-function lucene-contrib_getlucenejar_params_
#
# determines wether to use lucene.jar or lucene-core.jar
# ------------------------------------------------------------------------------
lucene-contrib_getlucenejar_params_ () {
	if [[ "${SLOT}" = "1" || "${SLOT}" = "1.9" ]]; then
		echo lucene-${SLOT} lucene.jar
	else
		echo lucene-${SLOT} lucene-core.jar
	fi
}

# ------------------------------------------------------------------------------
# @internal-function lucene-contrib_getlucenejar_
#
# gets the lucene(-core).jar
# ------------------------------------------------------------------------------
lucene-contrib_getlucenejar_ () {
	java-pkg_getjar $(lucene-contrib_getlucenejar_params_)
}

# ------------------------------------------------------------------------------
# @internal-function lucene-contrib_symlinklucenejar_
#
# symlinks the lucene-core.jar for use during the contrib ebuild
# ------------------------------------------------------------------------------
lucene-contrib_symlinklucenejar_ () {
	java-pkg_jar-from $(lucene-contrib_getlucenejar_params_) lucene-core-${PV}.jar
}

# ------------------------------------------------------------------------------
# @eclass-src_unpack
#
# Default src_unpack for lucene-contrib packages
# ------------------------------------------------------------------------------
lucene-contrib_src_unpack() {
	unpack ${A}
	cd "${S}" || die
	einfo "Removing bundled jars."
	find "${S}" -name "*.jar" -delete -print
	mkdir build || die
	cd build || die
	lucene-contrib_symlinklucenejar_
}

# ------------------------------------------------------------------------------
# @eclass-src_compile
#
# Default src_compile for lucene-contrib packages
# ------------------------------------------------------------------------------
lucene-contrib_src_compile() {
	local lucene_jar=$(lucene-contrib_getlucenejar_)
	cd contrib/${LUCENE_MODULE}
	for dep in ${LUCENE_MODULE_DEPS}; do
		local pdep=$(java-pkg_getjars lucene-${dep}-${SLOT} )
		gcp="${gcp}:${pdep}"
	done

	for dep in ${LUCENE_EXTRA_DEPS}; do
		local pdep=$(java-pkg_getjars ${dep} )
		gcp="${gcp}:${pdep}"
	done

	eant -Dversion=${PV} \
		-Dproject.classpath="${gcp}:${lucene_jar}" \
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
	java-ant_rewrite-classpath common-build.xml
	java-ant_rewrite-classpath build.xml
	cd contrib && java-ant_rewrite-classpath contrib-build.xml
	cd ${LUCENE_MODULE} && java-ant_rewrite-classpath build.xml
	local lucene_jar=$(lucene-contrib_getlucenejar_)
	local gcp="${lucene_jar}"
	gcp="${gcp}:$(java-pkg_getjars junit)"
	for dep in ${LUCENE_MODULE_DEPS}; do
		local pdep=$(java-pkg_getjars lucene-${dep}-${SLOT} )
		gcp="${gcp}:${pdep}"
	done

	for dep in ${LUCENE_EXTRA_DEPS}; do
		local pdep=$(java-pkg_getjars ${dep} )
		gcp="${gcp}:${pdep}"
	done

	ANT_TASKS="ant-junit" eant -Dproject.classpath="${gcp}" \
		-Dlucene.jar="${lucene_jar}" test
}

# ------------------------------------------------------------------------------
# @eclass-src_install
#
# Default src_install for lucene-contrib packages
# ------------------------------------------------------------------------------
lucene-contrib_src_install() {
	java-pkg_newjar build/contrib/${LUCENE_MODULE}/lucene-${LUCENE_MODULE}-${PV}.jar ${PN}.jar
	cd contrib/${LUCENE_MODULE}
	[[ -n "${DOCS}" ]] && dodoc ${DOCS}
	use source && java-pkg_dosrc src/java/*
}

EXPORT_FUNCTIONS src_unpack src_compile src_test src_install

# ------------------------------------------------------------------------------
# @eclass-end
# ------------------------------------------------------------------------------
