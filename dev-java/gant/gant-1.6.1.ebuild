# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

JAVA_PKG_IUSE="source"

inherit bash-completion java-pkg-2 java-ant-2

DESCRIPTION="a tool for scripting Ant tasks using Groovy instead of XML."
HOMEPAGE="http://gant.codehaus.org/"
SRC_URI="http://dist.codehaus.org/${PN}/distributions/${PN}_src-${PV}.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

COMMON_DEP="dev-java/ant-core:0
		dev-java/groovy:0"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.5
	dev-java/junit:0
	dev-java/ant-junit:0
	dev-java/asm:2.2
	dev-java/commons-cli:1
	dev-java/antlr:0
	${COMMON_DEP}"

#requires maven-ant-tasks.jar
RESTRICT="test"

java_prepare() {
	epatch "${FILESDIR}/${P}-build.xml.patch"

	find . -iname '*.jar' -delete

	mkdir -p lib
	_jar-from --build-only asm-2.2 asm.jar
	_jar-from --build-only asm-2.2 asm-tree.jar
	_jar-from ant-core ant.jar
	_jar-from --build-only commons-cli-1 commons-cli.jar
	_jar-from --build-only antlr antlr.jar
	_jar-from --build-only junit junit.jar
}

src_compile() {
	_eant package -DskipTests=true
}

src_test() {
	_eant test -Djava.awt.headless=true
}

src_install() {
	java-pkg_register-dependency groovy

	java-pkg_newjar "target_${PN}/${P}.jar"
	java-pkg_dolauncher ${PN} --main gant.Gant \
		--extra_args "-Dant.home=\$ANT_HOME -Dgant.home=/usr/share/gant"

	doman documentation/gant.1
	dobashcompletion scripts/bash_completion.d/gant "${PN}"
	use source && java-pkg_dosrc src
}

pkg_postinst() {
	java-pkg-2_postinst
	bash-completion_pkg_postinst
}

_jar-from() {
	java-pkg_jar-from --into lib $@
}

_eant() {
	WANT_TASKS="groovy-1,ant-junit" GROOVY_HOME="/usr/share/groovy" \
		eant $@
}

