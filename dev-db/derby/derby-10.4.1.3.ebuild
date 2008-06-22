# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

# This package handles source/target itself.
JAVA_PKG_BSFIX="off"
JAVA_PKG_IUSE="source"
WANT_ANT_TASKS="ant-nodeps ant-junit"
inherit java-pkg-2 java-ant-2

MY_PN="db-derby"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Relational database implemented entirely in Java"
HOMEPAGE="http://db.apache.org/derby"
SRC_URI="mirror://apache/db/${PN}/${MY_P}/${MY_P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="java5 jdbc4 test"

CDEPEND="dev-java/xerces:2
	dev-java/xalan
	dev-java/xalan-serializer
	!java5? ( =virtual/jre-1.4* )"

DEPEND="${CDEPEND}
	=virtual/jdk-1.5*
	jdbc4? ( >=virtual/jdk-1.6 )
	>=dev-java/javatoolkit-0.3.0
	test? ( dev-java/jakarta-oro:2.0 )
	dev-java/javacc"

RDEPEND="${CDEPEND}
	=virtual/jre-1.5*
	jdbc4? ( >=virtual/jre-1.6 )"

# Even though JDBC4 requires 1.6, we still need to build the rest with 1.5.
JAVA_PKG_NV_DEPEND="=virtual/jdk-1.5*"

EANT_GENTOO_CLASSPATH="xalan xalan-serializer xerces-2"
S="${WORKDIR}/${MY_P}-src"

src_unpack(){
	unpack ${A}
	cd "${S}"

	# There are many build.xml files we need to rewrite.
	find -name "build.xml" -exec /usr/$(get_libdir)/javatoolkit/bin/xml-rewrite-3.py -f "{}" -g \;

	rm -vf tools/java/*.jar || die
	java-pkg_jar-from --into tools/java --build-only javacc javacc.jar

	# Attempts to override the compiler seem to be ignored.
	java-pkg_force-compiler javac

	# Clean generated sources so that javacc is actually used.
	eant clobber
}

src_compile() {
	# 1.5 is already forced so no need to specify it here.
	local antflags="-Dsane=false -Djava15compile.classpath=\"`java-config -r`\""

	# Only 1.6 works here.
	if use jdbc4 ; then
		local jdk6=`depend-java-query -v ">=virtual/jdk-1.6"`
		antflags="${antflags} -Djdk16=\"`java-config --select-vm=${jdk6} -O`\""
	fi

	# 1.6 can't be substituted for 1.4 but 1.5 can.
	if use java5 ; then
		local jre4=`java-config -f`
	else
		local jre4=`depend-java-query -v "=virtual/jre-1.4*"`
	fi

	antflags="${antflags} -Djava14compile.classpath=\"`java-config --select-vm=${jre4} -r`\""
	eant ${antflags} buildsource buildjars
}

src_test() {
	EANT_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH} jakarta-oro-2.0" eant testing
}

src_install() {
	# Most classes are targeted at 1.4 but some aren't.
	if use jdbc4 ; then
		JAVA_PKG_WANT_TARGET="1.6"
	else
		JAVA_PKG_WANT_TARGET="1.5"
	fi

	java-pkg_dojar jars/insane/*.jar
	dodoc README STATUS || die
	dohtml *.html || die
	use source && java-pkg_dosrc java/{client,engine,shared,tools}/org
}
