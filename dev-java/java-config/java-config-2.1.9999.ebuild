# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit fdo-mime gnome2-utils distutils eutils subversion

ESVN_REPO_URI="http://overlays.gentoo.org/svn/proj/java/projects/java-config-2/trunk/"

DESCRIPTION="Java environment configuration tool"
HOMEPAGE="http://www.gentoo.org/proj/en/java/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-lang/python"
RDEPEND="${DEPEND}
	dev-java/java-config-wrapper"

PYTHON_MODNAME="java_config_2"

src_install() {
	distutils_src_install

	insinto /usr/share/java-config-2/config/
	newins config/jdk-defaults-${ARCH}.conf jdk-defaults.conf || die "arch config not found"
}

pkg_postrm() {
	distutils_python_version
	distutils_pkg_postrm
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postinst() {
	distutils_pkg_postinst
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update

	elog "The way Java is handled on Gentoo has been recently updated."
	elog "If you have not done so already, you should follow the"
	elog "instructions available at:"
	elog "\thttp://www.gentoo.org/proj/en/java/java-upgrade.xml"
	elog
	elog "While we are moving towards the new Java system, we only allow"
	elog "1.3 or 1.4 JDKs to be used with java-config-1 to ensure"
	elog "backwards compatibility with the old system."
	elog "For more details about this, please see:"
	elog "\thttp://www.gentoo.org/proj/en/java/why-we-need-java-14.xml"
}
