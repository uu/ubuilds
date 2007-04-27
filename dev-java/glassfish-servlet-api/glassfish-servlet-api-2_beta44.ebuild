# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Glassfish reference implementation of Servlet API 2.5 and JSP API 2.1"
HOMEPAGE="https://glassfish.dev.java.net/javaee5/webtier/webtierhome.html"
SRC_URI="http://download.java.net/javaee5/trunk/promoted/source/glassfish-v2-b39-src.zip"
LICENSE="CDDL"
SLOT="2.5"
KEYWORDS="~amd64 ~x86"

COMMON_DEP=""

DEPEND=">=virtual/jdk-1.5
	doc? ( app-arch/unzip )
	${COMMON_DEP}"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

S="${WORKDIR}/glassfish/servlet-api/"

EANT_BUILD_TARGET="build"
EANT_EXTRA_ARGS=$( ! use doc && echo "-Ddocs.uptodate=true")

src_unpack() {
	unpack "${A}"
	cd "${S}"

	epatch ${FILESDIR}/build_xml.patch
}
src_install() {
	cd "${S}"/src/jakarta-servletapi-5/jsr154/dist/lib
	java-pkg_dojar servlet-api.jar

	cd "${S}"src/jsr245/dist/lib/
	java-pkg_dojar jsp-api.jar	
}
