# Copyright 2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=5

JAVA_PKG_IUSE="doc"
inherit java-pkg-2 java-ant-2

DESCRIPTION="Selenium automates browsers"
HOMEPAGE="http://www.seleniumhq.org/"
SRC_URI="http://selenium-release.storage.googleapis.com/2.44/selenium-server-standalone-${PV}.jar"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEP=""
DEPEND=">=virtual/jdk-1.4
        ${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.4
        ${COMMON_DEP}"

S="${WORKDIR}"

src_unpack() {
	cp ${DISTDIR}/${A} ${S}
}

src_install() {
    java-pkg_dojar ${A}
	java-pkg_dolauncher ${PN} --jar /usr/share/${PN}/lib/${A} --pkg_args "\${PKG_ARGS}"
	newinitd ${FILESDIR}/selenium-init "${PN}"
	newconfd ${FILESDIR}/selenium-conf "${PN}"
	dodir /var/log/selenium
}

