# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Java Image Manager"
HOMEPAGE="http://jim.sf.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${PV}.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="openldap"

RDEPEND=">=virtual/jre-1.5
	 dev-java/log4j
	 dev-java/flexdock
	 openldap? ( net-nds/openldap )"

DEPEND="${RDEPEND}
	>=virtual/jdk-1.5
	app-arch/unzip"

src_unpack() {
	mkdir -p ${S}
	cd ${S} && unpack ${A}
	cd lwo_libraries
	rm flexdock-0.4.0.jar
	rm log4j-1.2.8.jar
	java-pkg_jar-from log4j log4j.jar log4j-1.2.8.jar
	java-pkg_jar-from flexdock flexdock.jar flexdock-0.4.0.jar
}

src_compile() {
	for module in jim-io jim-imagebase jim; do
		cd ${S}/${module}/app && eant jar
	done
}

src_install() {
	java-pkg_newjar jim/app/output/Jim.jar ${PN}.jar
	java-pkg_newjar lwo_libraries/silk-1.2.jar silk.jar
	for module in jim-io jim-imagebase; do
		java-pkg_dojar ${module}/app/output/${module}.jar
	done
	java-pkg_dolauncher jim --main au.com.lastweekend.jim.Jim
	insinto /etc/openldap/schema
	use openldap && doins jim-imagebase/app/resources/openldap/etc/schema/jim.schema
}

pkg_postinst() {
	if use openldap; then
		einfo "Steps to use OpenLDAP to store and search image metadata"
		einfo "1. Add the following line to /etc/openldap/slapd.conf"
		einfo '	include "/etc/openldap/schema/jim.schema"'
		einfo "2. Restart your slapd if it's already running"
		einfo "3. Run the following command to load the initial data for the database"
		einfo "	sed 's:__SUFFIX__:YOUR_REAL_SUFFIX:g' < ${FILESDIR}/init.ldif | ldapadd"
	fi
}
