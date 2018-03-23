# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils user flag-o-matic

DESCRIPTION="NGINX Unit is a dynamic web application server."

HOMEPAGE="https://unit.nginx.org/"
SRC_URI="http://unit.nginx.org/download/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="php python ruby perl -ipv6 +sockets -debug -static-libs"

DEPEND=""
CDEPEND="php? ( dev-lang/php:=[embed] )
ruby? ( dev-lang/ruby )"
RDEPEND="${DEPEND}"

pkg_setup() {
	UNIT_HOME="/var/lib/unit"
	UNIT_HOME_TMP="${NGINX_HOME}/tmp"

	ebegin "Creating unit user and group"
		enewgroup ${PN}
		enewuser ${PN} -1 -1 "${UNIT_HOME}" ${PN}
	eend $?
}

src_configure() {
	# fix for gcc-7.3+
	append-cflags -Wno-implicit-fallthrough
	myconf=""
	if use debug; 	 then myconf+="--debug ";	        fi
	if use !ipv6;    then myconf+="--no-ipv6 ";	        fi
	if use !sockets; then myconf+="--no-unix-sockets ";	fi
	if use static-libs; then myconf+="--lib-static ";	fi
	./configure --state="${EPREFIX}"/tmp --modules="${EPREFIX}"/usr/lib/${PN} --prefix="${EPREFIX}"/usr --user="${PN}" --group="${PN}" ${myconf} || die "Configure failed"

	if use php; then
		./configure php --lib-path=$(php-config --prefix)/lib64 || die "Configure PHP failed"
	fi

	if use python; then
		./configure python || die "Configure python failed"
	fi

	if use perl; then
		./configure perl || die "Configure python failed"
	fi

	if use ruby; then
		./configure ruby || die "Configure ruby failed"
	fi

}

src_compile() {
	emake all || die "Make failed"
}
