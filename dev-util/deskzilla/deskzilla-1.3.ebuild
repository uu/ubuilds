# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 versionator

DESCRIPTION="Deskzilla is a desktop client for Mozilla's Bugzilla bug tracking system."
HOMEPAGE="http://almworks.com/deskzilla"

MY_PV=$(replace_all_version_separators '_')
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"
SRC_URI="http://d1.almworks.com/.files/${MY_P}_without_jre.tar.gz"
LICENSE="ALMWorks-1.2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jre-1.5
	~dev-java/picocontainer-1.1
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
	java-pkg_record-jar_	picocontainer-1
	java-pkg_record-jar_	jdom-1.0
	java-pkg_record-jar_	commons-logging
	java-pkg_record-jar_	commons-codec
	java-pkg_record-jar_	nekohtml
	java-pkg_record-jar_	jgoodies-forms
	java-pkg_record-jar_	javolution-2.2
	java-pkg_record-jar_	xmlrpc
	#java-pkg_getjars picocontainer-1,jdom-1.0,commons-logging,commons-codec,nekohtml,jgoodies-forms,javolution-2.2,xmlrpc > /dev/null

	local dir=/opt/${P}
	insinto ${dir}
	doins -r components etc license lib log deskzilla.url
	doicon deskzilla.png
	newdoc README.txt README
	java-pkg_jarinto ${dir}
	java-pkg_dojar ${PN}.jar
	java-pkg_dolauncher ${PN} --main "com.almworks.launcher.Launcher" --java_args "-Xmx256M"
	make_desktop_entry deskzilla "Deskzilla" deskzilla.png "Development"
}

pkg_postinst() {
	einfo "If you are going to use Deskzilla for open source project you can request a free license:"
	einfo "http://almworks.com/opensource.html?product=deskzilla"
}
