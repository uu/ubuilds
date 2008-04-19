# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="An open platform for simply browsing and research on the Holy Quran"
HOMEPAGE="http://zekr.org/"
TRANS="mirror://sourceforge/${PN}/${PN}-quran-translation"
SRC_URI="mirror://sourceforge/${PN}/${P/_/}-linux.tar.gz
	linguas_bs? ( ${TRANS}-korkut-bs_0.7.1-1-ppa1_all.deb )
	linguas_de?
	(
		${TRANS}-bubenheimelyas-de_0.7.1-1-ppa1_all.deb
		${TRANS}-muhammadibnrassoul-de_0.7.1-1-ppa1_all.deb
		${TRANS}-zaidan-de_0.7.1-1-ppa1_all.deb
	)
	linguas_es? ( ${TRANS}-cortes-es_0.7.1-1-ppa1_all.deb )
	linguas_en?
	(
		${TRANS}-pickthall-en_0.7.1-1-ppa1_all.deb
		${TRANS}-qaribullah-en_0.7.1-1-ppa1_all.deb
		${TRANS}-shakir-en_0.7.1-1-ppa1_all.deb
		${TRANS}-yusufali-en_0.7.1-1-ppa1_all.deb
	)
	linguas_fa?
	(
		${TRANS}-ansarian-fa_0.7.1-1-ppa1_all.deb
		${TRANS}-ghomshei-fa_0.7.1-1-ppa1_all.deb
		${TRANS}-makarem-fa_0.7.1-1-ppa1_all.deb
	)
	linguas_fr? ( ${TRANS}-hamidullah-fr_0.7.1-1-ppa1_all.deb )
	linguas_id? ( ${TRANS}-indonesian-id_0.7.1-1-ppa1_all.deb )
	linguas_it? ( ${TRANS}-piccardo-it_0.7.1-1-ppa1_all.deb )
	linguas_nl? ( ${TRANS}-keyzer-nl_0.7.1-1-ppa1_all.deb )
	linguas_pt? ( ${TRANS}-elhayek-pt_0.7.1-1-ppa1_all.deb )
	linguas_ru?
	(
		${TRANS}-kuliev-ru_0.7.1-1-ppa1_all.deb
		${TRANS}-osmanov-ru_0.7.1-1-ppa1_all.deb
		${TRANS}-porokhova-ru_0.7.1-1-ppa1_all.deb
		
	)
	linguas_tr?
	(
		${TRANS}-diyanet-tr_0.7.1-1-ppa1_all.deb
		${TRANS}-ozturk-tr_0.7.1-1-ppa1_all.deb
	)
	linguas_tt? ( ${TRANS}-noghmani-tt_0.7.1-1-ppa1_all.deb )
	linguas_ur?
	(
		${TRANS}-irfanulquran-ur_0.7.1-1-ppa1_all.deb
		${TRANS}-jalandhry-ur_0.7.1-1-ppa1_all.deb
		${TRANS}-kanzuliman-ur_0.7.1-1-ppa1_all.deb
	)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
LINGUAS="bs de es en fa fr id it nl pt ru tr tt ur"

COMMON_DEPS="dev-java/commons-collections:0
	 dev-java/commons-configuration:0
	 dev-java/commons-io:1
	 dev-java/commons-lang:2.1
	 dev-java/commons-logging:0
	 dev-java/log4j:0
	 >=dev-java/swt-3.4_pre6-r1:3.4
	 dev-java/velocity:0
	 dev-java/lucene:2.3
	 dev-java/lucene-highlighter:2.3"

RDEPEND=">=virtual/jre-1.4
	 ${COMMON_DEPS}"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	app-arch/deb2targz
	${COMMON_DEPS}"

S=${WORKDIR}/${PN}

pkg_setup() {
	if ! built_with_use -o swt firefox seamonkey xulrunner ; then
		eerror "Re-emerge swt with the 'firefox', 'seamonkey' or 'xulrunner' USE flag"
		die
	fi
	java-pkg-2_pkg_setup
}

unpack_translation() {
	if [[ $1 = *".deb" ]]; then
		deb2targz ${DISTDIR}/$1 || die
		tar -zxf  ${DISTDIR}/${1/.deb/.tar.gz} ./usr/share/zekr -C ${S} || die
		rm  ${DISTDIR}/${1/.deb/.tar.gz} || die
	fi
}

src_unpack() {
	unpack ${P/_/}-linux.tar.gz
	cd "${S}" || die
	rm res/text/trans/shakir.trans.zip || die #this comes from English deb file also
	for i in ${A}; do
		unpack_translation $i
	done
	rm lib/*.jar || die
	rm dist/zekr.jar || die
	epatch ${FILESDIR}/${P}-buildfix.patch
	epatch ${FILESDIR}/${PN}-0.6.6-resource-fixes.patch
	java-ant_rewrite-classpath
}

src_compile() {
	local classpath=$(java-pkg_getjars commons-collections,commons-configuration,commons-io:1,commons-lang:2.1,commons-logging,log4j,swt:3.4,velocity,lucene-highlighter:2.3)
	classpath="${classpath}:$(java-pkg_getjar lucene:2.3 lucene-core.jar)"
	eant -Dgentoo.classpath=${classpath} dist $(use_doc)
}

src_install() {
	java-pkg_dojar dist/zekr.jar
        doicon ${FILESDIR}/zekr.png
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
