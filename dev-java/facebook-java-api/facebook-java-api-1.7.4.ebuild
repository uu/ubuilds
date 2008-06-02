# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
JAVA_PKG_IUSE="doc source examples"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Facebook API client implemented in Java, derived from the poorly-maintained official Facebook client"
HOMEPAGE="http://facebook-java-api.googlecode.com/"
SRC_URI="http://facebook-java-api.googlecode.com/files/${PN}-source-${PV}.zip"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"

CDEPEND="dev-java/json
	java-virtuals/jaxb:2"
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${CDEPEND}"

S="${WORKDIR}"

EANT_GENTOO_CLASSPATH="json,jaxb-2"

src_unpack() {
	unpack ${A}
	cp -v "${FILESDIR}"/build.xml . || die
}

src_install() {
	java-pkg_dojar ${PN}.jar
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc src/java/com
	use examples && java-pkg_doexamples src/test/*
}
