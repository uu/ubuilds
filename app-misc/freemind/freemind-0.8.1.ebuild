# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
JAVA_PKG_BSFIX="off"
JAVA_PKG_IUSE="doc"
inherit java-pkg-2 java-ant-2 eutils

MY_PV=${PV//./_}

DESCRIPTION="Mind-mapping software written in Java"
HOMEPAGE="http://freemind.sf.net"
SRC_URI="mirror://sourceforge/freemind/${PN}-src-${MY_PV}.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

CDEPEND="java-virtuals/jaxb-virtual:1
	dev-java/msv
	dev-java/relaxng-datatype
	dev-java/iso-relax
	dev-java/jgoodies-forms
	dev-java/commons-lang:2.1
	dev-java/javahelp
	dev-java/batik:1.6
	dev-java/fop
	dev-java/jcalendar"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.4
	app-arch/unzip"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.4"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	find -name "*.jar" -delete
	epatch "${FILESDIR}/${P}.patch"
	for xml in $(find . -name 'build*.xml'); do
		java-ant_rewrite-classpath ${xml}
		java-ant_bsfix_one ${xml}
	done
}

EANT_BUILD_TARGET="dist browser"
EANT_DOC_TARGET="doc"
EANT_GENTOO_CLASSPATH="jaxb-virtual-1,msv,relaxng-datatype,iso-relax,jgoodies-forms,commons-lang-2.1,javahelp,batik-1.6,fop,jcalendar-1.2"

src_install() {
	local dest="/usr/share/${PN}/"
	cd "${WORKDIR}/bin/dist" || die
	java-pkg_dojar lib/${PN}.jar
	insinto "${dest}"
	doins -r accessories/ browser/ plugins/ doc/ user.properties patterns.xml || die
	use doc && java-pkg_dojavadoc doc/javadoc
	java-pkg_dolauncher ${PN} --pwd "${dest}" --main freemind.main.FreeMind
	newicon "${S}"/images/FreeMindWindowIcon.png freemind.png
	make_desktop_entry freemind Freemind freemind Utility
}
