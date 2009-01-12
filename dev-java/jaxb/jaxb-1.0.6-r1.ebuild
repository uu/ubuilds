# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

JAVA_PKG_IUSE="source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Reference implementation of the JAXB specification."
HOMEPAGE="http://jaxb.dev.java.net/"
#SRC_URI="mirror://gentoo/${PN}-src-${PV}.zip"
SRC_URI="http://dev.gentooexperimental.org/~serkan/distfiles/${PN}-src-${PV}.zip"

LICENSE="CDDL"
SLOT="1"
KEYWORDS="~x86 ~amd64"
IUSE=""

COMMON_DEP="dev-java/codemodel:2
	dev-java/dom4j:1
	dev-java/iso-relax
	dev-java/msv
	dev-java/relaxng-datatype
	dev-java/xalan
	dev-java/xerces:2
	dev-java/xml-commons-resolver
	dev-java/xsdlib
	dev-java/xsom"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	dev-java/ant-core
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

S="${WORKDIR}/jaxb-ri-${PV}"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${PV}-resolver-1.2.patch
	epatch ${FILESDIR}/${PV}-xsom-20060901.patch
	epatch ${FILESDIR}/${PV}-codemodel-2.1.patch
	epatch ${FILESDIR}/${PV}-META-INF.patch

	cd "${S}/lib"
	rm -v *.jar || die
	java-pkg_jarfrom --build-only ant-core ant.jar
	java-pkg_jarfrom codemodel-2
	java-pkg_jarfrom dom4j-1
	java-pkg_jarfrom iso-relax
	java-pkg_jarfrom msv
	java-pkg_jarfrom relaxng-datatype
	java-pkg_jarfrom xalan
	java-pkg_jarfrom xerces-2
	java-pkg_jarfrom xml-commons-resolver
	java-pkg_jarfrom xsdlib
	java-pkg_jarfrom xsom
	cd "${S}/src/com/sun/"
	rm -rf codemodel # in dev-java/codemodel
	#rm -rf tools # in dev-java/jaxb-tools
	cp -v "${FILESDIR}/build.xml-1.0.6-r1" "${S}/build.xml" || die "cp failed"
}

src_install() {
	java-pkg_dojar jaxb-api.jar
	java-pkg_dojar jaxb-impl.jar
	java-pkg_dojar jaxb-xjc.jar
	use source && java-pkg_dosrc src/*
}
