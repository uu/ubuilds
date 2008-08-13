# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

#Change next lines when updating version
BUILD="8664"
#Change slot number between incompatible IDEA versions
SLOT="8"
#Change JDK version if required
RDEPEND=">=virtual/jdk-1.6"

DESCRIPTION="IntelliJ IDEA is an intelligent Java IDE"
HOMEPAGE="http://jetbrains.com/idea/"
SRC_URI="http://download.jetbrains.com/${PN}/${PN}-8.0M1.tar.gz"
LICENSE="IntelliJ-IDEA"
KEYWORDS="~x86 ~amd64"
S="${WORKDIR}/${PN}-${BUILD}"

src_install() {
	local dir="/opt/${P}"
	insinto ${dir}
	doins -r *
	chmod 755 ${D}/${dir}/bin/*.sh || die
	local exe=${PN}-${SLOT}
	local icon=${exe}.png
	newicon "bin/idea32.png" ${icon} || die
	dodir /usr/bin
	cat >${D}/usr/bin/${exe} <<-EOF
#!/bin/sh
/opt/${P}/bin/${PN}.sh \$@
EOF
	fperms 755 /usr/bin/${exe} || die
	make_desktop_entry ${exe} "IntelliJ IDEA ${PV}" ${icon} "Development;IDE" || die
}
