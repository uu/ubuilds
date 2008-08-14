# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/deskzilla/deskzilla-1.3.ebuild,v 1.2 2007/04/30 20:39:41 genone Exp $

inherit java-pkg-2 versionator

DESCRIPTION="A desktop client for Atlassian JIRA issue tracking system."
HOMEPAGE="http://almworks.com/${PN}"

#MY_PV=$(replace_all_version_separators '_')
MY_PV="1_4_b1"
MY_P="${PN}-${MY_PV}"

S="${WORKDIR}/${MY_P}"

SRC_URI="http://d1.almworks.com/.files/${MY_P}_without_jre.tar.gz"
LICENSE="ALMWorks-1.2"
RESTRICT="mirror"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=">=virtual/jre-1.5
	~dev-java/picocontainer-1.1
	>=dev-java/javolution-4.0.2
	>=dev-java/commons-codec-1.3
	>=dev-java/nekohtml-0.9.5
	>=dev-java/commons-logging-1.0.4
	>=dev-java/xmlrpc-2.0.1
	>=dev-java/jdom-1.0
	>=dev-java/jazzy-0.5.2
	>=dev-java/jgoodies-forms-1.0.7
	java-virtuals/jaf
	java-virtuals/javamail
	dev-java/soap
	dev-java/xpp2"

src_unpack() {
	unpack ${A}
	# Remove public bundled jars
	local lib="${S}/lib"
	local liborig="${S}/lib.orig"
	mv ${lib} ${liborig} || die
	mkdir ${lib} || die
	# They've patched commons-httpclient (was version 3.0)
	mv ${liborig}/commons-httpclient.jar ${lib} || die
	# Almworks proprietary lib
	mv ${liborig}/almworks-tracker-api.jar ${lib} || die
	# IntelliJ IDEA proprietary lib
	mv ${liborig}/forms_rt.jar ${lib} || die
	# God knows what's this. Anyway, proprietary.
	mv ${liborig}/twocents.jar ${lib} || die
	rm -rf ${liborig} || die
}

src_install () {
	local dir=/opt/${P}

	insinto ${dir}
	doins -r components license lib log jiraclient.url

	java-pkg_jarinto ${dir}
	java-pkg_dojar ${PN}.jar || die
	java-pkg_register-dependency xpp2,jgoodies-forms,jazzy,picocontainer-1,jdom-1.0,commons-logging,commons-codec,nekohtml,javolution-4,xmlrpc,jaf,javamail,soap
	java-pkg_dolauncher ${PN} --main "com.almworks.launcher.Launcher" --java_args "-Xmx256M" || die

	newdoc README.txt README || die

	doicon ${PN}.png || die
	make_desktop_entry ${PN} "JIRA Client" ${PN}.png "Development" || die
}

pkg_postinst() {
	elog "If you are going to use JIRA Client for an open source project,"
	elog "you can request free license:"
	elog "http://almworks.com/opensource.html?product=${PN}"
}
