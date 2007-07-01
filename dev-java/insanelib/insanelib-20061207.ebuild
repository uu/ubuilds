# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"
inherit eutils java-pkg-2 java-ant-2
DESCRIPTION="Netbeans Performance library"
HOMEPAGE="http://performance.netbeans.org/insane/"
SRC_URI="http://dev.gentoo.org/~fordfrog/distfiles/${P}.tar.bz2"
LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND=">=virtual/jdk-1.4
	test? ( dev-java/ant-junit )"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${PN}"

EANT_BUILD_TARGET="jar"
EANT_DOC_TARGET="javadoc"

src_test() {
	ANT_TASKS="ant-junit" eant test
}

src_install() {
	java-pkg_dojar dist/${PN}.jar
	use doc && java-pkg_dojavadoc dist/javadoc
	use source && java-pkg_dosrc src
}
