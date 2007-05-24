# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sun-jdk/sun-jdk-1.5.0.05.ebuild,v 1.2 2005/10/10 16:23:12 betelgeuse Exp $

inherit java-vm-2 eutils pax-utils

MY_PV=${PV/_alpha*/}
MY_PVL=${MY_PV%.*}_${MY_PV##*.}
MY_PVA=${MY_PV//./_}
BETA=${PV#*_alpha}
DATE="12_apr_2007"

BASE_URL="http://www.java.net/download/jdk6/6u2/promoted/b${BETA}/binaries/"
x86file="jdk-6u2-ea-bin-b${BETA}-linux-i586-${DATE}.bin"
amd64file="jdk-6u2-ea-bin-b${BETA}-linux-amd64-${DATE}.bin"

S="${WORKDIR}/jdk${MY_PVL}"
DESCRIPTION="Sun's Java Development Kit"
HOMEPAGE="https://jdk6.dev.java.net/"
SRC_URI="x86? ( ${BASE_URL}/$x86file ) amd64? ( ${BASE_URL}/$amd64file )"
SLOT="1.6.0.02"
LICENSE="sun-prerelease-jdk6"
KEYWORDS="~amd64 ~x86"
RESTRICT="nostrip fetch"
# TODO: needs to remove libs that don't have satisfied deps
IUSE="X alsa doc nsplugin examples"

DEPEND="sys-apps/sed"

RDEPEND="
	=virtual/libstdc++-3.3
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXp
		x11-libs/libXtst
	)
	alsa? ( media-libs/alsa-lib )
	doc? ( =dev-java/java-sdk-docs-1.6.0* )"

JAVA_PROVIDE="jdbc-stdext jdbc-rowset"

PACKED_JARS="jre/lib/rt.jar jre/lib/jsse.jar jre/lib/charsets.jar lib/tools.jar jre/lib/ext/localedata.jar jre/lib/plugin.jar jre/lib/javaws.jar jre/lib/deploy.jar"

# this is needed for proper operating under a PaX kernel without activated grsecurity acl
CHPAX_CONSERVATIVE_FLAGS="pemsv"

QA_TEXTRELS_x86="opt/${P}/jre/lib/i386/server/libjvm.so
	opt/${P}/jre/lib/i386/client/libjvm.so
	opt/${P}/jre/lib/i386/motif21/libmawt.so
	opt/${P}/jre/lib/i386/libdeploy.so"

pkg_nofetch() {
	einfo "Please download:"
	if use x86; then
		einfo "${BASE_URL}${x86file}"
	elif use amd64; then
		einfo "${BASE_URL}${amd64file}"
	fi
	einfo "Then place it in ${DISTDIR}"

	ewarn "By downloading and installing, you are agreeing to the terms"
	ewarn "of Sun's prerelease license."
}

src_unpack() {
	# Do a little voodoo to extract the distfile
	# Find the ELF in the script
	testExp=$(echo -e '\0105\0114\0106')
	startAt=$(grep -aonm 1 ${testExp}  ${DISTDIR}/${A} | cut -d: -f1)
	# Extract and run it
	tail -n +${startAt} ${DISTDIR}/${A} > install.sfx
	chmod +x install.sfx
	./install.sfx >/dev/null || die
	rm install.sfx

	if [ -f ${S}/bin/unpack200 ]; then
		UNPACK_CMD=${S}/bin/unpack200
		chmod +x $UNPACK_CMD
		sed -i 's#/tmp/unpack.log#/dev/null\x00\x00\x00\x00\x00\x00#g' $UNPACK_CMD
		for i in $PACKED_JARS; do
			PACK_FILE=${S}/$(dirname $i)/$(basename $i .jar).pack
			if [ -f ${PACK_FILE} ]; then
				echo "	unpacking: $i"
				$UNPACK_CMD ${PACK_FILE} ${S}/$i
				rm -f ${PACK_FILE}
			fi
		done
		rm -f ${UNPACK_CMD}
	else
		die "unpack not found"
	fi
	${S}/bin/java -client -Xshare:dump
}

src_install() {
	local dirs="bin include jre lib man"

	# Set PaX markings on all JDK/JRE executables to allow code-generation on
	# the heap by the JIT compiler.
	pax-mark m $(list-paxables ${S}{,/jre}/bin/*)

	dodir /opt/${P}

	for i in $dirs ; do
		cp -pPR $i ${D}/opt/${P}/ || die "failed to copy"
	done
	dodoc COPYRIGHT README.html
	dohtml README.html
	dodir /opt/${P}/share/

	if use examples; then
		cp -pPR demo sample ${D}/opt/${P}/share/
	fi
	cp -pPR src.zip ${D}/opt/${P}/share/


	if use nsplugin; then
		local plugin_dir="ns7-gcc29"
		if has_version '>=sys-devel/gcc-3' ; then
			plugin_dir="ns7"
		fi

		if use x86 ; then
			install_mozilla_plugin /opt/${P}/jre/plugin/i386/$plugin_dir/libjavaplugin_oji.so
		else
			eerror "No plugin available for amd64 arch"
		fi
	fi

	# install control panel for Gnome/KDE
	cat > ${T}/sun_java-${SLOT}.desktop <<-EOF
		[Desktop Entry]
		Name=Java Control Panel ${SLOT}
		Comment=Java Control Panel
		Exec=/opt/${P}/jre/bin/ControlPanel
		Icon=/opt/${P}/jre/plugin/desktop/sun_java.png
		Terminal=0
		Type=Application
		Categories=Application;Settings;
	EOF

	domenu ${T}/sun_java-${SLOT}.desktop

	set_java_env
}

pkg_postinst() {
	# Set as default VM if none exists
	java-vm-2_pkg_postinst

	if ! use X; then
		local xwarn="virtual/x11 and/or"
	fi

	echo
	ewarn "Some parts of Sun's JDK require ${xwarn} virtual/lpr to be installed."
	ewarn "Be careful which Java libraries you attempt to use."

	echo
	elog " Be careful: ${P}'s Java compiler uses"
	elog " '-source 1.6' as default. Some keywords such as 'enum'"
	elog " are not valid identifiers any more in that mode,"
	elog " which can cause incompatibility with certain sources."

	echo
	elog "Beginning with 1.5.0.10 the hotspot vm can use epoll"
	elog "The epoll-based implementation of SelectorProvider is not selected by"
	elog "default."
	elog "Use java -Djava.nio.channels.spi.SelectorProvider=sun.nio.ch.EPollSelectorProvider"
	elog ""
	elog "Starting with 1.6.0-r2 the src.zip is installed to the standard"
	elog "location. It is still symlinked to the old location (/opt/${P}/share)"
	elog "but the symlink will be removed with the next version bump."
	elog "See https://bugs.gentoo.org/show_bug.cgi?id=2241 and"
	elog "http://java.sun.com/javase/6/docs/technotes/tools/linux/jdkfiles.html"
	elog "for more details."
}
