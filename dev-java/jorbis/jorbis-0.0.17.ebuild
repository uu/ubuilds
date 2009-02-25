# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="JOrbis accepts Ogg Vorbis bitstreams and decodes them to raw PCM"
HOMEPAGE="http://www.jcraft.com/jorbis/index.html"
SRC_URI="http://www.jcraft.com/${PN}/${P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""


RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"

src_compile() {
	mkdir -p build
	ejavac -d build $(find com/ -iname '*.java')

	jar -cf "${PN}.jar" -C build com
}
src_install() {
	java-pkg_dojar "${PN}.jar"
	use source && java-pkg_dosrc com
}

