# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Easy & Flexible Alerting With ElasticSearch"
HOMEPAGE="https://github.com/Yelp/elastalert"
SRC_URI="https://github.com/Yelp/elastalert/archive/v${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DEPEND="=dev-python/twilio-6.0.0"
RDEPEND="${DEPEND}"

python_prepare_all() {
	rm -rf tests || die
	distutils-r1_python_prepare_all
}
