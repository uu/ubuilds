# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"

#WANT_ANT_TASKS="ant-txt2html"

inherit java-pkg-2 java-ant-2

DESCRIPTION="JavaServer Faces technology is a framework for building user interfaces for web applications"
HOMEPAGE="http://glassfish.dev.java.net/"
SRC_URI="http://download.java.net/javaee5/trunk/promoted/source/glassfish-v2-b39-src.zip"
LICENSE="CDDL"
SLOT="2.5"
KEYWORDS="~amd64 ~x86"

COMMON_DEP=""

DEPEND=">=virtual/jdk-1.5
	doc? ( app-arch/unzip )
	${COMMON_DEP}"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

S="${WORKDIR}/glassfish/servlet-api/"

EANT_BUILD_TARGET="build"

#src_unpack() {
#	unpack "${A}"
#	cd "${S}"
#	rm -fR repo
#	
#	cd "${S}/common/lib/"
#	rm ant-contrib.jar
#	java-pkg_jar-from ant-contrib
#
#}
#src_compile() {
#	cd "${S}"
#	
#	local antflags="prepare.build.java.net -Djsf.build.home=${S}"
#	antflags="${antflags} -Dcontainer.name=glassfish"
#	antflags="${antflags} -Dcontainer.home=${S}/dependencies/glassfish"
#	antflags="${antflags} -Dbuild.standalone=true"
#	eant ${antflags}
#
#}
src_install() {
	java-pkg_dojar ${PN}.jar
#	use doc && java-pkg_dojavadoc ${WORKDIR}/${JSF_P}/javadocs/
}
