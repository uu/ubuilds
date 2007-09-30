# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

S=${WORKDIR}/${PN}
JAVA_PKG_IUSE="doc source"

inherit eutils font java-pkg-2 java-ant-2 java-utils-2

DESCRIPTION="An open platform for simply browsing and research on the Holy Quran"
HOMEPAGE="http://siahe.com/zekr/"
SRC_URI="mirror://sourceforge/${PN}/${P/_/}-linux.tar.gz
	linguas_bs? ( mirror://sourceforge/${PN}/zekr-quran-translations-bs_7.2.dfsg-1_all.deb )
	linguas_en? ( mirror://sourceforge/${PN}/zekr-quran-translations-en_7.1.dfsg-1_all.deb )
	linguas_fa? ( mirror://sourceforge/${PN}/zekr-quran-translations-fa_7.2.dfsg-1_all.deb )
	linguas_fr? ( mirror://sourceforge/${PN}/zekr-quran-translations-fr_7.1.dfsg-1_all.deb )
	linguas_id? ( mirror://sourceforge/${PN}/zekr-quran-translations-id_7.2.dfsg-1_all.deb )
	linguas_nl? ( mirror://sourceforge/${PN}/zekr-quran-translations-nl_7.1.dfsg-1_all.deb )
	linguas_pt? ( mirror://sourceforge/${PN}/zekr-quran-translations-pt_7.2.dfsg-1_all.deb )
	linguas_ru? ( mirror://sourceforge/${PN}/zekr-quran-translations-ru_8.0.dfsg-1_all.deb )
	linguas_tr? ( mirror://sourceforge/${PN}/zekr-quran-translations-tr_7.2.dfsg-1_all.deb )
	linguas_ur? ( mirror://sourceforge/${PN}/zekr-quran-translations-ur_7.1.dfsg-1_all.deb )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="linguas_bs linguas_en linguas_fa linguas_fr linguas_id linguas_nl linguas_pt linguas_ru linguas_tr linguas_ur"

COMMON_DEPS="dev-java/commons-collections
	 dev-java/commons-configuration
	 =dev-java/commons-io-1*
	 >=dev-java/commons-lang-2.1
	 dev-java/commons-logging
	 dev-java/log4j
	 >=dev-java/swt-3.3
	 dev-java/velocity
	 =dev-java/lucene-2*
	 =dev-java/lucene-highlighter-2*"

RDEPEND=">=virtual/jre-1.4
	 ${COMMON_DEPS}"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	app-arch/deb2targz
	${COMMON_DEPS}"

FONT_SUFFIX="ttf"

pkg_setup() {
	if ! built_with_use -o swt firefox seamonkey xulrunner ; then
		eerror "Re-emerge swt with the 'firefox', 'seamonkey' or 'xulrunner' USE flag"
		die
	fi
	java-pkg-2_pkg_setup
	font_pkg_setup
}

unpack_translation() {
	if [[ $1 = *".deb" ]]; then
		deb2targz ${DISTDIR}/$1 || die
		tar -zxf  ${DISTDIR}/${1/.deb/.tar.gz} ./usr/share/zekr -C ${S}
		rm  ${DISTDIR}/${1/.deb/.tar.gz} || die
	fi
}

src_unpack() {
	unpack ${P/_/}-linux.tar.gz
	cd "${S}" || die
	for i in ${A}; do
		unpack_translation $i
	done
	unzip -q dist/zekr-src.jar -d src || die
	rm lib/*.jar || die
	rm dist/*.jar || die
	rm res/text/trans/shakir.zip || die #this comes from English deb file also.
	mv res/*.ttf . || die
	epatch ${FILESDIR}/${P}-resource-fixes.patch
	epatch ${FILESDIR}/${P}-buildfix.patch
	java-ant_rewrite-classpath
}

src_compile() {
	local classpath=$(java-pkg_getjars commons-collections,commons-configuration,commons-io-1,commons-lang-2.1,commons-logging,log4j,swt-3,velocity,lucene-highlighter-2)
	classpath="${classpath}:$(java-pkg_getjar lucene-2 lucene-core.jar)"
	eant -Dgentoo.classpath=${classpath} dist $(use_doc)
}

src_install() {
	java-pkg_dojar build/zekr.jar
        doicon ${FILESDIR}/zekr.png
        local use_flag=""
        java-pkg_dolauncher zekr \
        	--main net.sf.zekr.ZekrMain \
        	--pwd /usr/share/zekr
        make_desktop_entry zekr "Zekr" zekr.png
        insinto /usr/share/zekr
        doins -r res
        doins -r usr/share/zekr/res
        font_src_install
        use doc && java-pkg_dojavadoc build/docs/javadocs
        use source && java-pkg_dosrc src/*
}
