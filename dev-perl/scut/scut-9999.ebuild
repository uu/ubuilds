# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=8
inherit perl-module git-r3

DESCRIPTION="scut is a better cut, extracts arbitrary columns based on regexes."
SRC_URI=""
HOMEPAGE="https://github.com/hjmangalam/scut"
EGIT_REPO_URI="https://github.com/hjmangalam/scut.git"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE=""
DEPEND="dev-perl/Statistics-Descriptive"

src_install() {
	dobin ${S}/{scut,cols,stats}
}
