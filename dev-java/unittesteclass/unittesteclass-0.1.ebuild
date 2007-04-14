# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2

DESCRIPTION="Unit test for java-pkg-utils-2.eclass"
HOMEPAGE="http://www.gentoo.org/proj/en/java"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

COMMON_DEP="dev-java/ant-core"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}
		>=dev-java/ant-antlr-1.7"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}
	dev-java/ant-contrib"

S="${WORKDIR}"

src_unpack() {

	#check common package
	einfo "Check common package, not build-only"
	java-pkg_jarfrom ant-core ant.jar ant-1.7.jar
	echo "$(java-pkg_getjars ant-core)"
	echo "$(java-pkg_getjar ant-core ant.jar)"

	rm *.jar
	#check common package with build-only
	einfo "Check common package with build-only"
	java-pkg_jarfrom --build-only ant-core ant.jar ant-1.7.jar
	echo "$(java-pkg_getjars --build-only ant-core)"
	echo "$(java-pkg_getjar --build-only ant-core ant.jar)"

	rm *.jar
	#check only in RDEPEND without build-only
	einfo "Check package in RDEPEND without build-only"
	java-pkg_jarfrom ant-antlr ant-antlr.jar
	echo "$(java-pkg_getjars ant-antlr)"
	echo "$(java-pkg_getjar ant-antlr ant-antlr.jar)"

	rm *.jar

#check only in RDEPEND with build-only
	
	einfo "Check only in RDEPEND with build-only"
	einfo "jarfrom"
	java-pkg_jarfrom --build-only ant-antlr ant-antlr.jar
	einfo "getjars"
	echo "$(java-pkg_getjars --build-only  ant-antlr)"
	einfo "getjar"
	echo "$(java-pkg_getjar --build-only ant-antlr ant-antlr.jar)"

	rm *.jar

	#check doesn't have without build-only
	einfo "Check non [R]DEPEND without build-only"
	java-pkg_jarfrom ant-antlr ant-antlr.jar
	echo "$(java-pkg_getjars ant-antlr)"
	echo "$(java-pkg_getjar ant-antlr ant-antlr.jar)"

#check only in RDEPEND with build-only
	
	einfo "Check non [R]DEPEND with build-only"
	einfo "jarfrom"
	java-pkg_jarfrom --build-only ant-contrib ant-contrib.jar
	einfo "getjars"
	echo "$(java-pkg_getjars --build-only  ant-contrib)"
	einfo "getjar"
	echo "$(java-pkg_getjar --build-only ant-contrib ant-contrib.jar)"


}

src_compile() {
	eerror "This package is just a eclass unit test, it has nothing to compile."
}

