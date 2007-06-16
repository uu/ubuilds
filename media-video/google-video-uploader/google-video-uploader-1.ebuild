# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2

DESCRIPTION="Google Video Uploader for linux"
HOMEPAGE="http://video.google.com"
SRC_URI="https://upload.video.google.com/GoogleVideoUploader.jar"

LICENSE=""
KEYWORDS="~x86 ~amd64"
DEPEND=""
RDEPEND=">=virtual/jre-1.4.1"
SLOT="0"

src_unpack() {
	mkdir -p ${S}
	cp ${DISTDIR}/GoogleVideoUploader.jar ${S}/
}

src_compile(){ :; }

src_install() {
	java-pkg_dojar GoogleVideoUploader.jar
	java-pkg_dolauncher ${PN} --main com.google.uploader.Uploader
}
