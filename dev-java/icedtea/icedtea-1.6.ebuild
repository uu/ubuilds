# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sun-jdk/sun-jdk-1.5.0.05.ebuild,v 1.2 2005/10/10 16:23:12 betelgeuse Exp $

inherit pax-utils eutils java-pkg-2 java-vm-2 mercurial autotools

DESCRIPTION="Open Source JDK"
HOMEPAGE="https://openjdk.dev.java.net/"
SRC_URI="http://icedtea.classpath.org/download/source/${P}.tar.gz"

SLOT="1.7"
# Needs other for Apache asm etc see THIRD_PARTY_README
LICENSE="GPL-2-with-linking-exception sun-prerelease-jdk7"
KEYWORDS="~amd64 ~x86"
IUSE="nsplugin xulrunner"

COMMON_DEP="
	dev-java/xalan
	media-libs/alsa-lib
	media-libs/libpng
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXtst
	nsplugin? ( net-libs/xulrunner )"

# Found by included libs but not built by default I think:
#	dev-libs/elfutils
# Bundled (should make it to use system copy):
#   media-libs/jpeg

DEPEND="
	app-arch/unzip
	app-arch/zip
	virtual/motif
	>=dev-java/sun-jdk-1.6
	dev-java/eclipse-ecj
	dev-java/ant-core
	x11-libs/libXmu
	x11-libs/libXrandr
	x11-libs/libXt
	x11-proto/inputproto
	x11-proto/xextproto
	x11-proto/xproto
	x11-proto/xineramaproto
	net-print/cups
	>=dev-java/eclipse-ecj-3.3
	>sys-devel/gcc-4.2
	xulrunner? ( net-libs/xulrunner )
	${COMMON_DEP}"

RDEPEND="${COMMON_DEP}
	dev-libs/nspr"


JAVA_PROVIDE="jdbc-stdext jdbc-rowset"

pkg_setup() {
	if ! built_with_use sys-devel/gcc gcj; then
		eerror "You need to build sys-devel/gcc with USE=gcj enabled."
		die "gcc w/o gcj-support detected."
	else
		einfo "gcc compiled with gcj-support =)"
	fi
	
	if [[ `hg -v help fclones 2>&1> /dev/null` ]]; then
		eerror "You need to have the ForsetExtension for mercurial."
		die "mercurial w/o fclone support."
	else
		einfo "mercurial fclone found =)"
	fi

	java-vm-2_pkg_setup
	java-pkg-2_pkg_setup
}

src_unpack() {
	unpack ${A}
	cd ${S}

	EHG_CLONE_CMD="hg fclone -r jdk7-b24"
	EHG_REPO_URI="http://hg.openjdk.java.net/jdk7/jdk7"
	mercurial_src_unpack

	mv ${WORKDIR}/jdk7 ${S}/openjdk	
	
	epatch "${FILESDIR}/icedtea-libjpeg-fix.patch"

	if use xulrunner ; then
		epatch "${FILESDIR}/icedtea-1.6-xulrunner.patch"
	fi

	eautoreconf || die 'eautoreconf failed'
}

src_compile() {

# Needs some work
	local GCCV=$(gcc -v 2>&1 | tail -1 | awk '{print $3}')
	local JDK="$(java-config -O)"
	local GCJ="/usr/$CHOST/gcc-bin"
	local GCJJAR="/usr/share/gcc-data/$CHOST/$GCCV/java/libgcj-$GCCV.jar"

	einfo "JDK: ${JDK}"

	unset CFLAGS CXXFLAGS

	unset JAVA_HOME CLASSPATH LD_LIBRARY_PATH

	econf \
			--with-gcj-home=${GCJ}	\
			--with-libgcj-jar=${GCJJAR} \
			--with-javac \
			--with-icedtea --with-icedtea-home=${JDK} \
			--with-openjdk-src-dir=${S}/openjdk	\
			--enable-netx-plugin || die 'econf failed'

	make HOTSPOT_BUILD_JOBS=1 COMPILER_WARNINGS_FATAL=false MILESTONE=experimental-icedtea BUILD_NUMBER=gentoo-${P} || die 'make failed'
}

src_install() {
	local dest=/opt/${P}
	local ddest="${D}/${dest}"
	dodir ${dest}

	local arch=i586
	[[ ${ARCH} = amd64 ]] && arch=amd64

	cd ${S}/openjdk/build/linux-${arch}/

	if use doc; then
		dohtml -r docs/* || die
	fi

	cd j2sdk-image

	# For some people the files got 600 so doing it manually
	# should be investigated why this happened
	if is-java-strict; then
		if [[ $(find . -perm 600) ]]; then
			eerror "OpenJDK built with permission mask 600"
			eerror "report this on #gentoo-java on freenode"
		fi
	fi

	# doins can't handle symlinks
	cp -vRP bin include jre lib man "${ddest}" || die "failed to copy"
	find "${ddest}" -type f -exec chmod 644 {} +
	find "${ddest}" -type d -exec chmod 755 {} +
	chmod 755 ${ddest}/bin/* \
		${ddest}/jre/bin/* \
		${ddest}/jre/lib/*/*.{so,cfg} \
		${ddest}/jre/lib/*/*/*.so \
		${ddest}/jre/lib/jexec \
		${ddest}/lib/jexec || die

	if [[ $(find "${ddest}" -perm 600) ]]; then
		eerror "Files with permission set to 600 found in the image"
		eerror "please report this to java@gentoo.org"
	fi

	pax-mark m $(list-paxables ${ddest}{,/jre}/bin/*)

	dodoc LICENSE ASSEMBLY_EXCEPTION THIRD_PARTY_README || die
	dohtml README.html || die

	if use examples; then
		cp -pPR demo sample "${ddest}/share/"
	fi

	cp src.zip "${ddest}" || die

	if use nsplugin; then
		local plugin_dir="ns7-gcc29"
		if has_version '>=sys-devel/gcc-3' ; then
			plugin_dir="ns7"
		fi
		install_mozilla_plugin /opt/${P}/jre/lib/${arch}/gcjwebplugin.so
	fi

	# create dir for system preferences
	dodir /opt/${P}/jre/.systemPrefs
	# Create files used as storage for system preferences.
	touch ${D}/opt/${P}/jre/.systemPrefs/.system.lock
	chmod 644 ${D}/opt/${P}/jre/.systemPrefs/.system.lock
	touch ${D}/opt/${P}/jre/.systemPrefs/.systemRootModFile
	chmod 644 ${D}/opt/${P}/jre/.systemPrefs/.systemRootModFile

	set_java_env
}

pkg_postinst() {
	# Set as default VM if none exists
	java-vm-2_pkg_postinst
}
