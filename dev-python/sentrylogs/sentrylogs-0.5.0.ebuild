# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

PYTHON_COMPAT=( python2_7 python3_4 python3_5 python3_6 python3_7 )

inherit distutils-r1

DESCRIPTION="Send logs from Nginx and other applications to Sentry."
HOMEPAGE="https://pypi.org/project/SentryLogs/"
SRC_URI="https://pypi.python.org/packages/source/S/SentryLogs/SentryLogs-${PV}.tar.gz"


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"
IUSE=""


DEPEND="dev-python/sentry-sdk
dev-python/tailhead"
RDEPEND="${DEPEND}"

S="${WORKDIR}/SentryLogs-${PV}"

