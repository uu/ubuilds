# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="An open platform for simply browsing and research on the Holy Quran"
HOMEPAGE="http://zekr.org/"
#SRC_URI="mirror://sourceforge/${PN}/${P/_/}-linux.tar.gz
#	linguas_bs? ( mirror://sourceforge/${PN}/zekr-quran-translations-bs_7.2.dfsg-1_all.deb )
#	linguas_en? ( mirror://sourceforge/${PN}/zekr-quran-translations-en_7.1.dfsg-1_all.deb )
#	linguas_fa? ( mirror://sourceforge/${PN}/zekr-quran-translations-fa_7.2.dfsg-1_all.deb )
#	linguas_fr? ( mirror://sourceforge/${PN}/zekr-quran-translations-fr_7.1.dfsg-1_all.deb )
#	linguas_id? ( mirror://sourceforge/${PN}/zekr-quran-translations-id_7.2.dfsg-1_all.deb )
#	linguas_nl? ( mirror://sourceforge/${PN}/zekr-quran-translations-nl_7.1.dfsg-1_all.deb )
#	linguas_pt? ( mirror://sourceforge/${PN}/zekr-quran-translations-pt_7.2.dfsg-1_all.deb )
#	linguas_ru? ( mirror://sourceforge/${PN}/zekr-quran-translations-ru_8.0.dfsg-1_all.deb )
#	linguas_tr? ( mirror://sourceforge/${PN}/zekr-quran-translations-tr_7.2.dfsg-1_all.deb )
#	linguas_ur? ( mirror://sourceforge/${PN}/zekr-quran-translations-ur_7.1.dfsg-1_all.deb )"
# These translation files don't work with 0.7.0
# May be updated to files in http://zekr.org/download/trans/
SRC_URI="mirror://sourceforge/${PN}/${P/_/}-linux.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
#LINGUAS="bs en fa fr id nl pt ru tr ur"

COMMON_DEPS="dev-java/commons-collections:0
	 dev-java/commons-configuration:0
	 dev-java/commons-io:1
	 dev-java/commons-lang:2.1
	 dev-java/commons-logging:0
	 dev-java/log4j:0
	 >=dev-java/swt-3.4_pre6
	 dev-java/velocity:0
	 dev-java/lucene:2.3
	 dev-java/lucene-highlighter:2.3"

RDEPEND=">=virtual/jre-1.4
	 ${COMMON_DEPS}"

#DEPEND=">=virtual/jdk-1.4
#	app-arch/unzip
#	app-arch/deb2targz
#	${COMMON_DEPS}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
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
	#rm res/text/trans/shakir.trans.zip || die #this comes from English deb file also
	# commented out yo have at least one valid translation
	#for i in ${A}; do
	#	unpack_translation $i
	#done
	rm lib/*.jar || die
	rm dist/zekr.jar || die
	epatch ${FILESDIR}/${P}-buildfix.patch
	epatch ${FILESDIR}/${PN}-0.6.6-resource-fixes.patch
	java-ant_rewrite-classpath
}

src_compile() {
	local classpath=$(java-pkg_getjars commons-collections,commons-configuration,commons-io:1,commons-lang:2.1,commons-logging,log4j,swt:3,velocity,lucene-highlighter:2.3)
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
        # doins -r usr/share/zekr/res
        # See the comment above SRC_URI
        use doc && java-pkg_dojavadoc build/docs/javadocs
        use source && java-pkg_dosrc src/*
}
