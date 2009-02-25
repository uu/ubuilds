# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils versionator

DESCRIPTION="Plugin Development Kit for IntelliJ IDEA"
HOMEPAGE="http://www.jetbrains.com/idea/"
SRC_URI="http://download.jetbrains.com/idea/idea-${PV}-dev.zip"
LICENSE="IntelliJ-IDEA"
KEYWORDS="~x86 ~amd64"
SLOT="$(get_major_version)"
IUSE=""

RDEPEND="~dev-util/idea-${PV}"
S="${WORKDIR}"

src_install() {
	insinto "/opt/idea-${PV}"
	doins -r *
}
