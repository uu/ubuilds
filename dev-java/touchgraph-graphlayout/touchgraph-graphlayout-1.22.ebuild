# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source"

inherit java-pkg-2

MY_PN="TGGraphLayout"

DESCRIPTION="A set graph visualization interfaces using force-based layout and focus+context techniques."
HOMEPAGE="http://touchgraph.sourceforge.net/"
SRC_URI="mirror://sourceforge/touchgraph/TGGL_${PV/./}_jre11.zip"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
		app-arch/unzip"

S="${WORKDIR}/${MY_PN}"

src_compile() {
	mkdir -p build
	ejavac -d build $(find . -iname '*.java')
	jar cf "${MY_PN}.jar" build/*
}

src_install() {
	java-pkg_newjar "${MY_PN}.jar" "${MY_PN}.jar"
	use source && java-pkg_dosrc com
}

