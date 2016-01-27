# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2 java-ant-2 git-2

DESCRIPTION="JavaScript and CSS compressor"
HOMEPAGE="http://yui.github.io/yuicompressor/"
EGIT_REPO_URI="git://github.com/yui/yuicompressor"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=">=virtual/jdk-1.8"
RDEPEND=">=virtual/jre-1.8"

src_prepare() {
	sed -i -e 's:version\.number = .*:version.number = 9999:' ant.properties
}

src_compile(){
	eant
}

src_install() {
	java-pkg_newjar "build/${P}.jar" "${PN}.jar"
	java-pkg_dolauncher "${PN}"
}
