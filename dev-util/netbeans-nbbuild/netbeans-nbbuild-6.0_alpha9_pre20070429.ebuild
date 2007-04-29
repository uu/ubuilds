# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"
inherit java-pkg-2 java-ant-2
MY_PV=${PV/_alpha/-m}
DESCRIPTION="Netbeans build scripts"
HOMEPAGE="http://nbbuild.netbeans.org/"
SRC_URI="http://dev.gentoo.org/~fordfrog/distfiles/${PN}-${MY_PV}.tar.bz2"
LICENSE="CDDL"
SLOT="6.0"
KEYWORDS="~x86"
DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/netbeans-src"

src_compile() {
	eant -f nbbuild/build.xml bootstrap
	if use doc ; then
		mkdir javadoc
		javadoc -d javadoc -sourcepath nbbuild/antsrc -subpackages org
	fi
}

src_install() {
	java-pkg_dojar nbbuild/nbantext.jar
	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc nbbuild/antsrc/org
}
