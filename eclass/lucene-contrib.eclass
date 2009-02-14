# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
if ! [[ -n "${LUCENE_MODULE}" ]]; then LUCENE_MODULE=${PN/lucene-/}; fi
JAVA_PKG_IUSE="source test"
JAVA_PKG_BSFIX_ALL="no"
inherit java-pkg-2 java-ant-2 java-osgi

HOMEPAGE="http://jakarta.apache.org/lucene"
SRC_URI="mirror://apache/lucene/java/lucene-${PV}-src.tar.gz"
LICENSE="Apache-2.0"

DEPEND=">=virtual/jdk-1.4
	dev-java/lucene:${SLOT}
	test? ( dev-java/ant-junit dev-java/junit:0 )"
RDEPEND=">=virtual/jdk-1.4
	 dev-java/lucene:${SLOT}"

for dep in ${LUCENE_MODULE_DEPS}; do
	DEPEND="${DEPEND} dev-java/lucene-${dep}:${SLOT}"
	RDEPEND="${RDEPEND} dev-java/lucene-${dep}:${SLOT}"
done
S="${WORKDIR}/lucene-${PV}"

lucene-contrib_getlucenejar_params_ () {
	if [[ "${SLOT}" = "1" || "${SLOT}" = "1.9" ]]; then
		echo lucene-${SLOT} lucene.jar
	else
		echo lucene-${SLOT} lucene-core.jar
	fi
}

lucene-contrib_getlucenejar_ () {
	java-pkg_getjar $(lucene-contrib_getlucenejar_params_)
}

lucene-contrib_symlinklucenejar_ () {
	java-pkg_jar-from $(lucene-contrib_getlucenejar_params_) lucene-core-${PV}.jar
}

lucene-contrib_src_unpack() {
	unpack ${A}
	cd "${S}" || die
	einfo "Removing bundled jars."
	find "${S}" -name "*.jar" -delete -print
	mkdir build || die
	cd build || die
	lucene-contrib_symlinklucenejar_
}

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
}

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

lucene-contrib_src_install() {
	if [[ -f "${FILESDIR}/${P}.manifest" && -n "${LUCENE_OSGI_BUNDLENAME}" ]]; then
		java-osgi_newjar-fromfile \
			build/contrib/${LUCENE_MODULE}/lucene-${LUCENE_MODULE}-${PV}.jar \
			${PN}.jar \
			"${FILESDIR}/${P}.manifest" \
			"${LUCENE_OSGI_BUNDLENAME}"
	else
		java-pkg_newjar build/contrib/${LUCENE_MODULE}/lucene-${LUCENE_MODULE}-${PV}.jar ${PN}.jar
	fi
	cd contrib/${LUCENE_MODULE}
	[[ -n "${DOCS}" ]] && dodoc ${DOCS}
	use source && java-pkg_dosrc src/java/*
}

EXPORT_FUNCTIONS src_unpack src_compile src_test src_install
