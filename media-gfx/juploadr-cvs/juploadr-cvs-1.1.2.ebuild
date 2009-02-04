# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 java-ant-2
MY_P=juploadr-${PV}
DESCRIPTION="Cross platform, cross-site Photo uploader."
HOMEPAGE="http://juploadr.sourceforge.net/"
SRC_URI="http://ebuild.linux-sevenler.org/distfiles/${MY_P}.tar.bz2"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5
	 dev-java/browserlauncher2
	 >=dev-java/commons-beanutils-1.7
	 dev-java/commons-codec
	 >=dev-java/commons-httpclient-3.0
	 dev-java/commons-logging
	 dev-java/sun-jai-bin
	 media-gfx/jim
	 dev-java/swt
	 dev-java/piccolo"

DEPEND=">=virtual/jdk-1.5
	${RDEPEND}"

S="${WORKDIR}/juploadr"
EANT_BUILD_TARGET="dist"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/gentoo-${PV}.patch"
	cd "${S}"
	mkdir lib
	cd lib
	java-pkg_jarfrom browserlauncher2-1.0,commons-codec,swt-3,piccolo
	java-pkg_jarfrom commons-beanutils-1.7 commons-beanutils.jar
	java-pkg_jarfrom commons-httpclient-3 commons-httpclient.jar
	java-pkg_jarfrom commons-logging commons-logging.jar
	java-pkg_jarfrom sun-jai-bin jai_core.jar
	java-pkg_jarfrom sun-jai-bin jai_codec.jar
	java-pkg_jarfrom jim jim-io.jar
}

src_install() {
	java-pkg_dojar dist/lib/juploadr.jar
	insinto /usr/share/juploadr/plugins
	doins dist/plugins/*
	java-pkg_regjar /usr/share/juploadr/plugins/restflickrapi.jar
	java-pkg_regjar /usr/share/juploadr/plugins/zooomrapi.jar
	java-pkg_dolauncher juploadr --main org.scohen.juploadr.app.JUploadr \
		--java_args -Djava.net.preferIPv4Stack=true \
		--pwd /usr/share/juploadr
	newicon src/java/org/scohen/juploadr/resources/juploadr_icon.png ${PN}.png
	make_desktop_entry juploadr "jUploadr" ${PN}.png
}
