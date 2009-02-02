# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# TODO:
# Translation licenses
# Support for installing recitations globally (maybe)

EAPI=1
JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="An open platform for simply browsing and research on the Holy Quran"
HOMEPAGE="http://zekr.org/"
TRANS="mirror://sourceforge/${PN}/${PN}-quran-translation"
SRC_URI="mirror://sourceforge/${PN}/${P/_/}-linux.tar.gz
	linguas_az? ( ${TRANS}-az-mammadaliyevbunyadov_0.7.3-1_all.deb )
	linguas_bs? ( ${TRANS}-bs-korkut_0.7.3-1_all.deb )
	linguas_de?
	(
		${TRANS}-de-bubenheimelyas_0.7.3-1_all.deb
		${TRANS}-de-muhammadibnrassoul_0.7.3-1_all.deb
		${TRANS}-de-zaidan_0.7.3-1_all.deb
	)
	linguas_en?
	(
		${TRANS}-en-arberry_0.7.3-1_all.deb
		${TRANS}-en-pickthall_0.7.3-1_all.deb
		${TRANS}-en-qaribullah_0.7.3-1_all.deb
		${TRANS}-en-shakir_0.7.3-1_all.deb
		${TRANS}-en-yusufali_0.7.3-1_all.deb
	)
	linguas_es? ( ${TRANS}-es-cortes_0.7.3-1_all.deb )
	linguas_fa?
	(
		${TRANS}-fa-ansarian_0.7.3-1_all.deb
		${TRANS}-fa-ghomshei_0.7.3-1_all.deb
		${TRANS}-fa-makarem_0.7.3-1_all.deb
	)
	linguas_fr? ( ${TRANS}-fr-hamidullah_0.7.3-1_all.deb )
	linguas_id? ( ${TRANS}-id-indonesian_0.7.3-1_all.deb )
	linguas_it? ( ${TRANS}-it-piccardo_0.7.3-1_all.deb )
	linguas_nl? ( ${TRANS}-nl-keyzer_0.7.3-1_all.deb )
	linguas_pt? ( ${TRANS}-pt-elhayek_0.7.3-1_all.deb )
	linguas_ru?
	(
		${TRANS}-ru-kuliev_0.7.3-1_all.deb
		${TRANS}-ru-osmanov_0.7.3-1_all.deb
		${TRANS}-ru-porokhova_0.7.3-1_all.deb
	)
	linguas_tr?
	(
		${TRANS}-tr-diyanet_0.7.3-1_all.deb
		${TRANS}-tr-ozturk_0.7.3-1_all.deb
	)
	linguas_tt? ( ${TRANS}-tt-noghmani_0.7.3-1_all.deb )
	linguas_ur?
	(
		${TRANS}-ur-irfanulquran_0.7.3-1_all.deb
		${TRANS}-ur-jalandhry_0.7.3-1_all.deb
		${TRANS}-ur-kanzuliman_0.7.3-1_all.deb
	)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""
LINGUAS="az bs de en es fa fr id it nl pt ru tr tt ur"

COMMON_DEPS="dev-java/commons-collections:0
	 dev-java/commons-configuration:0
	 dev-java/commons-io:1
	 dev-java/commons-lang:2.1
	 dev-java/commons-logging:0
	 dev-java/log4j:0
	 >=dev-java/swt-3.4_pre6-r1:3.4
	 dev-java/velocity:0
	 dev-java/lucene:2.3
	 dev-java/lucene-highlighter:2.3
	 dev-java/lucene-snowball:2.3
	 dev-java/commons-codec"

RDEPEND=">=virtual/jre-1.4
	 ${COMMON_DEPS}"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	app-arch/deb2targz
	${COMMON_DEPS}"

S=${WORKDIR}/${PN}

pkg_setup() {
	if ! built_with_use --missing true -o dev-java/swt firefox seamonkey xulrunner ; then
		eerror "Re-emerge swt with the 'firefox', 'seamonkey' or 'xulrunner' USE flag"
		die
	fi
	java-pkg-2_pkg_setup
}

unpack_translation() {
	if [[ $1 = *".deb" ]]; then
		deb2targz "${DISTDIR}"/$1 || die
		tar -zxf  "${DISTDIR}"/${1/.deb/.tar.gz} ./usr/share/zekr -C "${S}" || die
		rm  "${DISTDIR}"/${1/.deb/.tar.gz} || die
	fi
}

src_unpack() {
	unpack ${P/_/}-linux.tar.gz
	cd "${S}" || die
	rm res/text/trans/yusufali.trans.zip || die #this comes from English deb file also
	for i in ${A}; do
		unpack_translation $i
	done
	rm lib/*.jar || die
	rm dist/zekr.jar || die
	java-ant_rewrite-classpath
}

src_compile() {
	local classpath=$(java-pkg_getjars commons-collections,commons-configuration,commons-io:1,commons-lang:2.1,commons-logging,log4j,swt:3.4,velocity,lucene-highlighter:2.3,lucene-snowball:2.3,commons-codec)
	classpath="${classpath}:$(java-pkg_getjar lucene:2.3 lucene-core.jar)"
	eant -Dgentoo.classpath=${classpath} dist $(use_doc)
}

src_install() {
	java-pkg_dojar dist/zekr.jar
	doicon "${FILESDIR}"/zekr.png
	local use_flag=""
	java-pkg_dolauncher zekr \
		--main net.sf.zekr.ZekrMain \
		--pwd /usr/share/zekr
	make_desktop_entry zekr "Zekr" zekr.png
	insinto /usr/share/zekr
	doins -r res
	doins -r usr/share/zekr/res
	use doc && java-pkg_dojavadoc build/docs/javadocs
	use source && java-pkg_dosrc src/*
}

pkg_postinst() {
	ewarn "You need to install a flash plugin to use recitations"
	#Introdcude a flag?
}
