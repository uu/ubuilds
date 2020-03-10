# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

# Upstream has *way* broken tests.
RESTRICT="test"

inherit eutils user cmake-utils systemd

DESCRIPTION="Scalable PostgreSQL connection pooler"
HOMEPAGE="https://github.com/yandex/odyssey"
SRC_URI="https://github.com/yandex/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="systemd doc"
REQUIRED_USE=""
RDEPEND="systemd? ( sys-apps/systemd:0= )"

DEPEND="${RDEPEND}"
CMAKE_BUILD_TYPE=Release

pkg_setup() {
	enewgroup ${PN}
	enewuser  ${PN} -1 -1 -1  ${PN}
}

src_configure() {
	mycmakeargs=(
		-DPOSTGRESQL_INCLUDE_DIR=$(pg_config --includedir)/server
	)
	cmake-utils_src_configure
}


src_install() {
	local confdir=/etc/"${PN}"
	dobin "${WORKDIR}"/"${P}"_build/sources/"${PN}"
	dodir ${confdir}
	keepdir ${confdir}
	insinto ${confdir}
	newins "${WORKDIR}"/"${P}"/"${PN}".conf "${PN}".conf.example
	fperms 0700 ${confdir}
	fperms 0600 "${confdir}"/"${PN}".conf.example
	fowners -R ${PN}:${PN} ${confdir}

	newinitd "${FILESDIR}"/"${PN}".initd ${PN}
	newconfd "${FILESDIR}"/"${PN}".confd ${PN}

	if use systemd; then
		systemd_dounit "${WORKDIR}"/"${P}"/scripts/systemd/"${PN}".service
	fi

	if use doc; then
		dodoc "${WORKDIR}"/"${P}"/documentation/configuration.md "${WORKDIR}"/"${P}"/documentation/internals.md
	fi
}
