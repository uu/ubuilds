# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-logging/commons-logging-1.1-r2.ebuild,v 1.9 2007/04/07 04:28:54 wltjr Exp $

JAVA_PKG_IUSE="doc source test"

ANT_TASKS="jarjar-1"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Guice is a lightweight dependency injection framework for Java 5 and above."
HOMEPAGE="http://code.google.com/p/google-guice/"
SRC_URI="http://google-guice.googlecode.com/files/${P}-src.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="dev-java/aopalliance
		=dev-java/asm-3*
		dev-java/commons-logging
		=dev-java/cglib-2.2_beta1
		>=dev-java/jarjar-0.9
		=dev-java/tomcat-servlet-api-6.0*"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"
DEPEND=">=virtual/jdk-1.5
	dev-java/ant-core
	source? ( app-arch/zip )
	test? ( dev-java/junit )
	${COMMON_DEPEND}"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/build_xml.patch"

#	find . -name "*.jar" | xargs rm -frv
	find "${S}/struts2/" -name "*.jar" | xargs rm -frv
	find . -name "*.class" | xargs rm -frv

	cd "${S}/lib/build/"
	rm -f asm-3.0.jar cglib*.jar commons-logging-1.0.4.jar jarjar-0.9.jar junit.jar
	java-pkg_jar-from asm-3 asm.jar asm-3.0.jar
	java-pkg_jar-from cglib-2.2 cglib-nodep.jar cglib-nodep-2.2.jar
	java-pkg_jar-from commons-logging commons-logging.jar commons-logging-1.0.4.jar
	java-pkg_jar-from jarjar-1 jarjar.jar jarjar-0.9.jar

	cd ../
	rm -f aopalliance.jar
	java-pkg_jar-from aopalliance-1 aopalliance.jar

	cd "${S}/servlet/lib/build/"
	rm -f servlet-api-2.5.jar
	java-pkg_jar-from tomcat-servlet-api-2.5 servlet-api.jar servlet-api-2.5.jar

}

# dist target will build all jars, otherwise jar will build only guice.jar
#EANT_BUILD_TARGET="dist"

src_install() {
	java-pkg_newjar build/dist/${P}.jar ${PN}.jar
#	java-pkg_newjar servlet/build/dist/${PN}-servlet-${PV}.jar ${PN}-servlet.jar
#	java-pkg_newjar spring/build/dist/${PN}-spring-${PV}.jar ${PN}-spring.jar
#	java-pkg_newjar struts2/build/dist/${PN}-struts2-plugin-${PV}.jar ${PN}-struts2-plugin.jar

	use doc && java-pkg_dojavadoc javadoc/
	use source && java-pkg_dosrc src/com
}
