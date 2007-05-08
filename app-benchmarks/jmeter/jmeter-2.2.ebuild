# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

JAVA_PKG_IUSE="doc"
WANT_ANT_TASKS="ant-nodeps"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Load test and measure performance on HTTP/FTP services and databases."
HOMEPAGE="http://jakarta.apache.org/jmeter"
SRC_URI="mirror://apache/jakarta/jmeter/source/jakarta-${P}_src.tgz"

COMMON_DEPEND="
	=dev-java/avalon-logkit-1.2*
	dev-java/xstream
	dev-java/commons-collections
	=dev-java/avalon-framework-4.1*
	=dev-java/excalibur-logger-1.1*
	=dev-java/jakarta-oro-2*
	dev-java/jtidy
	=dev-java/batik-1.6*
	=dev-java/rhino-1.6*
	=dev-java/jdom-1.0*
	dev-java/xalan
	dev-java/jcharts
	dev-java/sun-javamail
	dev-java/soap
	dev-java/sun-jms
	=dev-java/commons-jexl-1*
	dev-java/junit
	=dev-java/commons-httpclient-3*
	=dev-java/excalibur-datasource-1*
	>=dev-java/bsf-2.3"

DEPEND=">=virtual/jdk-1.4
	doc? ( =dev-java/jdom-1.0* dev-java/velocity )
	${COMMON_DEPEND}"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPEND}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc"

S=${WORKDIR}/jakarta-${P}

src_unpack() {
	unpack ${A}
	cd ${S}
	#Do not remove legacy dir or build will fail.
	rm -rf lib/* legacy/* docs/*
	java-pkg_jar-from --into lib avalon-logkit-1.2,avalon-framework-4.1,excalibur-logger-1,xstream,commons-collections,jakarta-oro-2.0,jtidy,batik-1.6,rhino-1.6,jdom-1.0,xalan,jcharts,commons-jexl-1.0,junit,commons-httpclient-3,excalibur-datasource-1,bsf-2.3,sun-javamail,soap,sun-jms
}

src_compile() {
	local antflags="package"
	if use doc ; then
		antflags="${antflags} docs-all"
		export ANT_TASKS="${WANT_ANT_TASKS} velocity"
	fi
	eant ${antflags}
}

src_install() {
	local prefix="/usr/share/${JAVA_PKG_NAME}"

	#JMeter uses classloader magic and won't find jars if there are in another places.
	insinto ${prefix}/bin
	newins bin/jmetertest.properties jmeter.properties
	java-pkg_jarinto ${prefix}/bin
	java-pkg_dojar bin/ApacheJMeter.jar
	java-pkg_jarinto ${prefix}/lib
	java-pkg_dojar lib/htmlparser*.jar lib/bshclient.jar lib/jorphan.jar
	java-pkg_jarinto ${prefix}/lib/ext
	java-pkg_dojar lib/ext/*.jar

	java-pkg_dolauncher ${PN} --pwd "/usr/share/${JAVA_PKG_NAME}/bin" --java_args "-Xms256m -Xmx256m -XX:NewSize=128m -XX:MaxNewSize=128m -XX:MaxTenuringThreshold=2 -Dsun.rmi.dgc.client.gcInterval=600000 -Dsun.rmi.dgc.server.gcInterval=600000 -XX:PermSize=64m -XX:MaxPermSize=64m -verbose:gc -XX:+PrintTenuringDistribution -server" --main "org.apache.jmeter.NewDriver" || die "Could not create launcher"
	dodoc README NOTICE
	dosym $(java-pkg_getjars junit) ${prefix}/lib/junit/test.jar

	if use doc ; then
		java-pkg_dojavadoc docs/api
		insinto ${prefix}
		#Maybe better use dodoc and then create a symlink?
		doins -r printable_docs
	fi
}
