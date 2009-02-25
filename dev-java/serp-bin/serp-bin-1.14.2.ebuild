# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc"

inherit java-pkg-2

MY_PN="${PN/-bin/}"

DESCRIPTION="Serp is an open source framework for manipulating Java bytecode."
HOMEPAGE="http://serp.sourceforge.net/"
SRC_URI="http://serp.sourceforge.net/m2repo/net/sourceforge/${MY_PN}/${MY_PN}/${PV}/${MY_PN}-${PV}-bin.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4"

S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	java-pkg_newjar "${MY_PN}-${PV}.jar" serp.jar
	use doc && dodoc README.txt
}

