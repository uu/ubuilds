# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/sun-jdk/sun-jdk-1.5.0.05.ebuild,v 1.2 2005/10/10 16:23:12 betelgeuse Exp $

inherit pax-utils eutils java-pkg-2 java-ant-2 java-vm-2

MY_PV=${PV/_beta*/}
MY_PVL=${MY_PV%.*}_${MY_PV##*.}
MY_PVA=${MY_PV//./_}
ALPHA=${PV#*_alpha}
DATE="06_may_2007"
MY_RPV=${MY_PV%.*}


BASE_URL="http://www.java.net/download/${PN}/40ec4ed263a6dfce13b8cf18fa046058/jdk7/promoted/b${ALPHA}/"
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
LICENSE="GPL-2-with-classpath-exception sun-bcla"
KEYWORDS="~amd64 ~x86"
RESTRICT="nostrip"
IUSE="doc examples"

COMMON_DEP="
	media-libs/alsa-lib
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXtst"

DEPEND="
	virtual/motif
	>=virtual/jdk-1.6
	>=dev-java/sun-jdk-1.7
	${COMMON_DEP}"

RDEPEND="${COMMON_DEP}
	doc? ( =dev-java/java-sdk-docs-1.6.0* )
	"

S="${WORKDIR}/${PN}"

JAVA_PROVIDE="jdbc-stdext jdbc-rowset"

PACKED_JARS="lib/tools.jar jre/lib/rt.jar jre/lib/jsse.jar jre/lib/charsets.jar jre/lib/ext/localedata.jar jre/lib/plugin.jar jre/lib/javaws.jar jre/lib/deploy.jar"

# the build system should know what it's doing
JAVA_PKG_BSFIX="off"

pkg_setup() {
	java-vm-2_pkg_setup
	java-pkg-2_pkg_setup
}

pkg_nofetch() {
	local myfile
	#initialisation
	myfile=${x86file}
	if use x86; then
		myfile=${x86_plug}
	elif use amd64; then
		myfile=${amd64_plug}
	fi

	einfo "Please download:"
	einfo "${myfile} from ${BASE_URL}${myfile}"
	einfo "Then place it in ${DISTDIR}"
	einfo "tip: wget ${BASE_URL}${myfile} -O ${DISTDIR}/${myfile}"

	ewarn "By downloading and installing, you are agreeing to the terms"
	ewarn "of Sun's Binary Code license."
}

src_unpack() {
	unpack ${srcfile}
}

src_compile() {
	cd j2se/make/netbeans/world
	local sunjdk7="$(java-config --select-vm=sun-jdk-1.7 -O)"
	local make=" ALT_BOOTDIR=${JAVA_HOME}"
	make="${make} ALT_CLOSED_JDK_IMPORT_PATH=${sunjdk7}"
	make="${make} ALT_JDK_IMPORT_PATH=${sunjdk7}"
	make="${make} OPENJDK=true"
	unset CLASSPATH
	eant -Dbootstrap.jdk="${JAVA_HOME}" -Dmake.options="${make}" -Duser.home="${T}"
}

src_install() {
	local dest=/opt/${P}
	local ddest="${D}/${dest}"
	dodir ${dest}

	local arc=i586
	[[ ${ARCH} = amd64 ]] && arch=amd64
	cd control/build/linux-${arc}/j2sdk-image
	local dirs="bin include jre lib man"
	for i in $dirs ; do
		cp -pPR $i ${ddest} || die "failed to copy"
	done

	pax-mark m $(list-paxables ${ddest}{,/jre}/bin/*)

	dodoc LICENSE ASSEMBLY_EXCEPTION THIRD_PARTY_README || die
	dohtml README.html || die

	if use examples; then
		cp -pPR demo sample ${D}/opt/${P}/share/
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
