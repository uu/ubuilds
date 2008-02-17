# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Guice is a lightweight dependency injection framework for Java 5 and above."
HOMEPAGE="http://code.google.com/p/google-guice/"
SRC_URI="http://google-guice.googlecode.com/files/${P}-src.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="dev-java/aopalliance
		=dev-java/asm-3*
		=dev-java/cglib-2.2_beta1*"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"
DEPEND=">=virtual/jdk-1.5
	test? ( dev-java/junit )
	${COMMON_DEPEND}"

S="${WORKDIR}"

# TODO make these work
RESTRICT="test"

JAVA_PKG_BSFIX_NAME="build.xml common.xml"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/build_xml.patch"

	einfo "Removing bundled jars and classes"
	find "${S}" '(' -name '*.class' -o -name '*.jar' ')' -print -delete

	java-ant_rewrite-classpath common.xml
}

EANT_GENTOO_CLASSPATH="aopalliance-1,cglib-2.2,asm-3"

src_test() {
	java-pkg_jar-from --into lib/build junit
	ANT_TASKS="" eant test
}

src_install() {
	java-pkg_newjar build/dist/${P}.jar ${PN}.jar

	use doc && java-pkg_dojavadoc javadoc/
	use source && java-pkg_dosrc src/com
}

