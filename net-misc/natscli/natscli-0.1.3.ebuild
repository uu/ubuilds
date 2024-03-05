# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

DESCRIPTION="The NATS Command Line Interface"
HOMEPAGE="https://github.com/nats-io/natscli"
MY_P="nats-${PV}-linux-amd64"
SRC_URI="https://github.com/nats-io/natscli/releases/download/v${PV}/${MY_P}.zip"
QA_PRESTRIPPED="usr/bin/nats"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_install() {
	dobin nats
	dodoc README.md
}
