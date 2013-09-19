# Copyright 2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

JAVA_PKG_IUSE="doc"
inherit java-pkg-2 java-ant-2

DESCRIPTION="JArgs command line option parsing suite for Java"
HOMEPAGE="http://jargs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEP=""
DEPEND=">=virtual/jdk-1.3
        ${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.3
        ${COMMON_DEP}"

EANT_BUILD_TARGET="compile runtimejar"
EANT_DOC_TARGET="javadoc"

src_install() {
	java-pkg_dojar "lib/${PN}.jar"
}
