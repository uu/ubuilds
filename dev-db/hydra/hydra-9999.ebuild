# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

inherit git-r3

DESCRIPTION="Columnar store for analytics with PostgreSQL."
HOMEPAGE="https://github.com/hydradatabase/hydra"
SRC_URI=""
EGIT_REPO_URI="https://github.com/hydradatabase/hydra.git"
EGIT_BRANCH="main"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="dev-db/postgresql"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/columnar"
