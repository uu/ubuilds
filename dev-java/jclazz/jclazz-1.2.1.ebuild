# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source"

inherit java-pkg-2

DESCRIPTION="Java Class files manipulation utility."
HOMEPAGE="http://jclazz.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-source.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4"

S="${WORKDIR}"

src_compile() {
	mkdir build || die

	ejavac -d build $(find ru -iname '*.java')
	cp -R res build/ || die

	cd build || die
	jar -cf "../${PN}-core.jar" $(find ru/andrew/jclazz/core -iname '*.class')
	jar -cf "../${PN}-decomp.jar" \
		$(find ru/andrew/jclazz/decompiler -iname '*.class')
	jar -cf "../${PN}-gui.jar" $(find ru/andrew/jclazz/gui -iname '*.class')\
		res
}

src_install() {
	java-pkg_dojar *.jar
	use source && java-pkg_dosrc ru

	java-pkg_dolauncher infoj --main ru.andrew.jclazz.core.infoj.InfoJ
	java-pkg_dolauncher decomp \
		--main ru.andrew.jclazz.decompiler.ClassDecompiler
	java-pkg_dolauncher jclass-gui --main ru.andrew.jclazz.gui.MainForm
}

