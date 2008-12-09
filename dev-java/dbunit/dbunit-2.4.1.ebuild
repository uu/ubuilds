# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="DbUnit is a JUnit extension targeted for database-driven projects"
HOMEPAGE="http://dbunit.sourceforge.net/"
SRC_URI="http://internap.dl.sourceforge.net/sourceforge/dbunit/${P}-sources.jar"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE=""

COMMON_DEP="dev-java/slf4j-api
			dev-java/slf4j-nop"

RDEPEND="${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}"
#instead of making a folder
S="${WORKDIR}"

src_unpack(){
	unpack ${A}
	cd "${S}"
	cp -v "${FILESDIR}"/build.xml "${S}" || die
}

src_install() {
	java-pkg_dojar "${PN}.jar"
	use doc && java-pkg_dojavadoc build/javadoc
	use source && java-pkg_dosrc org
}

