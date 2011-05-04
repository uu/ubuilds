# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/centreon/centreon-1.4.2.4.ebuild,v 1.3 2008/04/03 08:30:17 hollow Exp $

inherit depend.php

DESCRIPTION="Centreon is a monitoring web-frontend based on the nagios monitoring engine"
HOMEPAGE="http://www.centreon.org"
SRC_URI="http://download.centreon.com/${PN}/${P}.tar.gz"

EAPI=2
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ldap xmlwriter"

#version 1 cannot be upgraded
DEPEND="!<net-analyzer/centreon-2"

RDEPEND="
	>=net-analyzer/nagios-3
	net-analyzer/rrdtool[perl]
	net-analyzer/net-snmp[perl]
	net-analyzer/snmptt
	net-analyzer/ndoutils
	app-admin/sudo
	>=dev-lang/php-5[xmlwriter?,mysql,ldap?,posix,snmp,soap,truetype]
	>=dev-php/PEAR-PEAR-1.8.1
	dev-php/smarty
	dev-php/PEAR-Archive_Tar
	dev-php/PEAR-Console_Getopt
	>=dev-php/PEAR-DB-1.7.6
	>=dev-php/PEAR-DB_DataObject_FormBuilder-1.0.0_rc4
	>=dev-php/PEAR-Date-1.4.6
	>=dev-php/PEAR-HTML_QuickForm_advmultiselect-1.1.0
	>=dev-php/PEAR-HTML_Table-1.6.1
	>=dev-php/PEAR-MDB2-2.0.0
	>=dev-php/PEAR-Net_Ping-2.4.1
	>=dev-php/PEAR-Net_Traceroute-0.21
	>=dev-php/PEAR-SOAP-0.10.1
	>=dev-php/PEAR-Validate-0.6.2
	dev-perl/Config-IniFiles
	dev-perl/Crypt-DES
	dev-perl/DBI
	dev-perl/Digest-HMAC
	dev-perl/Digest-SHA1
	dev-perl/GD
	dev-perl/IO-Socket-INET6
	dev-perl/Net-SNMP
	dev-perl/Socket6"

#need_2
need_php5.3

setup_vars() {
	INSTALL_DIR_OREON="/usr/share/centreon"
	INSTALL_DIR_CENTREON="/usr/share/centreon"
	OREON_PATH=${INSTALL_DIR_OREON}
	CENTREON_ETC="/etc/centreon"
	CENTREON_VARLIB="/var/lib/centreon"
	VARLIB_CENTERON=${CENTERON_VARLIB}
	CENTREON_LOG="/var/log/centreon"
	CENTREON_PATH=${OREON_PATH}
	CENTREON_RUNDIR="/var/run/centreon"
	CENTREON_GENDIR="/var/cache/centreon"
	CENTSTORAGE_RRD="${CENTREON_GENDIR}/rrd"
	CENTSTORAGE_LIB="${CENTREON_RRD}"
	CENTPLUGINS_TMP="${CENTREON_GENDIR}/tmp"
	CENTPLUGINSTRAPS_BINDIR="/usr/sbin"

	INSTALL_DIR_NAGIOS="/usr/share/nagios"
	NAGIOS_ETC="/etc/nagios"
	NAGIOS_VAR="/var/nagios"
	NAGIOS_BIN="/usr/sbin"
	NAGIOS_BINARY="${NAGIOS_BIN}/nagios"
	NAGIOSTATS_BINARY="${NAGIOS_BINARY}tats"
	NAGIOS_PLUGINS="/usr/lib/nagios/plugins"
	NAGIOS_PLUGIN=${NAGIOS_PLUGINS}
	NAGIOS_IMG="${INSTALL_DIR_NAGIOS}/htdocs/images"
	NAGIOS_INIT_SCRIPT="/etc/init.d/nagios"
	NAGIOS_USER="nagios"
	NAGIOS_GROUP="nagios"

	NDOMOD_BINARY="/usr/bin/ndomod-3x.o"
	BIN_RRDTOOL="/usr/bin/rrdtool"
	BIN_MAIL="/bin/mail"
	BIN_SSH="/usr/bin/ssh"
	BIN_SCP="/usr/bin/scp"
	MAILER="/bin/mail"
}

pkg_setup() {
	require_php_sapi_from cli
	require_gd

	setup_vars
}

varsubst() {
	local path=$1

	for var in "$@"; do
		sed -i -e "s:@${var}@:$(eval echo \$${var}):g" "${D}${path}"
	done
}

install_centreon() {
	cd "${S}"

	# copy www and doc files
	insinto "${OREON_PATH}"
	doins -r www
	dosym /usr/share/nagios/htdocs/docs "${OREON_PATH}"/doc

	# sanitize file modes
	find "${D}${OREON_PATH}" -type d -exec chmod 755 {} \;
	find "${D}${OREON_PATH}" -type f -exec chmod 644 {} \;

	# keep important directories
	keepdir "${OREON_PATH}"/www/modules
	keepdir /var/log/centreon
	keepdir /var/cache/centreon/rrd
	keepdir /var/cache/centreon/smarty/{cache,config,compile}
	keepdir /var/cache/centreon/generate/{nagiosCFG,osm}
	keepdir /var/cache/centreon/tmp
	keepdir /var/cache/centreon/upload/nagiosCFG
	dosym /var/cache/centreon/generate /var/cache/centreon/filesGeneration

	# prepare SQL files
	varsubst "${OREON_PATH}"/www/install/insertBaseConf.sql \
		NAGIOS_{USER,GROUP,ETC,BIN,VAR,PLUGIN,PLUGINS,IMG,BINARY,INIT_SCRIPT} \
		INSTALL_DIR_NAGIOS INSTALL_DIR_{OREON,CENTREON} \
		BIN_RRDTOOL BIN_MAIL MAILER NDOMOD_BINARY NAGIOSTATS_BINARY

	varsubst "${OREON_PATH}"/www/install/createTablesCentstorage.sql \
		NAGIOS_VAR CENTSTORAGE_RRD

	# fix paths in php files
	varsubst "${OREON_PATH}"/www/include/configuration/configCGI/formCGI.php \
		NAGIOS_ETC INSTALL_DIR_NAGIOS

	varsubst "${OREON_PATH}"/www/include/options/oreon/upGrade/preUpdate.php \
		OREON_PATH
		for i in $(find www/ -type f); do
			varsubst "${OREON_PATH}"/${i} CENTREON_{ETC,VARLIB,GENDIR,LOG} \
			MAILER CENTPLUGINSTRAPS_BINDIR
		done

	# fix preinstalled smarty
	sed -i "s:\.\./GPL_LIB/Smarty/libs/:Smarty/:" \
		"${D}${OREON_PATH}/www/header.php"
	sed -i "s:\(\(../\)\+\|$centreon_path/\)GPL_LIB/SmartyCache:/var/cache/centreon/smarty:" \
		"${D}${OREON_PATH}/www/include/common/common-Func.php"
	sed -i "s:$centreon_path . 'GPL_LIB/Smarty/libs/':'Smarty/':" \
		"${D}${OREON_PATH}/www/include/monitoring/external_cmd/popup/popup.php"


	# install nginx config
#	insinto "${APACHE_MODULES_CONFDIR}"
#	doins "${FILESDIR}"/99_centreon.conf

	# install global installation config
	insinto "${OREON_PATH}"/www/install
	newins "${FILESDIR}"/initial-installconf.php install.conf.php

	# set permissions
	fowners -R nginx:nginx \
		/var/cache/centreon \
		"${OREON_PATH}"/www

	fowners -R nagios:nginx \
		/var/log/centreon
}

install_plugins() {
	cd "${S}"

	# install plugin configuration
	insinto /etc/centreon
	doins ./plugins/src/centreon.conf
	rm -f ./plugins/src/centreon.conf
	dosym "${NAGIOS_PLUGINS}/centreon.conf" /etc/centreon/centreon.conf

	varsubst /etc/centreon/centreon.conf \
		INSTALL_DIR_NAGIOS INSTALL_DIR_OREON \
		NAGIOS_ETC NAGIOS_PLUGINS

	fowners -R nginx:nginx \
		/etc/centreon

	# install nagios plugins
	exeinto "${NAGIOS_PLUGINS}"

	for plugin in ./plugins/src/*; do
		if [[ ! -d "${plugin}" ]]; then
			doexe "${plugin}"
			varsubst "${NAGIOS_PLUGINS}/$(basename "${plugin}")" \
				NAGIOS_PLUGINS NAGIOS_VAR CENTREON_ETC \
				CENTPLUGINS_TMP
		fi
	done
}

install_traps() {
	cd "${S}"

	# install snmp traps plugins
	dodir "${NAGIOS_PLUGINS}"/traps
	dodir /etc/snmp/centreon
	dosym /etc/snmp/centreon /etc/snmp/centreon_traps

	# install snmp configs
	insinto /etc/snmp/centreon
	doins plugins/src/traps/conf/snmptt.ini
	fowners -R nginx:nagios /etc/snmp/centreon

	insinto /etc/snmp/
	doins plugins/src/traps/conf/snmp.conf
	doins plugins/src/traps/conf/snmptrapd.conf
}

install_daemons() {
	cd "${S}"

	# install daemon
	insinto /usr
	dosbin bin/*
	for i in $(find bin/ -type f); do
	        varsubst /usr/sbin/$(basename "${i}") \
			CENTREON_{LOG,PATH,RUNDIR,ETC,VARLIB,DIR} \
			NAGIOS_{USER,GROUP} BIN_{SSH,SCP} CENTPLUGINS_TMP \
			CENTSTORAGE_LIB
	done
	# install daemon library files
	insinto /usr/share/centreon/lib
	doins lib/*

	# install init script
	newinitd "${FILESDIR}"/centreon.initd centreon

	# keep important directories
	keepdir /etc/centreon
	keepdir /var/run/centreon
	keepdir /var/log/centreon
	keepdir /var/lib/centreon
	keepdir /var/lib/centreon/database

	# set permissions
	fowners -R nagios:nagios \
		/var/run/centreon \
		/var/log/centreon \
		/var/lib/centreon/database
}

install_cron() {
	cd "${S}"

	insinto "${OREON_PATH}"
	doins -r cron

	fperms +x "${OREON_PATH}"/cron/*

	for i in $(find cron/ -type f); do
		varsubst "${OREON_PATH}"/${i} \
			CENTREON_{PATH,ETC,VARLIB,LOG,RUNDIR} \
			VARLIB_CENTREON
	done

	insinto /etc/cron.d
	newins "${FILESDIR}"/centreon-2.cron centreon
}

src_install() {
	install_centreon
	install_plugins
	install_traps
	install_daemons
	install_cron
}

pkg_config() {
	setup_vars

	einfo "Setting permissions on ${ROOT}${NAGIOS_ETC}"
	chown nagios:nginx "${ROOT}${NAGIOS_ETC}"
	chmod 0775 "${ROOT}${NAGIOS_ETC}"

	einfo "Setting permissions on ${ROOT}${NAGIOS_PLUGINS}"
	chown nagios:nginx "${ROOT}${NAGIOS_PLUGINS}"
	chmod 0775 "${ROOT}${NAGIOS_PLUGINS}"

	einfo "Setting permissions on ${ROOT}${NAGIOS_PLUGINS}/contrib"
	chown nagios:nginx "${ROOT}${NAGIOS_PLUGINS}"/contrib
	chmod 0775 "${ROOT}${NAGIOS_PLUGINS}"/contrib

	einfo "Adding user nginx to group nagios"
	usermod -a -G nagios nginx

	SUDOERS="${ROOT}etc/sudoers"

	if ! grep -q CENTREON "${SUDOERS}"; then
		einfo "Adding sudo configuration"
		echo >> "${SUDOERS}"
		echo "# centreon configuration" >> "${SUDOERS}"
		echo "User_Alias  CENTREON=nginx" >> "${SUDOERS}"
		echo "CENTREON    ALL = NOPASSWD: /etc/init.d/nagios restart" >> "${SUDOERS}"
		echo "CENTREON    ALL = NOPASSWD: /etc/init.d/nagios reload"  >> "${SUDOERS}"
		echo "CENTREON    ALL = NOPASSWD: /etc/init.d/snmptrapd restart" >> "${SUDOERS}"
	fi
}
