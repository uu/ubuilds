# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jump/jump-0.4.1-r1.ebuild,v 1.10 2006/10/05 17:57:24 gustavoz Exp $

DEPEND=">=virtual/jdk-1.2
	test? ( dev-java/junit)"
RDEPEND=">=virtual/jre-1.2"
JAVA_PKG_IUSE="doc source test"
WANT_ANT_TASKS="ant-junit"

inherit java-pkg-2 java-ant-2

DESCRIPTION="JUMP Ultimate Math Package (JUMP) is a Java-based extensible high-precision math package."
SRC_URI="mirror://sourceforge/${PN}-math/${P}.tar.gz"
HOMEPAGE="http://jump-math.sourceforge.net/"
KEYWORDS="~x86 ~ppc ~amd64"
LICENSE="BSD"
SLOT="0"
EANT_BUILD_TARGET="jar"
EANT_DOC_TARGET="apidocs"

src_test() {
	ANT_TASKS="ant-junit" eant do-tests -Dgentoo.classpath=$(java-pkg_getjars junit)
}

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i 's:${java.home}/src::' -i build.xml || die
	java-ant_rewrite-classpath
}

src_install() {
	java-pkg_dojar build/${PN}.jar
	use doc && java-pkg_dojavadoc  ${S}/build/apidocs
	use source && java-pkg_dosrc src/
}
