# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="An easy and powerful API to use threads with the Java Foundation Classes"
HOMEPAGE="http://foxtrot.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""


RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"

src_unpack() {
	unpack ${A}
	find . -iname '*.jar' -delete
}

src_compile() {
	mkdir build || die "Can't create directory"
	cd src || die
	ejavac -d ../build $(find foxtrot/*.java foxtrot/pumps/ foxtrot/utils/ foxtrot/workers/ -iname '*.java')
	jar -cf ../foxtrot.jar -C ../build foxtrot
}

src_install() {
	java-pkg_dojar "${PN}.jar"
	use doc && java-pkg_dojavadoc apidocs
	use source && java-pkg_dosrc src/foxtrot
}

