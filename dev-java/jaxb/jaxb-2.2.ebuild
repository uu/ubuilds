# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

JAVA_PKG_IUSE="doc source"
WANT_ANT_TASKS="ant-contrib ant-junit ant-trax app-text/jing:0"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Reference implementation of the JAXB specification."
HOMEPAGE="http://jaxb.dev.java.net/"
SRC_URI="https://jaxb.dev.java.net/${PV}/jaxb-ri-${PV//./_}.src.zip"

LICENSE="|| ( CDDL GPL-2-sun-classpath-exception )"
SLOT="2"
KEYWORDS="~amd64 ~x86 ~ppc ~x86-fbsd"
IUSE=""

COMMON_DEP="dev-java/iso-relax
	java-virtuals/stax-api
	java-virtuals/jaf"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	>=dev-java/jaxb-1.0.6-r1:1
	dev-java/codemodel:2
	dev-java/sun-dtdparser
	dev-java/istack-commons-tools:1.1
	dev-java/istack-commons-runtime:1.1
	dev-java/relaxng-datatype
	dev-java/rngom
	dev-java/txw2-runtime
	dev-java/iso-relax
	dev-java/msv
	dev-java/relaxng-datatype
	dev-java/xsdlib
	dev-java/args4j:1
	dev-java/codemodel-annotation-compiler:2
	dev-java/fastinfoset
	dev-java/apt-mirror
	dev-java/relaxngcc
	dev-java/stax-ex
	dev-java/txw2-compiler
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.5
	!<dev-java/jaxb-tools-2.1.9
	${COMMON_DEP}"

S="${WORKDIR}/jaxb-ri"

src_unpack() {
	unpack ${A}
	jaxb_unpack_subpkg jaxb-api tools/lib/redist/jaxb-api-src.zip
	jaxb_unpack_subpkg resolver tools/lib/src/resolver-src.zip
	jaxb_unpack_subpkg xsom tools/lib/src/xsom-src.zip
}

java_prepare() {
	epatch "${FILESDIR}"/2.1.12-xjc-uses-jam.patch

	einfo "replacing shipped dependencies with installed ones."
	find . -name \*.jar -print0 | xargs -0 rm

	cd "${S}/tools/compiler10" || die
	java-pkg_jarfrom --build-only jaxb-1 jaxb-xjc.jar jaxb1-xjc.jar

	cd "${S}/tools/lib/rebundle/compiler" || die
	java-pkg_jarfrom --build-only codemodel-2 codemodel.jar
	java-pkg_jarfrom --build-only sun-dtdparser sun-dtdparser.jar dtd-parser-1.0.jar
	java-pkg_jarfrom --build-only istack-commons-tools-1.1 istack-commons-tools.jar
	java-pkg_jarfrom --build-only relaxng-datatype relaxngDatatype.jar
	#rm resolver.jar # recompiled from source later on
	java-pkg_jarfrom --build-only rngom rngom.jar
	#rm xsom.jar # recompiled from source later on

	cd "${S}/tools/lib/rebundle/runtime2" || die
	java-pkg_jarfrom --build-only istack-commons-runtime-1.1 istack-commons-runtime.jar
	java-pkg_jarfrom --build-only txw2-runtime txw2-runtime.jar txw2.jar

	cd "${S}/tools/lib/rebundle/runtime" || die
	java-pkg_jarfrom --build-only iso-relax isorelax.jar
	java-pkg_jarfrom --build-only msv msv.jar
	java-pkg_jarfrom --build-only relaxng-datatype relaxngDatatype.jar
	java-pkg_jarfrom --build-only xsdlib xsdlib.jar

	cd "${S}/tools/lib/redist" || die
	java-pkg_jarfrom --virtual jaf # activation.jar
	#rm jaxb-api.jar # recompiled from source later on
	java-pkg_jarfrom --virtual stax-api # jsr173_1.0_api.jar

	cd "${S}/tools/lib/util" || die
	#rm ant-*.jar bnd-0.0.249.jar dom4j.jar installer.jar pretty-printer.jar
	#rm istack-commons-test.jar jing-rnc-driver.jar package-rename-task.jar
	#rm maven-repository-importer.jar sfx4j-1.0.jar sjsxp.jar xercesImpl.jar
	java-pkg_jarfrom --build-only ant-core ant.jar
	java-pkg_jarfrom --build-only args4j-1 args4j.jar args4j-1.0-RC.jar
	java-pkg_jarfrom --build-only codemodel-annotation-compiler-2 codemodel-annotation-compiler.jar
	java-pkg_jarfrom --build-only fastinfoset fastinfoset.jar FastInfoset.jar
	java-pkg_jarfrom --build-only apt-mirror apt-mirror.jar jam.jar
	java-pkg_jarfrom --build-only jing jing.jar
	java-pkg_jarfrom --build-only relaxngcc relaxngcc.jar
	java-pkg_jarfrom --build-only stax-ex stax-ex.jar
	java-pkg_jarfrom --build-only txw2-compiler txwc2.jar
}

jaxb_unpack_subpkg() {
	local subdir="$1" archive="$2"
	shift 2
	mkdir "${WORKDIR}/${subdir}"{,/src,/classes} || die
	cd "${WORKDIR}/${subdir}/src" || die
	echo "Unpacking ${archive} to ${PWD}"
	unzip -qq "${S}/${archive}" || die "Error unzipping ${archive}"
	cd "${S}" || die
}

jaxb_compile_subpkg() {
	local subdir="$1" jar="$2" deps="$3" file
	shift 2
	einfo "Compiling ${subdir}"
	cd "${WORKDIR}/${subdir}" || die
	local classpath="${deps:+$(java-pkg_getjars ${deps})}"
	ejavac ${classpath:+-classpath "${classpath}"} \
		 -encoding UTF-8 -d classes $(find src -name \*.java)
	echo "${subdir} recompiled from source"
	for file in $(find src -name \*.properties); do
		mkdir -p classes/$(dirname ${file#src/}) || die
		cp ${file} classes/${file#src/} || die
	done
	jar cf "${S}/${jar}" -C classes . || die "jar failed"
	echo "${subdir} packaged"
	cd "${S}" || die
}

src_compile() {
	jaxb_compile_subpkg jaxb-api tools/lib/redist/jaxb-api.jar jaf,stax-api
	jaxb_compile_subpkg resolver tools/lib/rebundle/compiler/resolver.jar
	jaxb_compile_subpkg xsom tools/lib/rebundle/compiler/xsom.jar "--build-only relaxng-datatype"

	einfo "Compiling jaxb dist"
	mkdir -p tools/installer{,-builder}/build/classes
	export ANT_OPTS=-Xbootclasspath/p:${S}/tools/lib/redist/jaxb-api.jar
	eant dist $(use_doc javadoc)
}

src_install() {

	cd dist/lib || die
	java-pkg_dojar jaxb-api.jar || die
	java-pkg_dojar jaxb-impl.jar || die
	java-pkg_dojar jaxb-xjc.jar || die
	java-pkg_dolauncher "xjc-${SLOT}" --jar jaxb-xjc.jar \
		--main com.sun.tools.xjc.Driver
	java-pkg_dolauncher "schemagen-${SLOT}" --jar jaxb-xjc.jar \
		--main com.sun.tools.jxc.SchemaGeneratorFacade

	cd "${S}" || die
	use doc && java-pkg_dojavadoc dist/javadoc
	use source && java-pkg_dosrc runtime/src/* xjc/src/*

}
