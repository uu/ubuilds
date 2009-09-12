# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Docking solution for Java Swing"
HOMEPAGE="http://www.vlsolutions.com/en/products/docking/"
SRC_URI="http://www.vlsolutions.com/download/${P}.zip"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"

java_prepare() {
	rm -v jar/${P}.jar || die "Failed to remove vldocking.jar"
}

src_install() {
	java-pkg_newjar "jar/${P}.jar" "${PN}.jar"
	use doc && java-pkg_dojavadoc "doc/api"
	use source && java-pkg_dosrc "src/*"
}
