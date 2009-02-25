# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-ant-2

DESCRIPTION="Glassfish entity persistence API - toplink essentuals"
HOMEPAGE="https://glassfish.dev.java.net/"
SRC_URI="http://download.java.net/javaee5/fcs_branch/promoted/source/glassfish-9_0-b48-src.zip"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

COMMON_DEPS="
	dev-java/glassfish-persistence
	dev-java/glassfish-transaction-api
	"
DEPEND="=virtual/jdk-1.5*
	app-arch/unzip
	${COMMON_DEPS}"
RDEPEND="=virtual/jre-1.5*
	${COMMON_DEPS}"

MODULE="entity-persistence"
S="${WORKDIR}/glassfish"

src_unpack() {
	unpack ${A}
	cd ${S}/${MODULE}
	mv build.xml build.xml.bak
	sed 's/depends=\"init, copy-persistence-api\"/depends=\"init\"/' build.xml.bak > build.xml
	#sed 's/depends=\"init, copy-persistence-api\"/depends=\"init\"/' build.xml.bak > build.xml || die "Failed to sed build.xml."
	java-ant_rewrite-classpath build.xml

	mkdir -p "${WORKDIR}/publish/glassfish/lib" || die "Unable to create install dir"
}

src_compile() {
	cd ${S}/${MODULE}
	eant -Dgentoo.classpath=$(java-pkg_getjars glassfish-persistence,glassfish-transaction-api) all
}

src_install() {
	cd ${WORKDIR}/publish/glassfish
	java-pkg_dojar lib/*.jar
}
