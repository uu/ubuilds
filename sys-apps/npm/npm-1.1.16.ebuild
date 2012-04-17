# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit git-2

DESCRIPTION="A package manager for nodejs"
HOMEPAGE="http://npmjs.org/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/isaacs/npm.git"
EGIT_COMMIT="v${PV}"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-libs/nodejs
	dev-vcs/git"
RDEPEND="${DEPEND}"

src_configure() {
	# nasty hack around the lack of DESTDIR not working. npm uses relative links
	# anyways so this should work.
	econf --prefix="${D}/usr"
}

src_install() {
	node cli.js install -g -f --unsafe-perm
}
