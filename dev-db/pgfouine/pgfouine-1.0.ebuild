# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $ 

inherit webapp eutils depend.php einput

DESCRIPTION="Web-based PostgreSQL log analyzer used to determine which queries you should optimize to speed up your PostgreSQL based application."
HOMEPAGE="http://pgfouine.projects.postgresql.org/"
SRC_URI="http://pgfoundry.org/frs/download.php/1334/${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE="vhosts tests graphs"
RDEPEND="sys-apps/findutils"

pkg_setup() {
	ewarn "Checking if PHP has been installed as a CLI"
	ewarn "If the following fails, PHP needs to be compiled with the CLI use flag"
	require_php_cli
	webapp_pkg_setup
	has_php
	if use graphs;then
		require_php_with_any_use "gd" "gd-external"
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}
	find ${S} -name rpm-specific\* -or \( -type d -name patches -prune \) -or \
	\( -type f -name pgfouine.spec \) -exec rm -rf {} \;
	if ! use tests;then
	find ${S} -type d -name tests -prune -exec rm -rf {} \;
	fi
}

src_compile() {
		einfo "Nothing left to compile"
}

src_install() {
	webapp_src_preinst
	local docs="AUTHORS ChangeLog README COPYING THANKS INSTALL"
	cd ${S}
	dodoc ${docs}
		
	rm -rf ${docs}

	einfo "Installing main files into ${MY_MYHOSTROOTDIR}/${P}"
	cp -rf . ${D}${MY_HOSTROOTDIR}/${P}
	cp -f ${FILESDIR}/spgfouine ${D}${MY_HOSTROOTDIR}/${P}
	insinto ${MY_MYHOSTROOTDIR}/${P}
	webapp_src_install
}

pkg_postinst() {
	webapp_pkg_postinst
	einfo
	einfo
	einfo "Because of the irregularity of postgresql.conf files"
	einfo "you will need to add/update the following variables to"
	einfo "your own postgresql.conf manually to enable logging:"
	einfo "log_duration = true"
	einfo "log_min_duration_statement = 0" 
	if has_version '>=dev-db/postgresql-8';then
	einfo "log_destination = 'syslog'"
	pg8=1
	else
	einfo "syslog = 2"
	pg8=0
	fi
	einfo "pgfouine brings many new features, including vacuum support."
	einfo "Please see http://pgfouine.projects.postgresql.org/vacuum.html for more information."
	ewarn ""
	ewarn "IMPORTANT: run emerge --config pgfouine"
	ewarn ""
}

pkg_config() {
	G_HOSTNAME="localhost"
	webapp_read_config
	szInstallPath=${ROOT}${VHOST_ROOT}/${PN}
	has_php
	szVerPath=${ROOT}${VHOST_ROOT}/${P}
	szSysLogDir="/var/log/postgresql"
	if has_version ">=app-admin/syslog-ng-1.0";then
	einfo "The following config will help you setup:"
	einfo
	einfo "a) syslog-ng.conf rules for PostgreSQL logging"
	einfo "b) cron to generate reports on a regular basis"
	einfo
	einput_confirm "Continue with setting up /etc/syslog-ng/syslog-ng.conf rules for PostgreSQL?"
	if [ "${EINPUT_IANSWER}" == "y" ] || [ "${EINPUT_IANSWER}" == "yes" ];then
	einfo
	einfo "If you don't know what to do, the defaults denoted inside brackets usually suffice"
	einfo "(just hit enter)"
	einfo
	if [ -w /etc/syslog-ng/syslog-ng.conf ];then
	einput_confirm "Detected a syslog-ng.conf in /etc/syslog-ng/, is this the one you want to use?"
		if [ "${EINPUT_IANSWER}" == "y" ] || [ "${EINPUT_IANSWER}" == "yes" ];then
			szSysLogConf="/etc/syslog-ng/syslog-ng.conf"
		else
			einput_prompt "Please specify the path to your syslog-ng.conf" "/etc/syslog-ng/syslog-ng.conf"
		fi
	fi
	
	if [ ! -w ${szSysLogConf} ];then
	einput_prompt "Cannot use ${szSysLogConf}, please specify the path to a valid syslog-ng.conf" "/etc/syslog-ng/syslog-ng.conf"
		if [ -w $EINPUT_IANSWER ];then
			szSysLogConfpgfouine$2
		else
			eerror "Unable to find a writable syslog-ng.conf in $2. Exiting"
		fi
	fi
	einput_prompt "syslog-ng filter?" "filter f_postgres { program(\"postgres\"); };"
	szSysLogFilter=${EINPUT_IANSWER}
	if [ ! -d /var/log/postgresql ];then
		einput_prompt "Specify where I should attempt to create the PostgreSQL log directory" "/var/log/postgresql"
		szSysLogDir=${EINPUT_IANSWER}
		mkdir -p ${EINPUT_IANSWER}
	fi
	szDefaultDest="destination dest_postgres { file(\"${szSysLogDir}/log-sql.\$YEAR.\$MONTH.\$DAY\"); };"
	einput_prompt "syslog-ng destination?" "${szDefaultDest}"
	szSysLogDest="${EINPUT_ANSWER}"

	if [ "${szSysLogDest}" != "${szDefaultDest}" ]; then
		ewarn "${szSysLogDest}"
		ewarn "Not using default destination rule, be sure to modify the INPUT_SCHEMA in ${szVerPath}/spgfouine"
		ewarn "to reflect your changes!"
		ewarn "${szDefaultDest}"
	fi
	
	einput_prompt "syslog-ng rule?" "log { source(src); filter(f_postgres); destination(dest_postgres); };"
	szSysLogRule=${EINPUT_IANSWER}
	einfo
	einfo "The following will be written to ${szSysLogConf}"
	einfo
	einfo "${szSysLogFilter}"
	einfo "${szSysLogDest}"
	einfo "${szSysLogRule}"
	einfo 
	einput_confirm "Continue with writing these rules to ${szSysLogConf}?"
		if [ "${EINPUT_IANSWER}" == "y" ] || [ "${EINPUT_IANSWER}" == "yes" ];then
			echo "${szSysLogFilter}" >> ${szSysLogConf}
			echo "${szSysLogDest}" >> ${szSysLogConf}
			echo "${szSysLogRule}" >> ${szSysLogConf}
			einfo "Restarting syslog-ng"
			/etc/init.d/syslog-ng restart
		else
			ewarn "Nothing written to ${szSysLogConf}, please add the rules"
			ewarn "manually"
		fi
	fi
	einput_confirm "Continue with setting up a daily cron job for reports?"
	if [ ${EINPUT_IANSWER} == "y" ] || [ ${EINPUT_IANSWER} == "yes" ];then
		einfo
		einfo "Moving spgfouine from ${szVerPath}/spgfouine to /etc/cron.daily"
		einfo
		mv -f ${szVerPath}/spgfouine /etc/cron.daily
		einfo
		einfo "chmod'ing spgfouine to 0755"
		einfo
		chmod 0755 /etc/cron.daily/spgfouine
		sed -i -re "s:PATH_TO_PHP=\"\":PATH_TO_PHP=\"${PHPCLI}\":g" /etc/cron.daily/spgfouine
		sed -i -re "s:PATH_TO_LOGS=\"\":PATH_TO_LOGS=\"${szSysLogDir}\":g" /etc/cron.daily/spgfouine
		sed -i -re "s:PATH_TO_REPORTS=\"\":PATH_TO_REPORTS=\"${szInstallPath}/reports\":g" /etc/cron.daily/spgfouine
		sed -i -re "s:PATH_TO_PGFOUINE=\"\":PATH_TO_PGFOUINE=\"${szVerPath}/pgfouine.php\":g" /etc/cron.daily/spgfouine
		if [ ! -d ${szInstallPath}/reports ];then
			mkdir -p ${szInstallPath}/reports
			einfo "Created ${szInstallPath}/reports"
		fi
		einfo
		einfo "NOTE: By default reports will be put in"
		einfo "${szInstallPath}/pgsql_report.\$YEAR.\$MONTH.\$DAY.html"
		einfo "You can modify this and other paths by editing /etc/cron.daily/spgfouine"
		einfo
	fi
	einfo "Nothing left to do :-)"
	else
		einfo "Syslog-ng is not emerged on this system. You will need to edit ${szVerPath}/spgfouine"
		einfo "manually and setup your syslog rules accordingly. Please refer to"
		einfo "http://pgfouine.projects.postgresql.org/tutorial.html"
		einfo "for more information on how to do this."
		einfo "You can use ${szVerPath}/spgfouine to automate report generation"
	fi
}

pkg_postrm() {
	if [ -e /etc/cron.daily/spgfouine ];then
		ewarn "/etc/cron.daily/spgfouine exists, please remove this file"
		ewarn "manually."
	fi
}
