# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source"

inherit java-pkg-2

HOMEPAGE="http://www.eclipse.org/"
SRC_URI="http://download.eclipse.org/eclipse/downloads/drops/R-3.2.2-200702121330/eclipse-RCP-SDK-${PV}-linux-gtk.tar.gz"
LICENSE="EPL-1.0"
SLOT="3"
DESCRIPTION="Eclipse Rich Client Platform"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"
RDEPEND=">=virtual/jdk-1.4"

eclipse-rcp_src_unpack() {
	unpack ${A}
	mkdir -p ${S}/src
	unzip -q ${WORKDIR}/eclipse/plugins/${RCP_ROOT}/src/${RCP_PACKAGE_DIR}/src.zip -d ${S}/src
	rm -rf ${WORKDIR}/eclipse	
}

eclipse-rcp_src_compile() {
	#ejavac -cp ${classpath} -sourcepath src
	cd src
	find . -name '*.java' -print > sources.list
	[[ -n "${RCP_EXTRA_DEPS}" ]] && classpath=$(java-pkg_getjars ${RCP_EXTRA_DEPS})
	ejavac -cp .:${classpath} @sources.list
  	find . -name '*.class' -print > classes.list
  	touch myManifest
  	jar cmf myManifest ${PN}.jar @classes.list
}

eclipse-rcp_src_install() {
	java-pkg_dojar src/${PN}.jar
	use source && java-pkg_dosrc src/org
}

EXPORT_FUNCTIONS src_unpack src_compile src_install
