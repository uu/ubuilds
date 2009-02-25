# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/electric/electric-8.04.ebuild,v 1.3 2009/02/18 14:04:35 nixnut Exp $

EAPI=1
JAVA_PKG_IUSE="doc gnu jmf no3d source"

inherit base eutils java-pkg-2 java-ant-2

DESCRIPTION="Complete Electronic Design Automation (EDA) system that can handle many forms of circuit design"
HOMEPAGE="http://www.gnu.org/software/electric/electric.html"
#SRC_URI="mirror://gnu/electric/${PN}Binary-${PV}.jar"
SRC_URI="mirror://gnu/electric/${P}.jar"
LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~ppc ~x86"

#	=dev-java/junit-4*
COMMON_DEPEND="dev-java/ant-core
	dev-java/apple-java-extensions-bin
	=dev-java/bsh-2*
	dev-java/lucene:1
	=dev-java/prefuse-2009*"

DEPEND=">=virtual/jdk-1.5
	${COMMON_DEPEND}"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"

S="${WORKDIR}"

PATCHES="${FILESDIR}/8.04-build_xml.patch"

#src_unpack() {
#	unpack ${A}
#	cd "${S}"
#	
#	epatch "${FILESDIR}/${PV}-build_xml.patch"
#
#	cd packaging
#	java-pkg_jar-from apple-java-extensions-bin
#	java-pkg_jar-from bsh bsh.jar bsh-2.0b2.jar
#	java-pkg_jar-from junit-4 junit.jar junit-4.0.jar
#	java-pkg_jar-from lucene-1 lucene.jar lucene-1.4.3.jar
#	java-pkg_jar-from prefuse-2009
#}

#EANT_EXTRA_ARGS="-Dnotests=true"

src_compile() {
#	eant jar $(use test || echo -Dnotests=true)
	local antflags="-Dnotests=true"
	use gnu && antflags="${antflags} -DGNU=true"
	use jmf && antflags="${antflags} -DJMF=true"
	use no3d && antflags="${antflags} -DNO3D=true"
	eant jar $(use_doc) ${antflags}
}

src_install() {
	java-pkg_dojar ${S}/${PN}.jar
	newicon com/sun/electric/tool/user/help/helphtml/iconplug.png electric.png
	make_wrapper electric "java -jar /usr/share/electric/lib/${PN}Binary-${PV}.jar"
	java-pkg_dolauncher electric "Electric VLSI Design System" electric.png Electronics

	use doc && java-pkg_dojavadoc apidoc
	use source && java-pkg_dosrc com
}
