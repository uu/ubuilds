# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A port of the Free Lossless Audio Codec (FLAC) library to Java."
HOMEPAGE="http://jflac.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	sys-apps/sed"

src_unpack() {
	unpack ${A}
	cd "${S}"
	cp "${FILESDIR}"/build.* .

	#To allow us to build to -source 1.4 -target 1.4
	sed -i -e 's_@Override_//@Override_g' src/java/org/kc7bfi/jflac/metadata/Picture.java
}

src_install() {
	java-pkg_newjar "target/${P}.jar"
	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/java/org
}

