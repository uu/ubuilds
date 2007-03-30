# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Plugin Development Kit for IntelliJ IDEA"
HOMEPAGE="http://www.jetbrains.com/idea/"
SRC_URI="http://download.jetbrains.com/idea/idea-${PV}-dev.zip"
LICENSE="IntelliJ-IDEA"
KEYWORDS="~x86"

#Change slot number between incompatible IDEA versions
SLOT="6"

RDEPEND="~dev-util/idea-${PV}"
S="${WORKDIR}"

src_install() {
	insinto "/opt/idea-${PV}"
	doins -r *
}
