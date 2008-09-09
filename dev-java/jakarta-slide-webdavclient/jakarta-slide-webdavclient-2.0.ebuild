# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"
EAPI="1"

inherit java-pkg-2 java-ant-2

DESCRIPTION="WebDAV client implementation and commandline client."
HOMEPAGE="http://jakarta.apache.org/slide/"
SRC_URI="http://archive.apache.org/dist/jakarta/slide/source/${PN}-src-${PV}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""

IUSE=""

COMMON_DEP="dev-java/antlr
			dev-java/commons-httpclient:0
			dev-java/commons-logging"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}"

S="${WORKDIR}/${PN}-src-${PV}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	rm -fv lib/*.jar
	java-pkg_jar-from --into lib antlr,commons-httpclient,commons-logging
}

EANT_BUILD_TARGET="dist-cmd"
EANT_DOC_TARGET="javadoc-clientlib"

src_install() {
	java-pkg_newjar dist/lib/jakarta-slide-commandline-2.0.jar jakarta-slide-commandline.jar
	java-pkg_newjar dist/lib/jakarta-slide-webdavlib-2.0.jar jakarta-slide-webdavlib.jar
	use doc && java-pkg_dojavadoc dist/doc/clientjavadoc
	use source && java-pkg_dosrc clientlib/src/java/*

	java-pkg_dolauncher slide-webdavclient --main org.apache.webdav.cmd.Slide
}

pkg_postinst() {
	ewarn "WARNING!!! This package has been retired upstream"
	ewarn "WARNING!!! It is unmaintained and therefore may pose"
	ewarn "WARNING!!! a security risk."
}

