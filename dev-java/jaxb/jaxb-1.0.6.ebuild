# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Reference implementation of the JAXB specification."
HOMEPAGE="http://jaxb.dev.java.net/"
#SRC_URI="mirror://gentoo/${PN}-src-${PV}.zip"
SRC_URI="http://dev.gentooexperimental.org/~serkan/distfiles/${PN}-src-${PV}.zip"

LICENSE="CDDL"
SLOT="1"
KEYWORDS="~x86 ~amd64"
IUSE=""

COMMON_DEP="dev-java/relaxng-datatype
	dev-java/msv
	dev-java/xsdlib"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

S="${WORKDIR}/jaxb-ri-${PV}"

src_unpack() {
	unpack ${A}
	cd "${S}/lib"
	rm -v *.jar || die
	java-pkg_jarfrom msv
	java-pkg_jarfrom relaxng-datatype
	java-pkg_jarfrom xsdlib
	cd "${S}/src/com/sun/"
	rm -rf codemodel # in dev-java/codemodel
	rm -rf tools # in dev-java/jaxb-tools
	cp -v "${FILESDIR}/build.xml-${PV}" "${S}/build.xml" || die "cp failed"

}

src_install() {
	java-pkg_dojar jaxb-api.jar
	java-pkg_dojar jaxb-impl.jar
	use source && java-pkg_dosrc src/*
}
