# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
JAVA_PKG_IUSE="doc source"
WANT_SPLIT_ANT="true"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Python Ant-task"
HOMEPAGE="http://code.google.com/p/pyanttasks/"
SRC_URI="http://pyanttasks.googlecode.com/files/pyAntTasks-${PV}.src.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86"

IUSE=""

RDEPEND=">=virtual/jre-1.5
		dev-java/ant-core:0
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEP}"

S="${WORKDIR}"/pyAntTasks-${PV}
EANT_DOC_TARGET="docs"
EANT_GENTOO_CLASSPATH="ant-core"

src_prepare(){
	unpack ${A}

	rm -v "${S}"/lib/*.jar || die

	#bad Build file
	rm "${S}"/build.xml || die
	cp -v "${FILESDIR}"/build-"${PV}".xml "${S}"/build.xml
}


src_install() {
	java-pkg_dojar dist/"${PN}.jar"
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc src

	java-pkg_register-ant-task
}

