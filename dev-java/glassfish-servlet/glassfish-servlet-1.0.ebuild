# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-ant-2

DESCRIPTION="Glassfish implementation of JTS and JTA"
HOMEPAGE="https://glassfish.dev.java.net/"
SRC_URI="http://download.java.net/javaee5/fcs_branch/promoted/source/glassfish-9_0-b48-src.zip"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=">=virtual/jdk-1.5
		app-arch/unzip"
RDEPEND=">=virtual/jre-1.5"

MODULE="servlet-api"
S="${WORKDIR}/glassfish"

src_unpack() {
	unpack ${A}
	cd "${S}/${MODULE}"
	mv build.xml build.xml.bak
	sed 's/update=\"yes\"//' build.xml.bak > build.xml || die "Failed to sed"
	mkdir -p "${WORKDIR}/publish/glassfish/lib"
}

src_compile() {
	cd ${S}/${MODULE}
	eant all
}

src_install() {
	cd "${S}/${MODULE}"
	java-pkg_dojar "src/jakarta-servletapi-5/jsr154/dist/lib/servlet-api.jar"
	java-pkg_dojar "src/jsr245/dist/lib/jsp-api.jar"

	#Need to install javadocs that are in 2 locations.
	#use doc && java-pkg_dojavadoc "${S}/${MODULE}/docs"
}
