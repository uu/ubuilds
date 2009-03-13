# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-ant-2 subversion

ESVN_REPO_URI="http://svn.mkgmap.org.uk/splitter/trunk/"

DESCRIPTION="Tool to split garmin maps"
HOMEPAGE="http://www.mkgmap.org.uk/page/tile-splitter"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"

#No Keywords for overlay
KEYWORDS=""

IUSE=""
DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"
S="${WORKDIR}/${PN}"

src_compile() {
	JAVA_ANT_ENCODING=UTF-8
	mkdir "doc"
	eant dist
}

src_install() {
	java-pkg_newjar "dist/${PN}.jar" || die "java-pkg_newjar failed"
	java-pkg_dolauncher "${PN}" --jar "${PN}.jar" || die "java-pkg_dolauncher failed"
}
