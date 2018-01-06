# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-2 multilib

DESCRIPTION="PostgreSQL plugin for Nagios."
HOMEPAGE="https://github.com/OPMDG/check_pgactivity"
SRC_URI=""
EGIT_REPO_URI="https://github.com/OPMDG/check_pgactivity.git"
EGIT_BRANCH="master"

LICENSE="OPMDG"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-db/postgresql"
RDEPEND="${DEPEND}"

src_install() {
	local nagiosplugindir=/usr/$(get_libdir)/nagios/plugins
    dodir "${nagiosplugindir}"
	exeinto ${nagiosplugindir}
	doexe check_pgactivity
	dodoc README.rst 
}

