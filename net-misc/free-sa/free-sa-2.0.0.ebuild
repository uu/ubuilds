# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Free squid log analyzer"
HOMEPAGE="http://sourceforge.net/projects/free-sa/"
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
SRC_URI="http://sourceforge.net/projects/free-sa/files/free-sa-dev/2.0.0b6p7/free-sa-2.0.0b6p7.tar.gz"
#RESTRICT="mirror"
#SRC_URI=""
#RESTRICT="fetch"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="app-admin/syslog-ng
	www-servers/apache"
RDEPEND="${DEPEND}"

S="${WORKDIR}/free-sa-2.0.0b6p7"

src_prepare() {
# fix global.mk
	sed -e 's/#OSTYPE = generic-any-cc/OSTYPE = generic-any-cc/' -i "${S}/global.mk" \
		|| die "patching global.mk"
#	sed -e 's/#OSTYPE = redhat-native-gcc/OSTYPE = redhat-native-gcc/' -i "${S}/global.mk" \
#		|| die "patching global.mk"
}

src_install() {
	MAKEOPTS=-j1 emake -j1 || die "Failed compile"
}

src_install() {
	dobin src/free-sa

	[[ -d "/etc/${PN}" ]] || dodir "/etc/${PN}" || die "failed to create ETCDIR"
	insinto "/etc/${PN}"
	doins etc/*.sample

	doman man/free-sa.1 || die "fail to install man pages"
	doman man/free-sa.conf.5 || die "fail to install man pages"

	[[ -d "/usr/share/${PN}" ]] || dodir "/usr/share/${PN}" || die "failed to create USRSHARE"
	insinto "/usr/share/${PN}"
	doins share/ru.*

	[[ -d "/var/www/html/${PN}" ]] || dodir "/var/www/html/${PN}" || die "failed to create WWWDIR"
	[[ -d "/var/www/html/${PN}/cgi-bin" ]] || dodir "/var/www/html/${PN}/cgi-bin" || die "failed to create CGIDIR"
	insinto "/var/www/html/${PN}/cgi-bin"
	doins src/free-sa.cgi
	[[ -d "/var/www/html/${PN}/themes" ]] || dodir "/var/www/html/${PN}/themes" || die "failed to create CGIDIR"

	cp -R "${S}/themes" "${D}/var/www/html/${PN}/themes" || die "theme installation failed"

	[[ -d "/var/cache/${PN}" ]] || dodir "/var/cache/${PN}" || die "failed to create CACHEDIR"

	[[ -d "/usr/share/doc/${P}" ]] || dodir "/usr/share/doc/${P}" || die "failed to create USRSHARE"
	insinto "/var/share/doc/${P}"
	dodoc ChangeLog FAQ INSTALL README README.DEV THANKS
}
