# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit versionator

DESCRIPTION="end your projects up in the clouds"
HOMEPAGE="http://rocketeer.autopergamene.eu/"

MY_PV=$(replace_version_separator _ -)

SRC_URI="http://rocketeer.autopergamene.eu/versions/rocketeer.phar -> rocketeer-9999.phar"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=dev-lang/php-5.3.4"
RDEPEND="dev-lang/php[zip]"

src_unpack() {
	cp "${DISTDIR}/${A}" "${WORKDIR}"
	S=${WORKDIR}
}

src_install() {
	mv "${WORKDIR}/${A}" "${WORKDIR}/${PN}"
	dobin ${PN}

}
