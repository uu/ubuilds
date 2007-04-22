# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"
inherit java-pkg-2 java-ant-2

DESCRIPTION="Java SIP stack"
HOMEPAGE="https://jain-sip.dev.java.net/"
SRC_URI="http://dev.gentoo.org/~fordfrog/distfiles/${P}.tar.bz2"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE="examples test"

COMMON_DEPEND="dev-java/log4j
	dev-java/concurrent-util"
DEPEND=">=virtual/jdk-1.4
	test? ( =dev-java/junit-3.8* )
	${COMMON_DEPEND}"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPEND}"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-build.xml.patch
	find -name "*.jar" | xargs rm -v
	java-ant_rewrite-classpath
}

src_compile() {
	eant make $(use_doc) -Dgentoo.classpath=$(java-pkg_getjars log4j,concurrent-util)
}

src_test() {
	ANT_TASKS="ant-junit" eant runtck runtckcallflows torture parsertest \
		-Dgentoo.classpath=$(java-pkg_getjars --build-only junit,log4j,concurrent-util)
}

src_install() {
	java-pkg_newjar JainSipApi1.2.jar jain-sip-api.jar
	java-pkg_newjar JainSipRi1.2.jar jain-sip-ri.jar
	java-pkg_newjar nist-sdp-1.0.jar nist-sdp.jar
	java-pkg_dojar sip-sdp.jar

	dodoc contributing.txt how-to-run-the-tck.txt README

	if use doc ; then
		dohtml docs
		java-pkg_dojavadoc javadoc
	fi

	use source && java-pkg_dosrc src/javax src/gov

	if use examples ; then
		dodir /usr/share/doc/${PF}/examples
		cp src/examples/* ${D}/usr/share/doc/${PF}/examples
	fi
}
