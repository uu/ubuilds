# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="JavaServer Faces technology is a framework for building user interfaces for web applications"
HOMEPAGE="https://javaserverfaces.dev.java.net/"
SRC_URI="https://javaserverfaces.dev.java.net/files/documents/1866/52043/jsf-${PV/.0/_0}-b07-FCS-src.zip"
LICENSE="CDDL"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

COMMON_DEP="
	dev-java/ant-contrib
	=dev-java/commons-beanutils-1.6*
	>=dev-java/commons-collections-1.2
	>=dev-java/commons-digester-1.6
	>=dev-java/commons-logging-1.0.4
	=dev-java/jakarta-jstl-1.1*
	=dev-java/jsr250-1.0
	>=dev-java/junit-3.8.1
	dev-java/glassfish-servlet-api"

DEPEND=">=virtual/jdk-1.4
	doc? ( app-arch/unzip )
	${COMMON_DEP}"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

S="${WORKDIR}/javaserverfaces_sources"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	rm -fR repo
	
	cd "${S}/common/lib/"
	rm ant-contrib.jar
	java-pkg_jar-from ant-contrib

	mkdir -p "${S}/dependencies/jars/" && cd "${S}/dependencies/jars/"	
	java-pkg_jar-from junit junit.jar junit-3.8.1.jar
	java-pkg_jar-from commons-beanutils-1.6 commons-beanutils.jar com-sun-commons-beanutils-1.6.1.jar
	java-pkg_jar-from commons-collections commons-collections.jar com-sun-commons-collections-2.1.jar
	java-pkg_jar-from commons-digester commons-digester.jar com-sun-commons-digester-1.5.jar
	java-pkg_jar-from commons-logging commons-logging.jar com-sun-commons-logging-1.0.4.jar
#	java-pkg_jar-from ? jstl.jar jstl-1.2.jar
	java-pkg_jar-from jsr250 jsr250-api.jar jsr250-api-1.0.jar
#	java-pkg_jar-from maven-repository-importer maven-repository-importer.jar maven-repository-importer-1.2.jar
#	java-pkg_jar-from tlddoc tlddoc.jar tlddoc-1.3.jar
	java-pkg_jar-from glassfish-servlet-api-2.5 servlet-api.jar servlet-api-2.5.jar
	java-pkg_jar-from glassfish-servlet-api-2.5 jsp-api.jar jsp-api-2.1.jar

}
src_compile() {
	cd "${S}"
	
	local antflags="prepare.build.java.net -Djsf.build.home=${S}"
	antflags="${antflags} -Dcontainer.name=glassfish"
	antflags="${antflags} -Dcontainer.home=${S}/dependencies/glassfish"
	antflags="${antflags} -Dbuild.standalone=true"
	eant ${antflags}

}
src_install() {
	java-pkg_dojar ${PN}.jar
#	use doc && java-pkg_dojavadoc ${WORKDIR}/${JSF_P}/javadocs/
}
