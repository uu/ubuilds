# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Maven repository for Gentoo"
HOMEPAGE="http://www.gentoo.org/proj/en/java/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"

src_install() {
	dodir /usr/share/maven2-gentoo-repo
	#cp -r * ${D}/usr/share/maven-gentoo-repo
}
