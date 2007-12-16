# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

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
	${RDEPEND}"

src_compile() {
	# for ANT_TASKS see
	# https://bugs.gentoo.org/show_bug.cgi?id=200309
	ANT_TASKS="none" eant -Dproject.cp="$(java-pkg_getjars jzlib)" dist $(use_doc)
}

src_install() {
	local export_header="com.jcraft.jsch, com.jcraft.jsch.jce;x-internal:=true, com.jcraft.jsch.jcraft;x-internal:=true"
	#java-pkg_newjar dist/lib/jsch*.jar
	java-pkg_newosgijar ${S}/dist/lib/jsch*.jar "com.jcraft.jsch" "JSch" \
		"${export_header}"
	dodoc README ChangeLog || die
	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc src/*
	use examples && java-pkg_doexamples examples
}
