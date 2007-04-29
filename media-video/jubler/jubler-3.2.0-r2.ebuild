# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 java-utils-2 java-ant-2 versionator

MY_PV=$(replace_version_separator 3 '-' )
MY_PN=${PN/#j/J}
DESCRIPTION="Java subtitle editor"
HOMEPAGE="http://www.panayotis.com/jubler/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-fullsrc-${MY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="nls spell kde"

RDEPEND=">=virtual/jre-1.5
	 spell?
	 (
	 	app-text/aspell
	 	>=dev-java/zemberek-2.0
	 )"
        
DEPEND=">=virtual/jdk-1.5
	app-text/docbook-sgml-utils
        nls? ( sys-devel/gettext)"

S=${WORKDIR}/${MY_PN}-${MY_PV}

pkg_setup() {
	! built_with_use zemberek linguas_tr \
	&& die "Zemberek should be built with Turkish language support"
	java-pkg-2_pkg_setup
}

src_unpack() {
        unpack ${A}
        cd ${S}
        chmod +x resources/ffmpeg-svn/configure
        chmod +x resources/ffmpeg-svn/doc/texi2pod.pl
	epatch ${FILESDIR}/${P}.patch
	epatch ${FILESDIR}/${P}-fixsplit.patch
	epatch ${FILESDIR}/${P}-zemberek2.patch
}

src_compile() {
	use spell && java-pkg_register-dependency zemberek zemberek2-cekirdek.jar
	use spell && java-pkg_register-dependency zemberek zemberek2-tr.jar
	local anttasks_opt
	use nls && anttasks_opt="i18n"
	eant ${anttasks_opt} jar xdevelop || die "compile failed"
}

src_install() {
	java-pkg_newjar dist/Jubler.jar ${PN}.jar
        java-pkg_doso resources/ffdecode/libffdecode.so
        doicon resources/installers/linux/jubler.png
	newicon resources/installers/linux/subtitle-32.png subtitle.png
        java-pkg_dolauncher jubler --main com.panayotis.jubler.Main
        make_desktop_entry ${PN} "Jubler" ${PN}.png
        doman resources/installers/linux/jubler.1
        insinto /usr/share/jubler/help
        doins dist/help/*
        insinto /usr/share/mimelnk/application
        use kde && doins resources/installers/linux/sub-*.desktop
}
