# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

JAVA_PKG_IUSE=""

inherit java-pkg-2 java-ant-2

DESCRIPTION="Gant is a build tool for scripting Ant tasks using Groovy instead of XML to specify the build logic"
SRC_URI="http://docs.codehaus.org/download/attachments/60375/gant_src-${PV}.tgz"

HOMEPAGE="http://groovy.codehaus.org/Gant"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"

CDEPEND=">=dev-java/groovy-1.0
	=dev-java/asm-2.2*
	dev-java/commons-cli
	dev-java/antlr"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.4"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.4
	>=dev-java/junit-3.8"

IUSE=""

src_unpack() {
	unpack "${A}"
	cd "${S}"

	epatch "${FILESDIR}/${P}-build.xml.patch"
	rm -rf lib/
	java-ant_rewrite-classpath
}

src_compile() {
	local gentoo_jars="$(java-pkg_getjars asm-2.2,groovy-1,antlr,commons-cli-1)"

	ANT_TASKS="none" eant package -Dgentoo.classpath=`java-pkg_getjars --build-only junit` "-Dgentoo.jars=${gentoo_jars//:/,}"
}

src_install() {
	java-pkg_newjar "target/${P}.jar"
	dodoc releaseNotes.txt || die
	java-pkg_dolauncher gant --main org.codehaus.groovy.tools.GroovyStarter --pkg_args "--main gant.Gant"
	
	#exeinto /usr/bin
	#doexe ${FILESDIR}/eclipse-${SLOT}
	#echo "CLASSPATH=`java-config -dp groovy-1,gant` java org.codehaus.groovy.tools.GroovyStarter --main gant.Gant" > {T}/usr/bin/gant
	#java-pkg_dolauncher --main gant.Gant --jar
}