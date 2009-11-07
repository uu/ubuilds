# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
JAVA_PKG_IUSE="source test"

EGIT_REPO_URI="git://github.com/richhickey/clojure-contrib.git"
EGIT_BRANCH="clojure-1.0-compatible"

inherit git clojure java-ant-2

DESCRIPTION="User contributed packages for Clojure."
HOMEPAGE="http://clojure.org/"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar ${PN}.jar
	clojure_dosrc src
}
