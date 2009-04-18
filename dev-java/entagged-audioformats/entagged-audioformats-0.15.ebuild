# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/zemberek/zemberek-2.0.ebuild,v 1.2 2007/08/04 19:34:24 mr_bones_ Exp $

JAVA_PKG_IUSE="source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A library to access/modify tag data in multimedia files"
HOMEPAGE="http://entagged.sourceforge.net/"
SRC_URI="mirror://sourceforge/entagged/${PN}-source-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

S="${WORKDIR}/entagged/audioformats"

RDEPEND=">=virtual/jre-1.4"

DEPEND=">=virtual/jdk-1.4"

src_compile() {
	cd "${S}" || die "cd failed"
	eant build
}

src_install() {
	java-pkg_newjar ${P}.jar ${PN}.jar
	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc ${WORKDIR}/*
}
