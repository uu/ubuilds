# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-ivy/ant-ivy-1.3.1-r1.ebuild,v 1.1 2007/03/01 13:33:42 betelgeuse Exp $

JAVA_PKG_IUSE="doc examples source test"
# registers as split-ant task
WANT_SPLIT_ANT="true"
# rewrites examples otherwise... bad
JAVA_PKG_BSFIX_ALL="no"

inherit java-pkg-2 java-ant-2 eutils

MY_PN="${PN##*-}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Ivy is a free java based dependency manager"
HOMEPAGE="http://jayasoft.org/ivy"
SRC_URI="http://jayasoft.org/downloads/ivy/1.4.1/${MY_P}-src.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86" #~ppc missing deps
IUSE=""
# many tests fail (but there's no failonerror)
RESTRICT="test"

COMMON_DEP="
	dev-java/ant-core
	=dev-java/commons-cli-1*
	=dev-java/commons-httpclient-3*
	dev-java/commons-vfs
	=dev-java/jakarta-oro-2.0*
	dev-java/jsch"
DEPEND="
	>=virtual/jdk-1.4
	app-arch/unzip
	test? ( dev-java/ant-junit )
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

S="${WORKDIR}/${MY_P}"


src_unpack() {
	unpack ${A}
	cd "${S}"

	# init-ivy expects existing ivy.jar, but we don't need actually it
	sed -i -e 's/depends="init-ivy, prepare"/depends="prepare"/' build.xml \
		|| die

	rm -v src/java/fr/jayasoft/ivy/repository/vfs/IvyWebdav* || die

	mkdir lib && cd lib
	java-pkg_jar-from ant-core,commons-cli-1,commons-httpclient-3,commons-vfs
	java-pkg_jar-from jakarta-oro-2.0,jsch
}

src_compile() {
	eant offline jar $(use_doc)
}

src_install() {
	java-pkg_dojar build/artifact/${MY_PN}.jar

	use doc && java-pkg_dojavadoc doc/build/api
	use examples && java-pkg_doexamples
	use source && java-pkg_dosrc src/java/*

	java-pkg_register-ant-task
}

src_test() {
	java-pkg_jar-from --into lib junit
	ANT_TASKS="ant-junit" eant offline test
}
