# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sun-jdk/sun-jdk-1.5.0.05.ebuild,v 1.2 2005/10/10 16:23:12 betelgeuse Exp $

inherit pax-utils eutils java-pkg-2 java-vm-2

ALPHA=${PV#*_alpha}
DATE="21_jun_2007"

BASE_URL="http://www.java.net/download/${PN}/jdk7/promoted/b${ALPHA}/"
srcfile="${PN}-7-ea-src-b${ALPHA}-${DATE}.zip"
x86_plug="jdk-7-ea-plug-b${ALPHA}-linux-i586-${DATE}.jar"
amd64_plug="jdk-7-ea-plug-b${ALPHA}-linux-amd64-${DATE}.jar"

DESCRIPTION="Open Source JDK"
HOMEPAGE="https://openjdk.dev.java.net/"
SRC_URI="${BASE_URL}/${srcfile}"
#	x86? ( ${BASE_URL}/${x86_plug} )
#	amd64? ( ${BASE_ULR}/${amd64_plug} )"
SLOT="1.7"
# Needs other for Apache asm etc see THIRD_PARTY_README
LICENSE="GPL-2-with-linking-exception sun-prerelease-jdk7"
KEYWORDS=""
IUSE="doc examples fontconfig"

COMMON_DEP="
	media-libs/alsa-lib
	media-libs/libpng
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXtst
	fontconfig? ( media-libs/fontconfig )"

# Found by included libs but not built by default I think:
#	dev-libs/elfutils
# Bundled (should make it to use system copy):
#   media-libs/jpeg

DEPEND="
	app-arch/unzip
	app-arch/zip
	virtual/motif
	>=virtual/jdk-1.6
	>=dev-java/sun-jdk-${PV}
	x11-libs/libXmu
	x11-libs/libXrandr
	x11-libs/libXt
	x11-proto/inputproto
	x11-proto/xextproto
	x11-proto/xproto
	x11-proto/xineramaproto
	net-print/cups
	${COMMON_DEP}"

RDEPEND="${COMMON_DEP}
	doc? ( =dev-java/java-sdk-docs-1.6.0* )
	"

S="${WORKDIR}/o"

JAVA_PROVIDE="jdbc-stdext jdbc-rowset"

pkg_setup() {
	java-vm-2_pkg_setup
	java-pkg-2_pkg_setup
}

src_unpack() {
	unpack ${srcfile}
	mv ${PN} o || die #Argument list gets too long on amd64 without this
	cd "${S}"
	echo "Deleting bundled zlib"
	rm -r j2se/src/share/native/java/util/zip/zlib-1.1.3 || die
	echo "Deleting bundled libpng"
	rm -r j2se/src/share/native/sun/awt/libpng || die
	echo "Deleting bundled X11 files"
	# To find these grep -E "\\\$(XConsortium|XFree86)" -l *
	# But we can't currently link against x11-apps/xwd sources so they remain
	# bundled
	cd j2se/src/solaris/native/sun/awt
	rm -v randr.h panoramiXext.h panoramiXproto.h Xrandr.h extutil.h \
		Xinerama.c Xinerama.h || die
	cd -

	PATCHES="lesstif external-zlib external-zlib-splash external-jpeg-splash \
		external-giflib external-libpng noundef gettimeofday-declaration j2se-cxxflags \
		hotspot-cflags cpuid-fomit-frame-pointer dynamic-libstdc++ \
		icedtea-text-relocations execstack external-libXinerama tempname-free \
		fontconfig-directlink b14-gcc4"

	for patch in ${PATCHES}; do
		epatch "${FILESDIR}/${patch}.patch"
	done
}

src_compile() {
	cd control/make

	# Handling the binary plugs by using sun-jdk-1.7.
	# Should switch to the upstream plug when it can be unpacked without a GUI
	local sunjdk7="$(java-config --select-vm=sun-jdk-1.7 -O)"
	local make=" ALT_BOOTDIR=${JAVA_HOME}"
	make="${make} ALT_CLOSED_JDK_IMPORT_PATH=${sunjdk7}"
	make="${make} ALT_JDK_IMPORT_PATH=${sunjdk7}"

	use fontconfig && make="${make} DIRECT_LINK_FONTCONFIG=true"
	use doc || make="${make} NO_DOCS=true"

	# Don't pass these to make, or they'll break stuff.
	export OTHER_CFLAGS=${CFLAGS}
	export OTHER_CXXFLAGS=${CXXFLAGS}

	# Unset these so they are not used by the build process.
	# Setting them to '' breaks other things.
	unset CFLAGS CXXFLAGS

	unset JAVA_HOME CLASSPATH LD_LIBRARY_PATH

	# By default FULL_VERSION gets set like:
	# USER_RELEASE_SUFFIX := $(shell echo $(USER)_`date '+%d_%b_%Y_%H_%M' | tr "A-Z" "a-z"`)
	# FULL_VERSION = $(RELEASE)-$(USER_RELEASE_SUFFIX)-$(BUILD_NUMBER)
	# This doesn't work with ccache because it expects the command line to be
	# identical.
	emake ${make} -j1 \
		EXTERNAL_LIBPNG=true \
		EXTERNAL_ZLIB=true \
		OPENJDK=true \
		NO_STRIP=true \
		SKIP_COMPARE_IMAGES=true \
		STATIC_CXX=false \
		MILESTONE=experimental \
		BUILD_NUMBER=gentoo-b${ALPHA} \
		EXTERNAL_LIBXINERAMA=true \
		|| die "emake failed"
	rmdir control/build/linux-${arch}/j2sdk-image/man/ja
}

src_install() {
	local dest=/opt/${P}
	local ddest="${D}/${dest}"
	dodir ${dest}

	local arch=i586
	[[ ${ARCH} = amd64 ]] && arch=amd64

	cd control/build/linux-${arch}/

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

#	if use nsplugin; then
#		local plugin_dir="ns7-gcc29"
#		if has_version '>=sys-devel/gcc-3' ; then
#			plugin_dir="ns7"
#		fi
#
#		if use x86 ; then
#			install_mozilla_plugin /opt/${P}/jre/plugin/i386/$plugin_dir/libjavaplugin_oji.so
#		else
#			eerror "No plugin available for amd64 arch"
#		fi
#	fi

	# create dir for system preferences
	dodir /opt/${P}/jre/.systemPrefs
	# Create files used as storage for system preferences.
	touch ${D}/opt/${P}/jre/.systemPrefs/.system.lock
	chmod 644 ${D}/opt/${P}/jre/.systemPrefs/.system.lock
	touch ${D}/opt/${P}/jre/.systemPrefs/.systemRootModFile
	chmod 644 ${D}/opt/${P}/jre/.systemPrefs/.systemRootModFile

	# install control panel for Gnome/KDE
	if [[ -f ${D}/opt/${P}/jre/plugin/desktop/sun_java.desktop ]]; then
		# install control panel for Gnome/KDE
		# The jre also installs these so make sure that they do not have the same
		# Name
		sed -e "s/\(Name=\)Java/\1 Java Control Panel for Sun JDK ${SLOT}/" \
			-e "s#Exec=.*#Exec=/opt/${P}/jre/bin/ControlPanel#" \
			-e "s#Icon=.*#Icon=/opt/${P}/jre/plugin/desktop/sun_java.png#" \
			${D}/opt/${P}/jre/plugin/desktop/sun_java.desktop > \
			${T}/sun_jdk-${SLOT}.desktop

		domenu ${T}/sun_jdk-${SLOT}.desktop
	fi
	set_java_env
}

pkg_postinst() {
	# Set as default VM if none exists
	java-vm-2_pkg_postinst

	echo
	ewarn "Some parts of Sun's JDK require virtual/x11 and/or virtual/lpr to be installed."
	ewarn "Be careful which Java libraries you attempt to use."

	echo
	einfo " Be careful: ${P}'s Java compiler uses"
	einfo " '-source 1.7' as default. This means that some keywords "
	einfo " such as 'enum' are not valid identifiers any more in that mode,"
	einfo " which can cause incompatibility with certain sources."
	einfo " Additionally, some API changes may cause some breakages."
}
