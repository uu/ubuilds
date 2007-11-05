# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jsch/jsch-0.1.34.ebuild,v 1.1 2007/09/01 15:09:44 betelgeuse Exp $

JAVA_PKG_IUSE="doc source examples"

inherit java-pkg-2 java-ant-2 osgi

DESCRIPTION="JSch is a pure Java implementation of SSH2."
HOMEPAGE="http://www.jcraft.com/jsch/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=virtual/jdk-1.4
	>=dev-java/jzlib-1.0.3"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	app-arch/zip	
	${RDEPEND}"

src_compile() {
	eant -Dproject.cp="$(java-pkg_getjars jzlib)" dist $(use_doc)
}

src_install() {
	local export_header="com.jcraft.jsch, com.jcraft.jsch.jce;x-internal:=true, com.jcraft.jsch.jcraft;x-internal:=true"
	
	java-pkg_newosgijar "${S}/dist/lib/jsch*.jar" "com.jcraft.jsch" "${export_header}" "JSch"

	dodoc README ChangeLog || die
	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc src/*
	use examples && java-pkg_doexamples examples
}
