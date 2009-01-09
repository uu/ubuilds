# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Placeholder package, dev-java/jaxb now includes tools"
HOMEPAGE="http://jaxb.dev.java.net/"
SRC_URI=""

LICENSE="CDDL"
SLOT="2"
KEYWORDS="~amd64 ~x86 ~ppc ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-java/jaxb-tools-${PV}"

pkg_setup() {
	elog ""
	elog "The package dev-java/jaxb now includes the tools"
	elog "which were installed separately in jaxb-tools before."
	elog "You may remove this package if you want to."
	elog ""
}
