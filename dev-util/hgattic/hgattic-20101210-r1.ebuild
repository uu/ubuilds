# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=(python2_7)
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

RID="3ba1e5f03971"
DESCRIPTION="Patch shelve support for Mercurial"
HOMEPAGE="https://mercurial.selenic.com/wiki/AtticExtension"
SRC_URI="https://bitbucket.org/Bill_Barry/hgattic/get/${RID}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="dev-vcs/mercurial"

S="${WORKDIR}/Bill_Barry-hgattic-${RID}"

src_prepare() {
    mkdir -p "${S}/hgext"
    cp "${S}/attic.py" "${S}/hgext"
    cp "${FILESDIR}/setup.py" "${S}"
}
