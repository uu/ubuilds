# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PN=${PN%%-bin}
MY_P="${MY_PN}-${PV}"

DESCRIPTION="An extensible Maven repository management software"
SRC_URI="mirror://apache/${MY_PN}/binaries/apache-${MY_P}-bin.tar.gz"
HOMEPAGE="http://archiva.apache.org/"
LICENSE="Apache-2.0"
SLOT="2.0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=virtual/jdk-1.5"
RESTRICT="strip"

S="${WORKDIR}/apache-${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"/bin
	rm *.bat *solaris* *windows* *macosx*
	cd "${S}"/lib
	rm *solaris* *windows* *macosx*
}

src_install() {

	insinto "/opt/${MY_P}"
	doins -r apps
	doins -r lib
	insopts "--mode 750"
	doins -r bin

	dodir /var/archiva-1.1/{data,logs}
	insinto /var/archiva-1.1/conf
	insopts "--mode 644"
	doins conf/*

	doinitd "${FILESDIR}/init.d/$P"
	doconfd "${FILESDIR}/conf.d/$P"
	dodoc NOTICE
	use doc && dohtml -r docs/*
}
