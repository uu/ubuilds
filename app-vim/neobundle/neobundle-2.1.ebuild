# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/neocomplcache/neocomplcache-7.1.ebuild,v 1.1 2012/09/18 04:02:54 radhermit Exp $

EAPI=4

inherit vim-plugin vcs-snapshot

DESCRIPTION="vim plugin:Ultimate Vim package manager"
HOMEPAGE="https://github.com/Shougo/neobundle.vim"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE=""

SRC_URI="https://github.com/Shougo/neobundle.vim/archive/ver.${PV}.tar.gz -> ${P}.tar.gz"

VIM_PLUGIN_HELPFILES="${PN}.txt"

