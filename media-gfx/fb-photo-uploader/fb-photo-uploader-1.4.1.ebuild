# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

JAVA_PKG_IUSE="test"
WANT_ANT_TASKS="ant-nodeps"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Facebook photo uploader."
HOMEPAGE="http://code.google.com/p/fb-photo-uploader/"
SRC_URI="http://dev.gentooexperimental.org/~serkan/distfiles/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-java/browserlauncher2:1.0
	dev-java/commons-collections
	dev-java/commons-configuration
	dev-java/commons-lang:2.1
	dev-java/commons-logging
	dev-java/ehcache:1.2
	dev-java/log4j
	dev-java/facebook-java-api:1
	dev-java/swingx:0.9
	dev-java/metadata-extractor"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}
	dev-java/jgoodies-looks:2.0"

DEPEND=">=virtual/jdk-1.6
	test?
	(
		dev-java/junit
		dev-java/ant-trax
		dev-java/ant-junit
	)
	${CDEPEND}"

EANT_BUILD_TARGET="create-zip-files"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${P}-gentoo.patch
	cd "${S}" || die
	mkdir package || die
	cd lib || die
	java-pkg_jarfrom browserlauncher2:1.0,commons-collections,commons-configuration,commons-lang:2.1,ehcache:1.2,log4j,facebook-java-api-1,swingx-0.9,metadata-extractor
	java-pkg_jarfrom commons-logging commons-logging.jar
	use test && java-pkg_jarfrom --build-only junit
}

src_install() {
	java-pkg_dojar package/zip/bin/fb-uploader.jar
	java-pkg_register-dependency jgoodies-looks:2.0
	java-pkg_dolauncher fb-photo-uploader \
		--main uk.me.phillsacre.uploader.FacebookUploader \
		--pwd /usr/share/fb-photo-uploader
	insinto /usr/share/fb-photo-uploader
	doins package/zip/resources/{user,static}.properties || die
}

src_test() {
	ANT_TASKS="ant-junit ant-nodeps ant-trax" eant test
}
