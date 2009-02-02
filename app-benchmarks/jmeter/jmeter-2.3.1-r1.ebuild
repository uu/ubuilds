# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=1
JAVA_PKG_IUSE="doc source"
WANT_ANT_TASKS="ant-nodeps"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Load test and measure performance on HTTP/FTP services and databases."
HOMEPAGE="http://jakarta.apache.org/jmeter"
SRC_URI="mirror://apache/jakarta/jmeter/source/jakarta-${P}_src.tgz"

JAVA_RDEPEND="dev-java/bsf:2.3
		dev-java/avalon-framework:4.1
		dev-java/commons-codec
		dev-java/commons-collections
		dev-java/commons-httpclient:3
		dev-java/commons-io:1
		dev-java/commons-jexl:1.0
		dev-java/commons-lang:2.1
		dev-java/commons-net
		dev-java/excalibur-compatibility
		dev-java/excalibur-datasource:1
		dev-java/excalibur-i18n
		dev-java/excalibur-instrument:1
		dev-java/excalibur-logger:1
		dev-java/jakarta-oro:2.0
		dev-java/jcharts
		dev-java/jdom:1.0
		dev-java/jtidy
		dev-java/junit
		dev-java/rhino:1.6
		dev-java/soap
		dev-java/xstream
		dev-java/xpp3
		dev-java/xalan
		dev-java/xerces:2.6
		"
#Missing Geronimo activation.jar
CDEPEND="dev-java/avalon-logkit:1.2
		dev-java/batik:1.6
		java-virtuals/javamail
		dev-java/commons-logging
		dev-java/excalibur-pool
		dev-java/htmlparser
		dev-java/xml-commons-external:1.3
		dev-java/sun-jms
		"

DEPEND=">=virtual/jdk-1.4
		doc? (  dev-java/velocity )
		${CDEPEND} ${JAVA_RDEPEND}
		dev-java/bsh"
RDEPEND=">=virtual/jre-1.4
		${CDEPEND} ${JAVA_RDEPEND}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

S="${WORKDIR}/jakarta-${P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	cp "${FILESDIR}/build.properties" .
	#Do not remove legacy dir or build will fail.
	rm -rf lib/* legacy/* docs/*
	mkdir -p lib/opt lib/api lib/doc lib/junit || die "Unable to create dir"

	#Install all dependencies into lib/opt as build script includes all jar's
	#instead of including versioned jar's from lib.
	for line in ${JAVA_RDEPEND}; do
		java-pkg_jar-from --into lib `echo "${line}" | sed -e 's_dev-java/\(\s*\)_\1_' | sed -e "s/:/-/"`
	done

	cd lib
	java-pkg_jar-from avalon-logkit-1.2 avalon-logkit.jar logkit.jar
	java-pkg_jar-from --into api --virtual javamail
	#sun-jms is replacing geronimo's
	java-pkg_jar-from --into api sun-jms
	java-pkg_jar-from batik-1.6 batik-awt-util.jar
	java-pkg_jar-from commons-logging commons-logging.jar
	java-pkg_jar-from excalibur-pool excalibur-pool-api.jar excalibur-pool.jar
	java-pkg_jar-from htmlparser htmllexer.jar
	java-pkg_jar-from htmlparser htmlparser.jar
	java-pkg_jar-from xml-commons-external-1.3 xml-apis.jar
	java-pkg_jar-from --into opt --build-only bsh
	use doc && java-pkg_jar-from --into doc --build-only velocity

}

src_compile() {
	local antflags="all"
	if use doc ; then
		antflags="${antflags} docs-api docs-printable"
		export ANT_TASKS="${WANT_ANT_TASKS} velocity"
	fi
	eant ${antflags}
}

src_test() {
	eant test
}

src_install() {
	local prefix="/usr/share/${JAVA_PKG_NAME}"

	#JMeter uses classloader magic and won't find jars if there are in another place.
	insinto "${prefix}/bin"
	doins "${FILESDIR}"/properties/*.properties
	doins "${FILESDIR}"/*.xml "${FILESDIR}"/*.conf
	java-pkg_jarinto "${prefix}/bin"
	java-pkg_dojar bin/ApacheJMeter.jar
	java-pkg_jarinto "${prefix}/lib"
	java-pkg_dojar lib/*.jar
	#java-pkg_dojar lib/ext/htmlparser*.jar lib/ext/bshclient.jar lib/ext/jorphan.jar
	java-pkg_jarinto "${prefix}/lib/ext"
	java-pkg_dojar lib/ext/*.jar

	java-pkg_dolauncher ${PN} --pwd "/usr/share/${JAVA_PKG_NAME}/bin" --java_args "-Xms256m -Xmx256m -XX:NewSize=128m -XX:MaxNewSize=128m -XX:MaxTenuringThreshold=2 -Dsun.rmi.dgc.client.gcInterval=600000 -Dsun.rmi.dgc.server.gcInterval=600000 -XX:PermSize=64m -XX:MaxPermSize=64m -verbose:gc -XX:+PrintTenuringDistribution -server" --main "org.apache.jmeter.NewDriver"
	dodoc README NOTICE
	dosym $(java-pkg_getjars junit) ${prefix}/lib/junit/test.jar

	if use doc ; then
		java-pkg_dojavadoc docs/api
		insinto ${prefix}
		#Maybe better use dodoc and then create a symlink?
		doins -r printable_docs
	fi

	use source && java-pkg_dosrc src/components/* src/core/* \
		src/functions/* src/jorphan/* src/junit/* src/monitor/* \
		src/protocol/*/* src/reports/*
}
