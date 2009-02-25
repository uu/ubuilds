# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 eutils

MY_P="k5nAccordion-src-${PV}"

DESCRIPTION="The k5n Accordion is a JFC/Swing accordion GUI object."
HOMEPAGE="http://www.k5n.us/k5naccordion.php"
SRC_URI="mirror://sourceforge/javacaltools/${MY_P}.zip"

S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4"

EANT_BUILD_TARGET="dist"


src_install() {
	java-pkg_newjar dist/k5nAccordion-${PV}.jar ${PN}.jar
	use doc && java-pkg_dojavadoc doc/api
	use source && java-pkg_dosrc src/us
	dodoc ChangeLog README.txt
}

