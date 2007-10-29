# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="test"
WANT_ANT_TASKS="ant-nodeps"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Facebook photo uploader."
HOMEPAGE="http://code.google.com/p/fb-photo-uploader/"
SRC_URI="http://ebuild.linux-sevenler.org/distfiles/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.5
	 dev-java/browserlauncher2
	 dev-java/commons-collections
	 dev-java/commons-configuration
	 >=dev-java/commons-lang-2.1
	 dev-java/commons-logging
	 >=dev-java/ehcache-1.2
	 dev-java/log4j
	 dev-java/json"

DEPEND=">=virtual/jdk-1.5
	test?
	(
		dev-java/junit
		dev-java/ant-trax
		dev-java/ant-junit
	)
	${RDEPEND}"

EANT_BUILD_TARGET="package"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/gentoo-${PV}.patch
	cd ${S}/lib
	java-pkg_jarfrom browserlauncher2-1.0,commons-collections,commons-configuration,commons-lang-2.1,ehcache-1.2,json,log4j
	java-pkg_jarfrom commons-logging commons-logging.jar
	use test && java-pkg_jarfrom --build-only junit
}

src_install() {
	java-pkg_dojar package/zip/bin/fb-uploader.jar
	java-pkg_dolauncher fb-photo-uploader --main uk.me.phillsacre.uploader.FacebookUploader
}

src_test() {
	ANT_TASKS="ant-junit ant-nodeps ant-trax" eant test
}
