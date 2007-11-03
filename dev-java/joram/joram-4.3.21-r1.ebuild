# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit java-pkg-2 java-ant-2

DESCRIPTION="Joram is an Open Reliable Asynchronous Messagin system"
HOMEPAGE="http://joram.objectweb.org/index.html"
SRC_URI="http://download.fr2.forge.objectweb.org/${PN}/${P}-src.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 "
IUSE="doc source examples"


#JCup.jar
#midpapi.jar
#kxml.jar
#osgi.jar
#soap.war
#connector-1_5.jar
#jndi.jar
#ow_monolog.jar
#JCup.jar                ?
#connector-1_5.jar       1.5
#jndi.jar                1.2.1
#kxml.jar                ?
#midpapi.jar             ?
#ow_monolog.jar          2.1.1
#soap.war                ?

JDOM_SLOT="1.0_beta9"
DEPEND=">=virtual/jdk-1.4
		dev-java/sun-jaf
		>=dev-java/sun-jmx-1.2.1-r1
		>=dev-java/jta-1.0.1
		>=dev-db/hsqldb-1.8.0.4
		>=dev-java/commons-logging-1.1-r2
		>=dev-java/sun-jms-1.1-r2
		=dev-java/jakarta-regexp-1.3*
		>=dev-java/sun-javamail-1.4
		>=dev-java/soap-2.3.1
		>=dev-java/jdom-${JDOM_SLOT}
		>=dev-java/juddi-0.9_rc4
		>=dev-java/jgroupsi-2.2.7-r1
		>=dev-java/log4j-1.2.13
		>=dev-java/commons-logging-1.0.4-r1
		>=dev-java/junit-3.8.2
		>=www-servers/axis-1.2_rc2
		>=dev-java/monolog-1.9.1
		>=dev-java/kxml-1.2.1
		>=dev-java/commons-discovery-0.2-r2
		>=dev-java/sun-javamail-1.4
"
RDEPEND="${DEPEND} >=virtual/jre-1.4"

EANT_BUILD_TARGET="dist"

src_unpack(){
	unpack ${A}
	cd "${S}/lib" || die "cd failed"
	pwd
	# getting  Dependencies
	java-pkg_jar-from sun-jaf
	java-pkg_jar-from sun-jmx
	java-pkg_jar-from jta
	java-pkg_jar-from hsqldb
	java-pkg_jar-from commons-logging
	java-pkg_jar-from sun-jms
	java-pkg_jar-from jakarta-regexp-1.3 jakarta-regexp.jar	jakarta-regexp-1.2.jar
	java-pkg_jar-from sun-javamail
	java-pkg_jar-from soap
	java-pkg_jar-from jgroups
	java-pkg_jar-from kxml
	java-pkg_jar-from monolog monolog.jar ow_monolog.jar

}

src_install() {
	java-pkg_newjar dist/lib/${PN}.jar
	use doc && java-pkg_dojavadoc dist/docs
	use source && java-pkg_dosrc modules/jaxr-api/src/java/
	use source && java-pkg_dosrc    modules/scout/src/java/
	if use examples; then
			dodir /usr/share/doc/${PF}/examples
			cp -r src/samples/* ${D}/usr/share/doc/${PF}/examples
	fi
}
