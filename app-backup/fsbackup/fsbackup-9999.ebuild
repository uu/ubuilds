# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit python eutils git-2

DESCRIPTION="FSBACKUP - file system backup and synchronization utility."
HOMEPAGE="http://www.opennet.ru/dev/fsbackup/"
EGIT_REPO_URI="https://github.com/opennet/FSBackup"

LICENSE="AS IS"
SLOT="0"
KEYWORDS="amd64 hppa ppc sparc x86"
IUSE=""

DEPEND="app-arch/tar dev-lang/perl virtual/perl-Digest-MD5 virtual/perl-DB_File"
RDEPEND="${DEPEND}"

src_install() {
	/usr/bin/env perl ./install.pl
	dodoc README
}

