# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/groovy/groovy-1.0-r1.ebuild,v 1.4 2007/07/04 22:14:28 betelgeuse Exp $

# Groovy's build system is Ant based, but they use Maven for fetching the dependencies.
# We just have to remove the fetch dependencies target, and then we can use Ant for this ebuild.
#
# Note that in the previous 1.0 ebuild, we used the Ant Maven plugin. We don't do that anymore.

inherit versionator java-pkg-2 java-ant-2

MY_PV=${PV/_rc/-RC-}
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Groovy is a high-level dynamic language for the JVM"
HOMEPAGE="http://groovy.codehaus.org/"

SRC_URI="http://dist.groovy.codehaus.org/distributions/${PN}-src-${PV}.zip"
LICENSE="codehaus-groovy"
SLOT="1"
KEYWORDS=""
IUSE="bsf doc"

# testcases won't even compile in current state
#RESTRICT="test"

CDEPEND="
	dev-java/asm:2.2
	dev-java/antlr:0
	>=dev-java/xstream-1.1.1
	>=dev-java/junit-3.8.2
	>=dev-java/jline-0.9.91
	>=dev-java/ant-core-1.7.0
	>=dev-java/commons-cli-1.0
	>=dev-java/mockobjects-0.09
	~dev-java/servletapi-2.4
	=dev-java/mx4j-core-3.0*
	>=dev-java/bsf-2.4
	
	test? (
	dev-java/jmock
	>=dev-java/xmlunit-1.1
	dev-db/hsqldb
	dev-java/ant-junit
	)

	
	dev-java/qdox
	
	"
	
	# For doc	
	
RDEPEND=">=virtual/jre-1.4
	${CDEPEND}"
	
DEPEND=">=virtual/jdk-1.4
	${CDEPEND}"

# needs to be keyworded
#	test? ( dev-java/jmock )

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	#sed -i 's/maxmemory="256m"/maxmemory="512m"/' "config/ant/build-setup.xml"
	
	mkdir -p target/lib && cd target/lib
	
	mkdir compile 
	mkdir runtime
	mkdir tools
	
	cd compile
	
	java-pkg_jar-from commons-cli-1
	java-pkg_jar-from ant-core
	java-pkg_jar-from antlr
	java-pkg_jar-from asm-2.2
	java-pkg_jar-from xstream
	java-pkg_jar-from mockobjects
	java-pkg_jar-from jline
	java-pkg_jar-from junit
	java-pkg_jar-from servletapi-2.4
	java-pkg_jar-from bsf-2.3
	
	# Following is for doc only
	
	java-pkg_jar-from qdox-1.6

	cd "${S}"

	#cp "${FILESDIR}/build-${PV}.xml" "${S}/build.xml" || die "Failed to update build.xml"
	# Should be a patch later
	cp "${FILESDIR}/build-ant.xml" "${S}/build.xml" || die "Failed to update build.xml"
	rm -rf bootstrap
	rm -rf security
}

src_compile() {
	ANT_TASKS="ant-antlr"
	
	eant -DskipTests -DruntimeLibDirectory="target/lib/compile" -DtoolsLibDirectory="target/lib/compile" createJars

	# This works
	
	#ANT_TASKS="none" eant -Dno.grammars -DruntimeLibDirectory="target/lib/compile" -DtoolsLibDirectory="target/lib/compile" doc
	#use doc && eant doc
}

src_test() {
	cd "${S}/target/lib" && mkdir test && cd compile
	
	# Following is for test only

	java-pkg_jar-from --build-only jmock-1.0
	java-pkg_jar-from --build-only xmlunit-1
	java-pkg_jar-from hsqldb
	#java-pkg_jar-from junit
	java-pkg_jar-from ant-junit
	#java-pkg_jar-from ant-core

	cd "${S}"
	ANT_TASKS="ant-junit ant-antlr ant-trax" eant test -DruntimeLibDirectory="target/lib/compile" -DtestLibDirectory="target/lib/compile"
}

src_install() {
	java-pkg_newjar "target/dist/${P}.jar"
	# java-pkg_dolauncher "grok" --main org.codehaus.groovy.tools.Grok Grok does not exist anymore
	java-pkg_dolauncher "groovyc" --main org.codehaus.groovy.tools.FileSystemCompiler
	java-pkg_dolauncher "groovy" --main groovy.ui.GroovyMain
	java-pkg_dolauncher "groovysh" --main groovy.ui.InteractiveShell
	java-pkg_dolauncher "groovyConsole" --main groovy.ui.Console
}
