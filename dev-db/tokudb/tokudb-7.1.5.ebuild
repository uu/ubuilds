# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils user


DESCRIPTION="TokuDB® scales MySQL® and MariaDB® from GBs to TBs while improving
insert and query speed, compression, replication performance and online schema
flexibility for both HDDs and flash."
HOMEPAGE="http://www.tokutek.com/"

MY_BASEV="5.5.36"
MY_BUILD=""

MY_PN="mariadb-${MY_BASEV}-tokudb-${PV}-linux-x86_64"

SRC_URI="${MY_PN}.tar.gz"

LICENSE="GPLv2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
        dev-libs/libaio
		>=sys-apps/openrc-0.7.0
"

pkg_nofetch() {
	einfo "Please download the appropriate archive ${SRC_URI}"
	einfo "from ${HOMEPAGE}."
	einfo ""
	einfo "Then put the file in ${DISTDIR}"
}

src_unpack() {
	unpack ${SRC_URI}
}

src_compile() {
	true
}

src_install() {
	cd ${WORKDIR}/${MY_PN}/

	dodir /etc/mysql/
	
	dodir /var/lib/mysql
	dodir /var/run/mysqld
	dodir /usr/share/${PN}/
	dosym /usr/share/${PN} /usr/share/mysql

	cp support-files/my-huge.cnf support-files/my.cnf
	insinto /etc/mysql/
	doins support-files/*.cnf
	doins support-files/*.ini
	rm support-files/*.cnf
	rm support-files/*.ini

	insinto /usr/share/${PN}/
	doins -r support-files
	doins -r sql-bench
	doins -r share/*
	doins -r mysql-test
	doins COPYING
	doins COPYING.LESSER
	doins INSTALL-BINARY
	doins README

	insinto /etc/mysql/
	newins ${FILESDIR}/my.cnf my.cnf

	insinto /etc/conf.d/
	newins ${FILESDIR}/conf.d.mysql mysql

	exeinto /etc/init.d/
	newexe ${FILESDIR}/init.d.mysql mysql

	dosbin bin/mysqld
	dosbin bin/mysqld_multi
	dosbin bin/mysqld_safe
	rm bin/mysqld
	rm bin/mysqld_multi
	rm bin/mysqld_safe

	dobin bin/*
	dobin scripts/*
	dolib lib/*.so*
	dolib.a lib/*.a
	dodoc docs/*

	insinto /usr/lib64/mysql/plugin/
	doins -r lib/plugin/*

	insinto /usr/include
	doins -r include/*

	insinto /usr/share/man/
	doins -r man/*
}

pkg_setup() {
    enewgroup mysql
	enewuser mysql -1 -1 -1 "mysql"
}

pkg_postinst() {
	elog "If this is a new install, you may want to run"
	elog "mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --force --user=mysql"
}
