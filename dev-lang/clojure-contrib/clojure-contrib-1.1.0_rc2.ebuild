# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
CLOJURE_VERSION="1.1"
JAVA_PKG_IUSE="source test"

inherit clojure java-ant-2

DESCRIPTION="User contributed packages for Clojure."
HOMEPAGE="http://clojure.org/"
SRC_URI="http://github.com/richhickey/${PN}/zipball/${PV/_rc/-RC} ->  ${P}.zip"

LICENSE="EPL-1.0"
SLOT="1.1"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_unpack() {
	default
	cd "${WORKDIR}" || die "Unable to change directory to ${WORKDIR}"
	mv richhickey-clojure-contrib-dd02cbd "${P}" || die "Unable to rename unpacked source directory."
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar ${PN}.jar
	clojure_dosrc src
}
