# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit vim-plugin

# source id for this version
SRC_ID="11066"

DESCRIPTION="A vim plugin to enhance the editing of Clojure files"
HOMEPAGE="http://kotka.de/projects/clojure/vimclojure.html"
SRC_URI="http://www.vim.org/scripts/download_script.php?src_id=${SRC_ID} -> ${P}.zip"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

CDEPEND="!minimal? ( ~dev-java/gorilla-${PV} )"
DEPEND="${CDEPEND}
	app-arch/unzip"
RDEPEND="${CDEPEND}"

VIM_PLUGIN_HELPFILES="clojure"
VIM_PLUGIN_MESSAGES="filetype"

src_prepare() {
	local tmpdir="${T}/${P}"
	mkdir "${tmpdir}" || die "Unable to create temporary directory"
	cp -rp *.txt autoload doc indent syntax ftdetect ftplugin ${tmpdir} \
		|| die "Failed to copy Vim plugin contents to temporary directory '${tmpdir}'"
	cd "${WORKDIR}" || die "Unable to change directories to '${WORKDIR}'"
	rm -r "${S}" || die "Unable to remove old source directory '${S}'"
	cp -rp "${tmpdir}" "${S}" || die "Failed to copy new source directory to '${S}'"
}

pkg_postinst() {
	vim-plugin_pkg_postinst
	if ! useq minimal ; then
		elog "In order to use VimClojure’s interactive features, you must start a gorilla"
		elog "server using either the command gorilla-server or the gorilla init script."
		elog ""
		elog "You must also modify your .vimrc file with the following entries:"
		elog ""
		elog "   let g:vimclojure#NailgunClient="/usr/bin/gorilla-client""
		elog "   let g:clj_want_gorilla=1"
		elog ""
		elog "For the mappings to work, you should set a localleader, e.g. "
		elog "‘let maplocalleader=\"\\\\\\\\\"’."
	fi
}
