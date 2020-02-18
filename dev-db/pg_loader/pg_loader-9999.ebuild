# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Loading data into PostgreSQL"
HOMEPAGE="http://pgloader.io"
SRC_URI=""
inherit git-r3 eutils
EGIT_REPO_URI="https://github.com/dimitri/pgloader.git"

LICENSE=""
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="dev-lisp/sbcl"
RDEPEND="${DEPEND}"

