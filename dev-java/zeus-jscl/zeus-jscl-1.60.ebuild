# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_P="${PN}_v1_60"

DESCRIPTION="Java Swing Components Library"
HOMEPAGE="http://sourceforge.net/projects/zeus-jscl/"
SRC_URI="http://downloads.sourceforge.net/zeus-jscl/${MY_P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	find . -name \*.jar -delete || die
	rm -R doc/* || die # rebuild the docs
}

# TODO figure out the tests

src_install() {
	java-pkg_newjar "lib/${P}.jar" "${PN}.jar"
	dodoc changelog.txt readme.txt
	use doc && java-pkg_dojavadoc doc/api
	use source && java-pkg_dosrc src/*
}
