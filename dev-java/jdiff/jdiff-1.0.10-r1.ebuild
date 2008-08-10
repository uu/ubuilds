# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils java-pkg-2 java-ant-2

# WARNING: this eebuild shoud NOT be added to main tree yet. The problem is that it requires
# com.sun.javadoc classes and we do not yet have a way to record this in package.env
# FIXME : Add java-virtual that provides this from gjdoc or possibly the
# built-in one that comes with the jdk and make a symlink package..

DESCRIPTION="JDiff is a Javadoc doclet which generates an HTML report of API differences."

SRC_URI="mirror://sourceforge/javadiff/${P}.tar.gz"
HOMEPAGE="http://www.jdiff.org/"

CDEPEND=">=dev-java/xerces-2.8
		dev-java/gjdoc"

DEPEND=">=virtual/jdk-1.4
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.4
	dev-java/ant-core
	${CDEPEND}"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~x86 ~amd64"
IUSE=""

S="${WORKDIR}/${PN}/"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm lib/*.jar
	# FIXME : Make a patch instead of this work-around to failing build
	mkdir "test/olddocs"
	mkdir "test/newdocs"
	mkdir "test/newdocs2"
	java-ant_rewrite-classpath build/build.xml
	java-ant_rewrite-classpath
}

EANT_GENTOO_CLASSPATH="xerces-2 ant-core gjdoc"
EANT_BUILD_TARGET="clean all"
EANT_EXTRA_ARGS="-Dbuild.compiler=modern"
JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_ANT_IGNORE_SYSTEM_CLASSES="true"

#src_compile() {
#	# Note that build fails if build.compiler="modern" is not specified
#
#	gentoo_jars="$(java-pkg_getjars xerces-2,ant-core)"
#	echo ${gentoo_jars}
#	eant -Dgentoo.classpath="${gentoo_jars}" -Dbuild.compiler="modern"
#}

src_install() {
	java-pkg_dojar "lib/${PN}.jar"
	java-pkg_dojar "lib/ant${PN}.jar"
	java-pkg_register-ant-task

	dodoc README.txt CHANGES.txt KNOWN_LIMITATIONS.txt || die
	dohtml "${PN}.html" stylesheet.css || die
}
