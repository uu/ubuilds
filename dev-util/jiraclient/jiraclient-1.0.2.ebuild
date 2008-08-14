# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/deskzilla/deskzilla-1.3.ebuild,v 1.2 2007/04/30 20:39:41 genone Exp $

inherit java-pkg-2 versionator

DESCRIPTION="A desktop client for Atlassian JIRA issue tracking system."
HOMEPAGE="http://almworks.com/${PN}"

MY_PV=$(replace_all_version_separators '_')
MY_P="${PN}-${MY_PV}"

#This can be safely removed after next JIRA Client release
S="${WORKDIR}/${PN}-$(get_version_component_range 1-2)"

SRC_URI="http://d1.almworks.com/.files/${MY_P}_without_jre.tar.gz"
LICENSE="ALMWorks-1.2"
RESTRICT="mirror"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=">=virtual/jre-1.5
	~dev-java/picocontainer-1.1
	>=dev-java/jdom-1.0
	>=dev-java/javolution-4.0.2
	>=dev-java/commons-codec-1.3
	>=dev-java/jgoodies-forms-1.0.7
	>=dev-java/nekohtml-0.9.5
	>=dev-java/commons-logging-1.0.4
	>=dev-java/xmlrpc-2.0.1
	dev-java/sun-jaf
	dev-java/sun-javamail
	dev-java/soap"

src_unpack() {
	unpack ${A}
	# Remove public bundled jars
	local lib="${S}/lib"
	local liborig="${S}/lib.orig"
	mv ${lib} ${liborig}
	mkdir ${lib}
	# They've patched commons-httpclient (was version 3.0)
	mv ${liborig}/commons-httpclient.jar ${lib}
	# Almworks proprietary lib
	mv ${liborig}/almworks-tracker-api.jar ${lib}
	# IntelliJ IDEA proprietary lib
	mv ${liborig}/forms_rt.jar ${lib}
	# God knows what's this. Anyway, proprietary.
	mv ${liborig}/twocents.jar ${lib}
	rm -rf ${liborig}
}

src_install () {
	local dir=/opt/${P}

	insinto ${dir}
	doins -r components license lib log jiraclient.url

	java-pkg_jarinto ${dir}
	java-pkg_dojar ${PN}.jar
	java-pkg_register-dependency picocontainer-1,jdom-1.0,commons-logging,commons-codec,nekohtml,jgoodies-forms,javolution-4,xmlrpc,sun-jaf,sun-javamail,soap
	java-pkg_dolauncher ${PN} --main "com.almworks.launcher.Launcher" --java_args "-Xmx256M"

	newdoc README.txt README

	doicon deskzilla.png
	make_desktop_entry ${PN} "JIRA Client" deskzilla.png "Development"
}

pkg_postinst() {
	elog "If you are going to use JIRA Client for an open source project,"
	elog "you can request free license:"
	elog "http://almworks.com/opensource.html?product=jiraclient"
}
