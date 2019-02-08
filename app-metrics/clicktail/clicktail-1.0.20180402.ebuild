# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils unpacker
DESCRIPTION="ClickTail can parse different types of log files, including most popular ones."
HOMEPAGE="https://www.altinity.com"
SRC_URI="https://packagecloud.io/Altinity/clickhouse/packages/ubuntu/xenial/${PN}_${PV}_amd64.deb/download.deb -> ${PN}_${PV}_amd64.deb"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	unpacker_src_unpack
	mkdir "$PF"
	mv etc usr lib "$PF/"
}


src_install() {
	dobin usr/bin/clicktail
	dodir /etc/clicktail

	insinto /etc/clicktail
	doins etc/clicktail/clicktail-example.conf
    #dobin usr/bin/{influx,influxd,influx_inspect,influx_stress,influx_tsm}

    #insinto /etc/influxdb
    #newins "${S}/etc/influxdb/influxdb.conf" influxdb.conf
    #sed -i -re 's#reporting-disabled = false#reporting-disabled = true#' "${D}/etc/influxdb/influxdb.conf"
    #sed -i -re 's#/var/opt/influxdb#/var/lib/influxdb#' "${D}/etc/influxdb/influxdb.conf"

    #newinitd "${FILESDIR}"/influxdb.initd influxdb
    #newconfd "${FILESDIR}"/influxdb.confd influxdb
}

