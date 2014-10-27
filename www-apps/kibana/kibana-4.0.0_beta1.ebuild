# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils

DESCRIPTION="visualize logs and time-stamped data"
HOMEPAGE="http://www.elasticsearch.org/overview/kibana/"
#SRC_URI="https://download.elasticsearch.org/${PN}/${PN}/${P}.tar.gz"
SRC_URI="https://download.elasticsearch.org/kibana/kibana/kibana-4.0.0-BETA1.1.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"
RDEPEND=""
SLOT=0
#RDEPEND="virtual/httpd-basic"
S="${WORKDIR}/kibana-4.0.0-BETA1.1"

src_prepare() {
	epatch ${FILESDIR}/kibana-gentoo-path.patch
}

src_install() {
	dobin bin/kibana

	dodir /opt/kibana
	insinto /opt/kibana
	doins lib/kibana.jar

	dodir /etc/kibana
	insinto /etc/kibana
	newins config/kibana.yml kibana.yml.dist
	
	newinitd ${FILESDIR}/kibana.initd kibana
}
