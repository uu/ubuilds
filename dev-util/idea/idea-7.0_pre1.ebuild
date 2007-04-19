# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

#Change next lines when updating version
BUILD="6819"
#Change slot number between incompatible IDEA versions
SLOT="7"
#Change JDK version if required
RDEPEND=">=virtual/jdk-1.5"

MY_PV="7.0.M1"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="IntelliJ IDEA is an intelligent Java IDE intensely focused on \
developer productivity that provides a robust combination of enhanced \
development tools."
HOMEPAGE="http://jetbrains.com/idea/"
SRC_URI="http://download.jetbrains.com/${PN}/${MY_P}.tar.gz"
LICENSE="IntelliJ-IDEA"
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
AWT_TOOLKIT=MToolkit
export AWT_TOOLKIT
/opt/${P}/bin/${PN}.sh \$@
EOF
	fperms 755 /usr/bin/${exe}
	make_desktop_entry ${exe} "IntelliJ IDEA ${PV}" ${icon} "Development;IDE"
}
