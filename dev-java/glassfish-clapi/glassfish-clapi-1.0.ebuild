# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit java-pkg-2

DESCRIPTION="Glassfish classloder extract for spring"
HOMEPAGE="https://glassfish.dev.java.net"
# using same tarball as glassfish-persitence to prevent an other 30MB+ dl
SRC_URI="http://download.java.net/javaee5/fcs_branch/promoted/source/glassfish-9_0-b48-src.zip"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEP="dev-java/glassfish-persistence:0"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip:0
	${COMMON_DEP}"

S="${WORKDIR}/glassfish/appserv-core"

src_prepare() {
	find "${WORKDIR}" -name \*.jar -delete || die
}

src_compile() {
	ejavac -cp $(java-pkg_getjars glassfish-persistence) -d . \
		src/java/com/sun/enterprise/loader/InstrumentableClassLoader.java
	jar cf ${PN}.jar com || die
}

src_install() {
	java-pkg_dojar "${PN}.jar"
}
