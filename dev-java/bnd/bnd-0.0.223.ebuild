# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"

JAVA_PKG_BSFIX="off" #we provide the build.xml.

inherit java-pkg-2 java-ant-2

DESCRIPTION="The bnd tool helps you create and diagnose OSGi R4 bundles."
HOMEPAGE="http://www.aqute.biz"
SRC_URI="http://www.aqute.biz/repo/biz/aQute/${PN}/${PV}/${P}.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

COMMON_DEP="=dev-util/eclipse-sdk-3.3*
			dev-java/swt
			dev-java/ant-core
			"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}"

S="${WORKDIR}"

EANT_BUILD_TARGET="jar"
EANT_DOC_TARGET="javadoc"

src_unpack() {
	unpack ${A}
	cd "${S}"
	cp "${FILESDIR}/build.xml" build.xml
	mkdir lib || die
	rm -R aQute

	local jars="org.eclipse.osgi.jar 
		org.eclipse.core.resources.jar 
		org.eclipse.jface.jar 
		org.eclipse.core.commands.jar 
		org.eclipse.ui.workbench.jar 
		org.eclipse.jdt.jar 
		org.eclipse.core.jobs.jar 
		org.eclipse.core.runtime.compatibility.jar 
		org.eclipse.core.runtime.jar 
		org.eclipse.equinox.common.jar 
		org.eclipse.equinox.registry.jar 
		org.eclipse.jdt.core.jar"

	for jar in ${jars}; do
		java-pkg_jar-from --into lib eclipse-sdk-3.3 \
			${jar}
	done

	java-pkg_jar-from --into lib ant-core ant.jar
	java-pkg_jar-from --into lib swt-3
}

src_install() {
	java-pkg_dojar "${PN}.jar"
	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc OSGI-OPT/src/*
	java-pkg_dolauncher
}

pkg_postinst() {
	elog "To use bnd within eclipse, please copy this packages jar"
	elog "to your ~/.eclipse/org.eclipse.platform*/configuration/eclipse/plugins"
	elog "directory."
}

