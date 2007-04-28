# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/mckoi/mckoi-1.0.3.ebuild,v 1.3 2005/07/15 19:16:35 axxo Exp $

JAVA_PKG_IUSE="doc source"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Mckoi Java SQL Database System"
HOMEPAGE="http://mckoi.com/database/"
SRC_URI="http://www.mckoi.com/database/ver/${P/-/}.zip"
LICENSE="GPL-2"
SLOT="1"
KEYWORDS="~x86"

RDEPEND="=virtual/jre-1.4*
	=dev-java/gnu-regexp-1*"
DEPEND="=virtual/jdk-1.4*
	${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/${P/-/}

src_unpack() {
	unpack ${A}
	cd ${S}
	unzip -q src.zip || die "unpack failed"
	#epatch ${FILESDIR}/mckoi-1.0.3-jikes.patch
	rm *.jar
	cp ${FILESDIR}/build.xml .
	java-ant_rewrite-classpath
	cd src/
	rm -rf net
}

src_compile() {
        local antflags="jar"
        use doc && antflags="${antflags} docs"
        eant ${antflags} -Dgentoo.classpath=$(java-pkg_getjars gnu-regexp-1)
}

src_install() {
	dodoc README.txt db.conf
	java-pkg_dojar dist/mckoidb.jar

	if use doc; then
		java-pkg_dohtml docs/
		java-pkg_dojavadoc apidocs/
	fi
	use source && java-pkg_dosrc src/*
}
