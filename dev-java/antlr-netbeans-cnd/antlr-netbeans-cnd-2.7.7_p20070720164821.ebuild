# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-ant-2
DESCRIPTION="Patched version of ANTLR used by Netbeans CND cluster"
HOMEPAGE="http://cnd.netbeans.org/"
SOURCE_SITE="http://dev.gentoo.org/~fordfrog/distfiles/"
MY_PV="6.0_pre20070720164821"
SRC_URI="
	${SOURCE_SITE}/netbeans-nbbuild-${MY_PV}.tar.bz2
	${SOURCE_SITE}/netbeans-cnd-${MY_PV}.tar.bz2"
LICENSE="CDDL"
SLOT="0"
KEYWORDS="~x86"
DEPEND="=virtual/jdk-1.5*
	>=dev-java/ant-nodeps-1.7.0"
RDEPEND=">=virtual/jre-1.5
	dev-java/ant-antlr"
S="${WORKDIR}/netbeans-src"
JAVA_PKG_BSFIX="off"

src_compile() {
	eant -f nbbuild/build.xml bootstrap
	ANT_TASKS="ant-nodeps" eant -f cnd/antlr/build.xml
}

src_install() {
	java-pkg_newjar nbbuild/netbeans/cnd1/modules/org-netbeans-modules-cnd-antlr.jar ${PN}.jar

	# workaround so netbeans ebuild does not load the official implementation of antlr
	java-pkg_dojar /usr/share/ant-antlr/lib/ant-antlr.jar

	java-pkg_register-ant-task
}
