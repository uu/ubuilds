# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit eutils git-2

DESCRIPTION="A log analyzer for exim"

HOMEPAGE="http://oss.netshadow.at/redmine/projects/exilog"
EGIT_REPO_URI="http://git.netshadow.at/exilog.git"

LICENSE="AS IS"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="syslog"
#DEPEND=""
#RDEPEND=""

src_unpack() {
    unpack ${A}
    cd "${S}"
    epatch "${FILESDIR}/${PV}-syslog.patch"
}

src_install() {
    dodir /etc/exilog
    insinto /etc/exilog
    doins ${S}/conf/* || die
    cp "${S}/conf/exilog.conf-example" "{$D}/exilog.conf" || die "Install failed!"

# executable files
    exeinto /usr/sbin
    doexe ${S}/agent/* || die

#library
    dodir /usr/lib/exilog
    insinto /usr/lib/exilog
    dolib ${S}/lib/*

# htdocs
    dodir /etc/exilog/static
    doins -r exilog/htdocs

}


