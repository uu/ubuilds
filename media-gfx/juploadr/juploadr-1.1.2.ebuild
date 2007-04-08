# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2

MY_P="jUploadr-${PV}-linuxGTK-i386"
DESCRIPTION="Cross platform, cross-site Photo uploader."
HOMEPAGE="http://juploadr.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
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

DEPEND="app-arch/unzip"
S="${WORKDIR}/${MY_P}"

src_compile() {
	java-pkg_getjars browserlauncher2-1.0,commons-codec,swt-3,piccolo > /dev/null
	java-pkg_getjar commons-beanutils-1.7 commons-beanutils.jar > /dev/null
	java-pkg_getjar commons-httpclient-3 commons-httpclient.jar > /dev/null
	java-pkg_getjar commons-logging commons-logging.jar > /dev/null
	java-pkg_getjar sun-jai-bin jai_core.jar > /dev/null
	java-pkg_getjar sun-jai-bin jai_codec.jar > /dev/null
	java-pkg_getjar jim jim-io.jar > /dev/null
}

src_install() {
	java-pkg_dojar lib/juploadr.jar
	insinto /usr/share/juploadr/plugins
	doins plugins/*
	java-pkg_regjar /usr/share/juploadr/plugins/restflickrapi.jar
	java-pkg_regjar /usr/share/juploadr/plugins/zooomrapi.jar
	java-pkg_dolauncher juploadr --main org.scohen.juploadr.app.JUploadr \
		--java_args -Djava.net.preferIPv4Stack=true \
		--pwd /usr/share/juploadr
	newicon juploadr_icon.png ${PN}.png
	make_desktop_entry juploadr "jUploadr" ${PN}.png
}
