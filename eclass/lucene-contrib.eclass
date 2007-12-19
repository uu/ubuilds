# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

if ! [[ -n "${LUCENE_MODULE}" ]]; then LUCENE_MODULE=${PN/lucene-/}; fi
JAVA_PKG_IUSE="source test"
JAVA_PKG_BSFIX_ALL="no"
#WANT_SPLIT_ANT="true" ?
inherit java-pkg-2 java-ant-2

HOMEPAGE="http://jakarta.apache.org/lucene"
SRC_URI="mirror://apache/lucene/java/lucene-${PV}-src.tar.gz"
LICENSE="Apache-2.0"

DEPEND=">=virtual/jdk-1.4
	=dev-java/lucene-${SLOT}*
	test? ( dev-java/ant-junit =dev-java/junit-3* )"
RDEPEND=">=virtual/jdk-1.4
	 =dev-java/lucene-${SLOT}*"

for dep in ${LUCENE_MODULE_DEPS}; do
	DEPEND="${DEPEND} =dev-java/lucene-${dep}-${SLOT}*"
	RDEPEND="${RDEPEND} =dev-java/lucene-${dep}-${SLOT}*"
done
S="${WORKDIR}/lucene-${PV}"

lucene-contrib_src_compile() {
	local gcp=$(java-pkg_getjar lucene-${SLOT} lucene-core.jar)
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
		-Dproject.classpath="${gcp}" \
		-Dlucene.jar=$(java-pkg_getjar lucene-${SLOT} lucene-core.jar) \
	jar-core
}

lucene-contrib_src_test() {
	java-ant_rewrite-classpath common-build.xml
	java-ant_rewrite-classpath build.xml
	cd contrib && java-ant_rewrite-classpath contrib-build.xml
	cd ${LUCENE_MODULE} && java-ant_rewrite-classpath build.xml
	local gcp=$(java-pkg_getjar lucene-${SLOT} lucene-core.jar)
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
		-Dlucene.jar=$(java-pkg_getjar lucene-${SLOT} lucene-core.jar) test
}

lucene-contrib_src_install() {
	java-pkg_newjar build/contrib/${LUCENE_MODULE}/lucene-${LUCENE_MODULE}-${PV}.jar ${PN}.jar
	cd contrib/${LUCENE_MODULE}
	[[ -n "${DOCS}" ]] && dodoc ${DOCS}
	use source && java-pkg_dosrc src/java/org
}

EXPORT_FUNCTIONS src_compile src_test src_install
