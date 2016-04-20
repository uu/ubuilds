EAPI="6"

inherit eutils user unpacker

SRC_URI="https://s3.amazonaws.com/influxdb/influxdb_${PV}-1_amd64.deb"

IUSE=""

DESCRIPTION="Scalable datastore for metrics, events, and real-time analytics"
HOMEPAGE="http://influxdb.com/"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64"

pkg_setup() {
    ebegin "Creating influxdb user and group"
    enewgroup influxdb
    enewuser influxdb -1 -1 "/var/lib/influxdb" influxdb
    eend $?
}

src_unpack() {
    unpacker_src_unpack
    mkdir "$PF"
    mv etc usr "$PF/"
}

src_install() {
    dodir /etc/influxdb
    dodir /var/{lib,log}/influxdb 
    keepdir /var/{lib,log}/influxdb 
	fowners influxdb:influxdb /var/{lib,log}/influxdb

    into /usr
    dobin usr/bin/{influx,influxd,influx_inspect,influx_stress,influx_tsm}

    insinto /etc/influxdb
    newins "${S}/etc/influxdb/influxdb.conf" influxdb.conf
    sed -i -re 's#reporting-disabled = false#reporting-disabled = true#' "${D}/etc/influxdb/influxdb.conf"
    sed -i -re 's#/var/opt/influxdb#/var/lib/influxdb#' "${D}/etc/influxdb/influxdb.conf"

    newinitd "${FILESDIR}"/influxdb.initd influxdb
    newconfd "${FILESDIR}"/influxdb.confd influxdb
}
