# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Open-source audiofile tagger"
HOMEPAGE="http://entagged.sourceforge.net/"
SRC_URI="mirror://sourceforge/entagged/${P}.tar.gz"

LICENSE="|| ( GPL-2 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"

RDEPEND=">=virtual/jre-1.5
	dev-java/squareness-jlf
	dev-db/hsqldb"

DEPEND=">=virtual/jdk-1.5
	dev-db/hsqldb"

src_unpack() {
	unpack ${A}
	mkdir -p test/entagged/junit || die
	mv entagged/entagged/junit test/entagged || die
	rm entagged/*.jar || die
	java-pkg_jarfrom hsqldb hsqldb.jar entagged/hsqldb.jar
}

src_compile() {
	cd "${S}/entagged" || die
	epatch ${FILESDIR}/buildfixes.patch
	cd "${S}" || die
	eant -f entagged/build.xml build
}

src_install() {
	cd entagged || die
	java-pkg_newjar ${P}.jar ${PN}.jar
	java-pkg_register-dependency squareness-jlf
	java-pkg_dolauncher ${PN} --main entagged.tageditor.TagEditorFrameSplash
	newicon entagged/tageditor/resources/icons/entagged-icon.png ${PN}.png
	make_desktop_entry ${PN} "Entagged Tag Editor" ${PN}.png
}
