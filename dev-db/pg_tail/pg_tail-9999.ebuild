# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-2 eutils

DESCRIPTION="Watches last lines of a PostgreSQL table like in a 'tail -f'."
HOMEPAGE="https://github.com/aaparmeggiani/pg_tail"
SRC_URI=""
EGIT_REPO_URI="https://github.com/aaparmeggiani/pg_tail.git"
#EGIT_BRANCH="gpujoin"
#EGIT_COMMIT="v0_8"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-db/postgresql"
RDEPEND="${DEPEND}"


src_install() {
	dobin pg_tail
	dodoc README.md
}
