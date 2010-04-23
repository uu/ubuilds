# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 eutils java-ant-2


HOMEPAGE="http://publicobject.com/glazedlists/"
SRC_DOCUMENT_ID_JAVA5="1073/38679"
SRC_URI="https://${PN}.dev.java.net/files/documents/${SRC_DOCUMENT_ID_JAVA5}/${P}-source_java15.zip"
LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# TODO: there are some more extensions which have deps not in the portage tree, which ant-target names are:
# japex, ktable
IUSE="jfreechart jgoodiesforms nachocalendar swingx swt"

DEPEND_COMMON="
	jgoodiesforms? ( dev-java/jgoodies-forms )
	nachocalendar? ( dev-java/nachocalendar )
	swingx? ( dev-java/swingx )
	jfreechart? ( =dev-java/jfreechart-1* )
	swt? (
		=dev-java/swt-3*
		=dev-java/eclipse-core-commands-3.3*
		=dev-java/eclipse-jface-3.3*
	)"

RDEPEND=">=virtual/jre-1.5
	${DEPEND_COMMON}"
DEPEND=">=virtual/jdk-1.5
	test? ( dev-java/ant-junit )
	app-arch/unzip
	${DEPEND_COMMON}"

S="${WORKDIR}"

# tests seem to be buggy
RESTRICT="test"

# build file already has correct target version
JAVA_PKG_BSFIX="off"

link_system_jars() {
	einfo "Linking system jars for ${1}"
	local dir="extensions/${1}/lib"
	shift
	mkdir -p ${dir}
	for package in $@; do
		java-pkg_jar-from --into ${dir} ${package}
	done
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# disable autodownloading of dependencies
	# sort out test targets
	epatch "${FILESDIR}/${P}-build.xml.patch"

	# link system jars for extensions
	use jgoodiesforms && link_system_jars jgoodiesforms jgoodies-forms
	use nachocalendar && link_system_jars nachocalendar nachocalendar
	if use swingx; then
		link_system_jars swinglabs swingx
		# this test file needs issuebrowser classes which depend on other extensions we don't necessarily compile
		# (doesn't exist in java14 version, so we silence stderr)
		rm extensions/swinglabs/source/ca/odell/glazedlists/swing/JXTableTest.java &>/dev/null
	fi
	use jfreechart && link_system_jars jfreechart jfreechart-1.0
	use swt && link_system_jars swt swt-3 eclipse-core-commands-3.3 eclipse-jface-3.3

	if use test; then
		# figure out which junit slot to use
		local junit_slot=''
		has_version '>=dev-java/junit-4*' && junit_slot='-4'
		java-pkg_jar-from --build-only --into extensions junit${junit_slot} junit.jar
		# this test doesn't compile if jgoodiesforms isn't in USE
		use jgoodiesforms || rm test/ca/odell/glazedlists/swing/JEventListPanelTest.java
	fi
}

src_compile() {
	EANT_DOC_TARGET="docs"
	# we had to patch the build.xml so jar wouldn't depend on all those optional extension targets,
	# so now we have to collect them and call them individually
	EANT_BUILD_TARGET="jar"
	use swingx && EANT_BUILD_TARGET="swinglabs ${EANT_BUILD_TARGET}"
	for target in nachocalendar jgoodiesforms jfreechart swt
	do
		use ${target} && EANT_BUILD_TARGET="${target} ${EANT_BUILD_TARGET}"
	done
	java-pkg-2_src_compile
}

src_test() {
	ANT_TASKS="ant-junit" eant test
}

src_install() {
	java-pkg_newjar "target/${PN}_java15.jar"
	if use doc; then
		dohtml readme.html || die
		java-pkg_dojavadoc "target/docs/api"
	fi
	if use source; then
		# collect source folders for all the used extensions
		local source_folders="source/ca extensions/treetable/source/*"

		use swingx && source_folders="${source_folders} extensions/swinglabs/source/*"
		for extension in nachocalendar jgoodiesforms jfreechart swt
		do
			use ${extension} && source_folders="${source_folders} extensions/${extension}/source/*"
		done

		java-pkg_dosrc ${source_folders}
	fi
}