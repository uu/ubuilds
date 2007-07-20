# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sun-jms/sun-jms-1.1-r2.ebuild,v 1.11 2007/07/11 19:58:38 mr_bones_ Exp $

inherit java-pkg-2

DOWNLOAD_PAGE="http://javashoplm.sun.com/ECom/docs/Welcome.jsp?StoreId=22&PartDetailId=J2EE_CONNECTOR-1.5-FR-CLASS-G-F&SiteId=JSC&TransactionId=noreg"

At="j2ee_connector-1_5-fr-spec-classes.zip"
DESCRIPTION="The Java J2EE Connector Architecture API."
HOMEPAGE="http://java.sun.com/j2ee/connector/"
SRC_URI="${At}"
LICENSE="sun-bcla-connector"
SLOT=1.5
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""
RDEPEND=">=virtual/jre-1.4"
DEPEND="app-arch/unzip
	>=virtual/jdk-1.4"
RESTRICT="fetch"



pkg_nofetch() {
	einfo
	einfo " Due to license restrictions, we cannot fetch the"
	einfo " distributables automagically."
	einfo
	einfo " 1. Visit ${DOWNLOAD_PAGE}"
	einfo " 2. Accept the License Agreement"
	einfo " 3. Download ${At}"
	einfo " 4. Move the file to ${DISTDIR}"
	einfo
}

src_unpack() {
	unpack "${A}"
}



src_install() {
	cd "${WORKDIR}"
	java-pkg_dojar connector-api.jar
}
