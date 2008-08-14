# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

#Change next lines when updating version
BUILD="6197"
#Change slot number between incompatible IDEA versions
SLOT="6"
#Change JDK version if required
RDEPEND=">=virtual/jdk-1.5"

DESCRIPTION="IntelliJ IDEA is an intelligent Java IDE"
HOMEPAGE="http://jetbrains.com/idea/"
SRC_URI="http://download.jetbrains.com/${PN}/${P}.tar.gz"
LICENSE="IntelliJ-IDEA"
IUSE=""
KEYWORDS="~x86"
S="${WORKDIR}/${PN}-${BUILD}"

src_install() {
	local dir="/opt/${P}"
	insinto ${dir}
	doins -r *
	chmod 755 ${D}/${dir}/bin/*.sh
	local exe=${PN}-${SLOT}
	local icon=${exe}.png
	newicon "bin/idea32.png" ${icon}
	dodir /usr/bin
	cat >${D}/usr/bin/${exe} <<-EOF
#!/bin/sh
/opt/${P}/bin/${PN}.sh \$@
EOF
	fperms 755 /usr/bin/${exe}
	make_desktop_entry ${exe} "IntelliJ IDEA ${PV}" ${icon} "Development;IDE"
}
