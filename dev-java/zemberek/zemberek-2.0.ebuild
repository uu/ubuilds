# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Zemberek NLP library"
HOMEPAGE="http://code.google.com/p/zemberek/"
SRC_URI="http://zemberek.googlecode.com/files/${P}-src.zip"


LICENSE="MPL"
SLOT="0"
KEYWORDS="~x86"
LANGS="tr tm"
IUSE=""
S=${WORKDIR}/${P}-src

for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X/-/_}"
done

RDEPEND=">=virtual/jre-1.5"

DEPEND=">=virtual/jdk-1.5
	app-arch/zip"

src_unpack() {
	unpack ${A}
	cd ${S}
	mkdir lib/dagitim
}

src_compile() {
	strip-linguas ${LANGS}
	local anttargs
	for jar in cekirdek demo ${LINGUAS}; do
		anttargs="${anttargs} jar-${jar}"
	done
	eant ${anttargs}
}

src_install() {
	strip-linguas ${LANGS}
	for jar in cekirdek demo ${LINGUAS}; do
		java-pkg_newjar dagitim/jar/zemberek-${jar}-2.0.jar zemberek2-${jar}.jar
	done
	java-pkg_dolauncher zemberek-demo --main net.zemberek.demo.DemoMain
	dodoc dokuman/lisanslar/*
	dodoc surumler.txt
}
