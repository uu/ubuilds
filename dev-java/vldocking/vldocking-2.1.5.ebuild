# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_P="${PN}_${PV}"
DESCRIPTION="Docking solution for Swing"
HOMEPAGE="http://www.vlsolutions.com/en/index.php"
SRC_URI="http://www.vlsolutions.com/download/cecill/${MY_P}.zip"

LICENSE="CeCILL-1"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"

S="${WORKDIR}/${MY_P}/"

src_install() {
	java-pkg_newjar "jar/${PN}_2.1.4.jar" # this is an error in the build.xml
	use doc &&  java-pkg_dojavadoc doc/api
	use source && java-pkg_dosrc src/*
}
