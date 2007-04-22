# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"
inherit java-pkg-2 java-ant-2

DESCRIPTION="A Java implementation of the STUN protocol (rfc 3489)."
HOMEPAGE="https://stun4j.dev.java.net/"
SRC_URI="http://dev.gentoo.org/~fordfrog/distfiles/${P}.tar.bz2"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="source test"
DEPEND=">=virtual/jdk-1.4
	test? ( =dev-java/junit-3.8* )"
RDEPEND=">=virtual/jdk-1.4"

S="${WORKDIR}/${PN}"

# TODO: disable ipv6 tests if ipv6 USE flag is turned off

src_unpack() {
	unpack ${A}
	cd ${S}
	find -name "*.jar" | xargs rm -v
	java-ant_rewrite-classpath
}

src_compile() {
	eant jar $(use_doc) -Dgentoo.classpath=$(java-pkg_getjars --build-only junit)
}

src_test() {
	ANT_TASKS="ant-junit" eant test -Dgentoo.classpath=$(java-pkg_getjars --build-only junit)
}

src_install() {
	java-pkg_newjar Stun4J.jar
	use doc && java-pkg_dojavadoc doc
	use source && java-pkg_dosrc src
}
