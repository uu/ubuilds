# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/backupninja/backupninja-0.9.7.ebuild,v 1.3 2010/07/10 15:08:51 fauli Exp $

EAPI=3

inherit base autotools

# This thing change with every release, how idiotic...
NODE_NUMBER=197

DESCRIPTION="lightweight, extensible meta-backup system"
HOMEPAGE="http://riseuplabs.org/backupninja/"
SRC_URI="https://labs.riseup.net/code/attachments/download/${NODE_NUMBER}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-util/dialog"
RDEPEND="${DEPEND}"

DOCS=( "AUTHORS" "FAQ" "TODO" "README" "NEWS" )

src_prepare() {
	base_src_prepare
	eautoreconf
}

