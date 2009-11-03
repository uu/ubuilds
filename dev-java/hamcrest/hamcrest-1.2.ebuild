# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="examples test"
inherit java-pkg-2 java-ant-2

DESCRIPTION="Library of matchers for building test expressions."
HOMEPAGE="http://code.google.com/p/${MY_PN}/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tgz"
LICENSE="BSD-2"
SLOT="1.2"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE=""

CDEPEND="
	~dev-java/hamcrest-core-${PV}
	~dev-java/hamcrest-library-${PV}
	~dev-java/hamcrest-integration-${PV}"
DEPEND=">=virtual/jdk-1.5
	userland_GNU? ( sys-apps/findutils )
	test? (
		~dev-java/hamcrest-generator-${PV}
		dev-java/junit:4
		dev-java/ant-junit4
		dev-java/easymock:2
		dev-java/jmock:1.0
	)
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

JAVA_ANT_REWRITE_CLASSPATH=1
JAVA_ANT_CLASSPATH_TAGS="${JAVA_ANT_CLASSPATH_TAGS} java-to-jar"

java_prepare() {
	# Don't include source in JAR.  If a Gentoo user wants the source the source
	# USE flag will be enabled
	epatch "${FILESDIR}/hamcrest-1.2-no_source_in_jar.patch"
	# Empty out the contents of the generator target; it has already been built.
	epatch "${FILESDIR}/hamcrest-1.2-empty_generator.patch"
	# Empty out the contents of the core target; it has already been built.
	epatch "${FILESDIR}/hamcrest-1.2-empty_core.patch"
	# Empty out the contents of the library target; it has already been built.
	epatch "${FILESDIR}/hamcrest-1.2-empty_library.patch"
	# Empty out the contents of the integration target; it has already been built.
	epatch "${FILESDIR}/hamcrest-1.2-empty_integration.patch"

	find -iname "*.jar" -exec rm -v {} + || die "Failed to remove bundled JARs"
}

src_compile() {
	einfo "Nothing to do..."
}

src_test() {
	ANT_TASKS="ant-junit4"
	eant unit-test \
		-Dversion="${PV}" \
		-Dgentoo.classpath="$(java-pkg_getjars --build-only --with-dependencies hamcrest-generator-${SLOT}):\
			$(java-pkg_getjars hamcrest-core-${SLOT},hamcrest-library-${SLOT},hamcrest-integration-${SLOT}):\
			$(java-pkg_getjars --build-only junit-4,easymock-2,jmock-1.0)"
}

src_install() {
	dodoc README.txt CHANGES.txt

	use examples && java-pkg_doexamples ${PN}-examples
}
