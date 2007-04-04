# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2

DESCRIPTION="Deskzilla is a desktop client for Mozilla's Bugzilla bug tracking system."
HOMEPAGE="http://almworks.com/deskzilla"

MY_PV="1_3_b2"
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"
SRC_URI="http://d1.almworks.com/.files/${MY_P}_without_jre.tar.gz"
LICENSE="ALMWorks-1.2"
SLOT="0"
KEYWORDS="~x86"

RDEPEND=">=virtual/jre-1.5.0
	>=dev-java/picocontainer-1.1
	>=dev-java/jdom-1.0
	>=dev-java/javolution-4.0.2
	>=dev-java/commons-codec-1.3
	>=dev-java/jgoodies-forms-1.0.7
	>=dev-java/nekohtml-0.9.5
	>=dev-java/commons-logging-1.0.4
	>=dev-java/xmlrpc-1.2_beta1"

src_unpack() {
	unpack ${A}
	#Remove public bundled jars
	local lib="${S}/lib"
	local liborig="${S}/lib.orig"
	mv ${lib} ${liborig}
	mkdir ${lib}
	#They've patched commons-httpclient (was version 3.0)
	mv ${liborig}/commons-httpclient.jar ${lib}
	#Almworks proprietary lib
	mv ${liborig}/almworks-tracker-api.jar ${lib}
	#IntelliJ IDEA proprietary lib
	mv ${liborig}/forms_rt.jar ${lib}
	#God knows what's this. Anyway, proprietary.
	mv ${liborig}/twocents.jar ${lib}
	rm -rf ${liborig}
}

src_install () {
	#This is stupid
	java-pkg_getjars picocontainer-1,jdom-1.0,commons-logging,commons-codec,nekohtml,jgoodies-forms,javolution-2.2,xmlrpc > /dev/null

	local dir=/opt/${P}
	insinto ${dir}
	doins -r components etc license lib log deskzilla.url license.html README.txt
	doicon deskzilla.png
	java-pkg_jarinto ${dir}
	java-pkg_dojar ${PN}.jar
	java-pkg_dolauncher ${PN} --main "com.almworks.launcher.Launcher" --java_args "-Xmx256M"
	make_desktop_entry deskzilla "Deskzilla" deskzilla.png "Development"
}
