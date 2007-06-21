# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# this package handles source/target itself, and jdbc4 classes are 1.6 source
JAVA_PKG_BSFIX="off"
WANT_ANT_TASKS="ant-nodeps"
inherit java-pkg-2 java-ant-2

MY_PN="db-derby"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Relational database implemented entirely in Java"
HOMEPAGE="http://db.apache.org/derby/index.html"
SRC_URI="mirror://apache/db/${PN}/${MY_P}/${MY_P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 "
#IUSE="doc source examples"
IUSE="jdbc4 test"

COMMON_DEP="dev-java/xalan-serializer
	dev-java/xalan"

# compilation always uses 1.4/1.5
# 1.6 is used to point jdbc4 build classpath to its jars
# limited to sun because I can't tell java-config to give me path
# to generic 1.6 JDK
DEPEND="|| ( =virtual/jdk-1.5* =virtual/jdk-1.4* )
	jdbc4? ( =dev-java/sun-jdk-1.6* )
	dev-java/javacc
	test? (
		=dev-java/junit-3*
		=dev-java/jakarta-oro-2.0*
	)
	${COMMON_DEP}"

# probably just for tests	
#		>=dev-java/geronimo-specs-1.1
#		>=dev-java/jakarta-oro-2.0.8

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

S="${WORKDIR}/${MY_P}-src"

# some kiorky's madness, doesn't seem needed at all, maybe for tests?
#pkg_setup() {
#	die "Wants me; Finnish me !!!"
#	for i in jta servlet;do
#		if ! built_with_use dev-java/geronimo-specs $i;then
#			eerror "Please enable $i USE for dev-java/geronimo-specs and rebuild it"
#			die "missing USE for dev-java/geronimo-specs"
#		fi
#	done
#}

src_unpack(){
	unpack ${A}
	cd "${S}"

	# put xalan on classpath where needed, upstream probably relies on ant's cp?
	epatch "${FILESDIR}/build.patch"
	# make jdbc2 stuff abstract so it compiles with 1.4/1.5 JDK
	epatch "${FILESDIR}/jdbc2-abstract.patch"
	# implement abstract methods so it compiles with 1.4/1.5
	epatch "${FILESDIR}/vti.patch"

	cd "${S}/tools/java" || die
	rm -v *.jar || die
	java-pkg_jar-from --build-only javacc javacc.jar
	java-pkg_jar-from xalan-serializer serializer.jar
	java-pkg_jar-from xalan xalan.jar
	if use test; then
		java-pkg_jar-from --build-only junit,jakarta-oro-2.0
		java-pkg_jar-from --build-only jakarta-oro-2.0 jakarta-oro.jar \
			jakarta-oro-2.0.8.jar
	fi

	# probably test stuff...
#	java-pkg_jar-from geronimo-specs geronimo-spec-jta.jar geronimo-spec-jta-1.0.1B-rc4.jar
#	java-pkg_jar-from geronimo-specs geronimo-spec-servlet.jar geronimo-spec-servlet-2.4-rc4.jar

	cd "${S}"
	# ecj fails when 1.5 JDK is used because it can't handle extending
	# PrintWriter in 1.5 without -source 1.5... and jikes is just jikes
	java-pkg_force-compiler javac

	# clean generated sources so javacc is actually used
	eant clobber
}

src_compile() {
	local antflags="-Dj13lib=\"${JAVA_HOME}/jre/lib\" -Dj14lib=\"${JAVA_HOME}/jre/lib\""
	antflags="${antflags} -Djce1_2_1=\"${JAVA_HOME}/jre/lib/jce.jar\" -Dsane=false"
	use jdbc4 && antflags="${antflags} -Djdk16=\"$(java-config --select-vm=sun-jdk-1.6 --jdk-home)\""
	eant ${antflags} buildsource buildjars $(use_doc)
}

src_test() {
	# this just compiles tests, didn't investigate running them yet
	# currently fail
	eant testing
}

src_install() {
	# disable the class version verifier which breaks with USE=jdbc4
	# no point in declaring this as 1.6 package just for the jdbc4 classes
	JAVA_PKG_STRICT="" java-pkg_dojar jars/insane/*.jar
}
