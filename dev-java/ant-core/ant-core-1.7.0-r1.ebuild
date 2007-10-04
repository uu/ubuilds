# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-core/ant-core-1.7.0.ebuild,v 1.14 2007/05/12 17:43:18 wltjr Exp $

# don't depend on itself
JAVA_ANT_DISABLE_ANT_CORE_DEP=true
# rewriting build.xml files for the testcases has no reason atm
JAVA_PKG_BSFIX_ALL=no
inherit java-pkg-2 java-ant-2 osgi

MY_P="apache-ant-${PV}"

DESCRIPTION="Java-based build tool similar to 'make' that uses XML configuration files."
HOMEPAGE="http://ant.apache.org/"
SRC_URI="mirror://apache/ant/source/${MY_P}-src.tar.bz2
	mirror://gentoo/ant-${PV}-gentoo.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ia64 ppc ppc64 x86 ~x86-fbsd"
IUSE="doc source"

# 1.7.0 instead of $PV in blocks is intentional, >1.7.0 upgrades should
# be block free (but these fixed blocks should stay there for users upgrading
# from <1.7.0 of course)
RDEPEND=">=virtual/jdk-1.4
	!<dev-java/ant-tasks-1.7.0
	!<dev-java/ant-1.7.0
	!dev-java/ant-optional"
DEPEND="${RDEPEND}
	source? ( app-arch/zip )"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# remove bundled xerces
	rm -v lib/*.jar

	# use our split-ant build.xml
	mv -f ${WORKDIR}/build.xml .
}

src_compile() {
	export ANT_HOME=""

	local bsyscp

	# this ensures that when building ant with bootstrapped ant,
	# only the source is used for resolving references, and not
	# the classes in bootstrapped ant
	# but jikes in kaffe has issues with this...
	if ! java-pkg_current-vm-matches kaffe; then
		bsyscp="-Dbuild.sysclasspath=ignore"
	fi

	./build.sh ${bsyscp} jars-core $(use_doc javadocs) \
		|| die "build failed"
}

src_install() {
	newbin ${FILESDIR}/${PV}-ant ant || die "failed to install wrapper"

	dodir /usr/share/${PN}/bin
	for each in antRun runant.pl runant.py complete-ant-cmd.pl ; do
		dobin ${S}/src/script/${each}
		dosym /usr/bin/${each} /usr/share/${PN}/bin/${each}
	done

	echo "ANT_HOME=\"/usr/share/${PN}\"" > ${T}/20ant
	doenvd ${T}/20ant || die "failed to install env.d file"

	local export_header='images,org.apache.tools.ant,org.apache.tools.ant.dispatch,org.apache.tools.ant.filters,org.apache.tools.ant.filters.util,org.apache.tools.ant.helper,org.apache.tools.ant.input,org.apache.tools.ant.launch,org.apache.tools.ant.listener,org.apache.tools.ant.loader
 ,org.apache.tools.ant.taskdefs,org.apache.tools.ant.taskdefs.compiler
 s,org.apache.tools.ant.taskdefs.condition,org.apache.tools.ant.taskde
 fs.cvslib,org.apache.tools.ant.taskdefs.email,org.apache.tools.ant.ta
 skdefs.optional,org.apache.tools.ant.taskdefs.optional.ccm,org.apache
 .tools.ant.taskdefs.optional.clearcase,org.apache.tools.ant.taskdefs.
 optional.depend,org.apache.tools.ant.taskdefs.optional.depend.constan
 tpool,org.apache.tools.ant.taskdefs.optional.dotnet,org.apache.tools.
 ant.taskdefs.optional.ejb,org.apache.tools.ant.taskdefs.optional.exte
 nsion,org.apache.tools.ant.taskdefs.optional.extension.resolvers,org.
 apache.tools.ant.taskdefs.optional.i18n,org.apache.tools.ant.taskdefs
 .optional.image,org.apache.tools.ant.taskdefs.optional.j2ee,org.apach
 e.tools.ant.taskdefs.optional.javacc,org.apache.tools.ant.taskdefs.op
 tional.javah,org.apache.tools.ant.taskdefs.optional.jdepend,org.apach
 e.tools.ant.taskdefs.optional.jlink,org.apache.tools.ant.taskdefs.opt
 ional.jsp,org.apache.tools.ant.taskdefs.optional.jsp.compilers,org.ap
 ache.tools.ant.taskdefs.optional.junit,org.apache.tools.ant.taskdefs.
 optional.junit.xsl,org.apache.tools.ant.taskdefs.optional.native2asci
 i,org.apache.tools.ant.taskdefs.optional.net,org.apache.tools.ant.tas
 kdefs.optional.perforce,org.apache.tools.ant.taskdefs.optional.pvcs,o
 rg.apache.tools.ant.taskdefs.optional.scm,org.apache.tools.ant.taskde
 fs.optional.script,org.apache.tools.ant.taskdefs.optional.sos,org.apa
 che.tools.ant.taskdefs.optional.sound,org.apache.tools.ant.taskdefs.o
 ptional.splash,org.apache.tools.ant.taskdefs.optional.ssh,org.apache.
 tools.ant.taskdefs.optional.starteam,org.apache.tools.ant.taskdefs.op
 tional.unix,org.apache.tools.ant.taskdefs.optional.vss,org.apache.too
 ls.ant.taskdefs.optional.windows,org.apache.tools.ant.taskdefs.rmic,o
 rg.apache.tools.ant.types,org.apache.tools.ant.types.conditions,org.a
 pache.tools.ant.types.mappers,org.apache.tools.ant.types.optional,org
 .apache.tools.ant.types.optional.depend,org.apache.tools.ant.types.op
 tional.image,org.apache.tools.ant.types.resolver,org.apache.tools.ant
 .types.resources,org.apache.tools.ant.types.resources.comparators,org
 .apache.tools.ant.types.resources.selectors,org.apache.tools.ant.type
 s.selectors,org.apache.tools.ant.types.selectors.modifiedselector,org
 .apache.tools.ant.types.spi,org.apache.tools.ant.util,org.apache.tool
 s.ant.util.depend,org.apache.tools.ant.util.depend.bcel,org.apache.to
 ols.ant.util.facade,org.apache.tools.ant.util.java15,org.apache.tools
 .ant.util.optional,org.apache.tools.ant.util.regexp,org.apache.tools.
 bzip2,org.apache.tools.mail,org.apache.tools.tar,org.apache.tools.zip'

	java-pkg_doosgijar build/lib/ant.jar "org.apache.ant" "${export_header}" "Apache Ant" "Gentoo"

	#java-pkg_dojar build/lib/ant.jar
	java-pkg_dojar build/lib/ant-bootstrap.jar
	java-pkg_dojar build/lib/ant-launcher.jar

	use source && java-pkg_dosrc src/main/*

	dodoc README WHATSNEW KEYS

	if use doc; then
		dohtml welcome.html
		dohtml -r docs/*
		java-pkg_dojavadoc build/javadocs
	fi
}

pkg_postinst() {
	elog "The way of packaging ant in Gentoo has changed significantly since"
	elog "the 1.7.0 version, For more information, please see:"
	elog "http://www.gentoo.org/proj/en/java/ant-guide.xml"
}
