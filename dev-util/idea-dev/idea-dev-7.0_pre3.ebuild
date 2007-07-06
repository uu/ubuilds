# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Plugin Development Kit for IntelliJ IDEA"
HOMEPAGE="http://www.jetbrains.com/idea/"
MY_PV="7.0.M1b"
SRC_URI="http://download.jetbrains.com/idea/idea-${MY_PV}-dev.zip"
LICENSE="IntelliJ-IDEA"
KEYWORDS="~x86"

#Change slot number between incompatible IDEA versions
SLOT="7"

RDEPEND="~dev-util/idea-${PV}"
S="${WORKDIR}"

src_install() {
	insinto "/opt/idea-${PV}"
	doins -r *
}
