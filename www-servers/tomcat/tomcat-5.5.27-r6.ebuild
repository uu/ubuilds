# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/tomcat/tomcat-5.5.27-r2.ebuild,v 1.1 2008/12/19 20:48:47 ali_bush Exp $

EAPI=1
JAVA_PKG_IUSE="doc source"
WANT_ANT_TASKS="ant-trax"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Tomcat Servlet-2.4/JSP-2.0 Container"

MY_P="apache-${P}-src"
SLOT="5.5"
SRC_URI="mirror://apache/${PN}/${PN}-5/v${PV}/src/${MY_P}.tar.gz"
HOMEPAGE="http://tomcat.apache.org/"
KEYWORDS="~amd64 -ppc -ppc64 ~x86 ~x86-fbsd"
LICENSE="Apache-2.0"

IUSE="admin java5 examples test"

SERVLET_API="~dev-java/tomcat-servlet-api-${PV}"
RDEPEND="dev-java/eclipse-ecj:3.3
	dev-java/ant-eclipse-ecj:3.3
	dev-java/commons-beanutils:1.7
	>=dev-java/commons-collections-3.1
	>=dev-java/commons-daemon-1.0.1
	>=dev-java/commons-dbcp-1.2.1
	>=dev-java/commons-digester-1.7
	>=dev-java/commons-fileupload-1.1
	dev-java/commons-httpclient:0
	>=dev-java/commons-io-1.1
	>=dev-java/commons-el-1.0
	>=dev-java/commons-launcher-0.9
	>=dev-java/commons-logging-1.0.4
	>=dev-java/commons-modeler-2.0
	>=dev-java/commons-pool-1.2
	=dev-java/junit-3*
	>=dev-java/log4j-1.2.9
	>=dev-java/saxpath-1.0
	${SERVLET_API}
	dev-java/ant-core
	admin? ( dev-java/struts:1.2 )
	dev-java/sun-javamail
	java5? (
		>=virtual/jre-1.5
	)
	!java5? (
		=virtual/jre-1.4*
		dev-java/sun-jaf
		dev-java/mx4j-core:3.0
		dev-java/xerces:2
	   	dev-java/xml-commons-external:1.3
	   )"
DEPEND="java5? ( >=virtual/jdk-1.5 )
	!java5? ( =virtual/jdk-1.4* )
	${RDEPEND}"

S=${WORKDIR}/${MY_P}

TOMCAT_NAME="${PN}-${SLOT}"
WEBAPPS_DIR="/var/lib/${TOMCAT_NAME}/webapps"
TOMCAT_HOME="/usr/share/${TOMCAT_NAME}/"

pkg_setup() {
	java-pkg-2_pkg_setup
	# new user for tomcat
	enewgroup tomcat
	enewuser tomcat -1 -1 /dev/null tomcat

	java-pkg_filter-compiler ecj-3.1  ecj-3.2
	if use !java5 && built_with_use ${SERVLET_API} java5;
	then
		eerror "With USE=\"-java5\" ${SERVLET_API} must also"
		eerror "be built without java5 support"
		die "Rebuild ${SERVLET_API} without java5 support"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${SLOT}/26-main_tomcat_catalina_jasper_build_xml.patch"
	# https://issues.apache.org/bugzilla/show_bug.cgi?id=45827
	epatch "${FILESDIR}/${SLOT}/5.5.27-dynamic-JSSE13Factory.patch"

	if use examples; then
		epatch "${FILESDIR}/${SLOT}/jsr152_jsr154_examples_build_xml.patch"
		epatch "${FILESDIR}/${SLOT}/examples-cal.patch"
	fi

	sed -i -e 's:${struts.lib}:/usr/share/struts-1.2:' \
		"${S}/container/webapps/admin/build.xml"

	einfo "Removing 1.3 factories to so we don't need com.sun.*"
	rm -v connectors/util/java/org/apache/tomcat/util/net/jsse/*13* || die

	# avoid packed jars :-)
	mkdir -p "${S}"/build/build/common
	cd "${S}"/build/build

	mkdir ./bin && cd ./bin
	java-pkg_jar-from commons-logging commons-logging-api.jar
	java-pkg_jar-from commons-daemon
	if ! use java5; then
		java-pkg_jar-from mx4j-core-3.0 mx4j.jar jmx.jar
		java-pkg_jar-from mx4j-core-3.0 mx4j-rjmx.jar jmx-remote.jar
		mkdir "${S}"/build/build/common/endorsed && cd "${S}"/build/build/common/endorsed
		java-pkg_jar-from xml-commons-external-1.3 xml-apis.jar
		java-pkg_jar-from xerces-2 xercesImpl.jar
	fi

	mkdir "${S}"/build/build/common/lib && cd "${S}"/build/build/common/lib
	java-pkg_jar-from ant-core
	java-pkg_jar-from commons-collections
	java-pkg_jar-from commons-dbcp
	java-pkg_jar-from commons-el
	java-pkg_jar-from commons-pool
	java-pkg_jar-from tomcat-servlet-api-2.4

	mkdir -p "${S}"/build/build/server/lib && cd "${S}"/build/build/server/lib
	java-pkg_jar-from commons-beanutils-1.7 commons-beanutils.jar
	java-pkg_jar-from commons-digester
	java-pkg_jar-from commons-modeler

}

src_compile(){
	local antflags="-Dbase.path=${T}"

	antflags="${antflags} -Dservletapi.build.notrequired=true"
	antflags="${antflags} -Djspapi.build.notrequired=true"
	antflags="${antflags} -Dcommons-beanutils.jar=$(java-pkg_getjar commons-beanutils-1.7 commons-beanutils.jar)"
	antflags="${antflags} -Dcommons-collections.jar=$(java-pkg_getjars commons-collections)"
	antflags="${antflags} -Dcommons-daemon.jar=$(java-pkg_getjars commons-daemon)"
	antflags="${antflags} -Dcommons-digester.jar=$(java-pkg_getjars commons-digester)"
	antflags="${antflags} -Dcommons-dbcp.jar=$(java-pkg_getjars commons-dbcp)"
	antflags="${antflags} -Dcommons-el.jar=$(java-pkg_getjars commons-el)"
	antflags="${antflags} -Dcommons-fileupload.jar=$(java-pkg_getjars commons-fileupload)"
	antflags="${antflags} -Dcommons-httpclient.jar=$(java-pkg_getjars commons-httpclient)"
	antflags="${antflags} -Dcommons-io.jar=$(java-pkg_getjars commons-io-1)"
	antflags="${antflags} -Dcommons-launcher.jar=$(java-pkg_getjars commons-launcher)"
	antflags="${antflags} -Dcommons-logging.jar=$(java-pkg_getjar commons-logging commons-logging.jar)"
	antflags="${antflags} -Dcommons-logging-api.jar=$(java-pkg_getjar commons-logging commons-logging-api.jar)"
	antflags="${antflags} -Dcommons-pool.jar=$(java-pkg_getjars commons-pool)"
	antflags="${antflags} -Dcommons-modeler.jar=$(java-pkg_getjars commons-modeler)"
	antflags="${antflags} -Djdt.jar=$(java-pkg_getjar eclipse-ecj-3.3 ecj.jar)"
	antflags="${antflags} -Djsp-api.jar=$(java-pkg_getjar tomcat-servlet-api-2.4 jsp-api.jar)"
	antflags="${antflags} -Djunit.jar=$(java-pkg_getjars junit)"
	antflags="${antflags} -Dlog4j.jar=$(java-pkg_getjars log4j)"
	antflags="${antflags} -Dmail.jar=$(java-pkg_getjar sun-javamail mail.jar)"
	antflags="${antflags} -Dsaxpath.jar=$(java-pkg_getjar saxpath saxpath.jar)"
	antflags="${antflags} -Dservlet-api.jar=$(java-pkg_getjar tomcat-servlet-api-2.4 servlet-api.jar)"
	if use admin; then
		antflags="${antflags} -Dstruts.jar=$(java-pkg_getjar struts-1.2 struts.jar)"
		antflags="${antflags} -Dstruts.home=/usr/share/struts"
	else
		antflags="${antflags} -Dadmin.build.notrequired=true"
		antflags="${antflags} -Dadmin.precompile.notrequired=true"
	fi
	if ! use examples; then
		antflags="${antflags} -Dexamples.build.notrequired=true"
		antflags="${antflags} -Dexamples.precompile.notrequired=true"
	fi
	antflags="${antflags} -Djasper.home=${S}/jasper"
	if ! use java5; then
		antflags="${antflags} -Dactivation.jar=$(java-pkg_getjars sun-jaf)"
		antflags="${antflags} -Djmx.jar=$(java-pkg_getjar mx4j-core-3.0 mx4j.jar)"
		antflags="${antflags} -Djmx-remote.jar=$(java-pkg_getjar mx4j-core-3.0 mx4j-rjmx.jar)"
		antflags="${antflags} -DxercesImpl.jar=$(java-pkg_getjar xerces-2 xercesImpl.jar)"
		antflags="${antflags} -Dxml-apis.jar=$(java-pkg_getjar xml-commons-external-1.3 xml-apis.jar)"
	fi

	eant ${antflags}
}

src_install() {
	cd "${S}"/build/build

	newinitd "${FILESDIR}"/${SLOT}/tomcat.init.3 ${TOMCAT_NAME}
	newconfd "${FILESDIR}"/${SLOT}/tomcat.conf.2 ${TOMCAT_NAME}

	# create dir structure
	diropts -m755 -o tomcat -g tomcat
	dodir /usr/share/${TOMCAT_NAME}
	keepdir /var/log/${TOMCAT_NAME}/
	keepdir /var/tmp/${TOMCAT_NAME}/
	keepdir /var/run/${TOMCAT_NAME}/

	local CATALINA_BASE=/var/lib/${TOMCAT_NAME}/
	dodir   ${CATALINA_BASE}
	keepdir ${CATALINA_BASE}/shared/lib
	keepdir ${CATALINA_BASE}/shared/classes

	keepdir /usr/share/${TOMCAT_NAME}/common/lib

	dodir   /etc/${TOMCAT_NAME}
	fperms  750 /etc/${TOMCAT_NAME}
	dodir /usr/share/${TOMCAT_NAME}/webapps

	diropts -m0755

	# we don't need dos scripts
	rm -f bin/*.bat

	# copy the admin context's to the right position
	mkdir -p conf/Catalina/localhost
	if use admin; then
		cp "${S}"/container/webapps/admin/admin.xml \
			conf/Catalina/localhost
	fi

	# make the jars available via java-pkg_getjar and jar-from, etc
	base=$(pwd)
	libdirs="common/lib server/lib"
	for dir in ${libdirs}
	do
		cd "${dir}"

		for jar in *.jar;
		do
			# replace the file with a symlink
			if [ ! -L ${jar} ]; then
				java-pkg_dojar ${jar}
				rm -f ${jar}
				ln -s ${DESTTREE}/share/${TOMCAT_NAME}/lib/${jar} ${jar}
			fi
		done

		cd ${base}
	done

	# replace a packed struts.jar
	if use admin; then
		cd server/webapps/admin/WEB-INF/lib
		rm -f struts.jar
		java-pkg_jar-from struts-1.2 struts.jar
		cd ${base}
	else
		rm -fR server/webapps/admin
	fi

	cd server/webapps/manager/WEB-INF/lib
	java-pkg_jar-from commons-fileupload
	java-pkg_jar-from commons-io-1
	cd ${base}

	# replace the default pw with a random one, see #92281
	local randpw=$(echo ${RANDOM}|md5sum|cut -c 1-15)
	sed -e s:SHUTDOWN:${randpw}: -i conf/{server,server-minimal}.xml

	# copy over the directories and fix permissions
	chown -R tomcat:tomcat webapps/* conf/*
	cp -pR conf/* "${D}"/etc/${TOMCAT_NAME} || die "failed to copy conf"
	cp -HR bin common server "${D}"/usr/share/${TOMCAT_NAME} || die "failed to copy"

	# replace catalina.policy with gentoo specific one bug #176701
	cp "${FILESDIR}"/${SLOT}/catalina.policy "${D}"/etc/${TOMCAT_NAME} || die "failed to replace catalina.policy"

	# symlink the directories to make CATALINA_BASE possible
	dosym /etc/${TOMCAT_NAME} ${CATALINA_BASE}/conf
	dosym /var/log/${TOMCAT_NAME} ${CATALINA_BASE}/logs
	dosym /var/tmp/${TOMCAT_NAME} ${CATALINA_BASE}/temp
	dosym /var/run/${TOMCAT_NAME} ${CATALINA_BASE}/work

	dodoc  "${S}"/build/{RELEASE-NOTES,RUNNING.txt}
	fperms 640 /etc/${TOMCAT_NAME}/tomcat-users.xml
	#Prep WEBAPPS_DIR
	keepdir ${WEBAPPS_DIR}
	set_webapps_perms "${D}"/${WEBAPPS_DIR}
	set_webapps_perms "${D}"/usr/share/${TOMCAT_NAME}/webapps

	# webapps get stored in /usr/share/${TOMCAT_NAME}/webapps
	cd "${S}"/build
	ebegin "Installing webapps to /usr/share/${TOMCAT_NAME}/"
	cp -pr build/webapps/{ROOT,balancer,webdav} "${D}"/usr/share/${TOMCAT_NAME}/webapps || die
	cd "${S}"
	cp -pr container/webapps/{host-manager,manager,jmxremote} \
	"${D}"/usr/share/${TOMCAT_NAME}/webapps || die
		if use admin; then
		cp -pr container/webapps/admin "${D}"/usr/share/${TOMCAT_NAME}/webapps || die
		fi
		if use doc; then
		cd "${S}"/build
		cp -pr build/docs "${D}"/usr/share/${TOMCAT_NAME}/docs
		fi
		if use examples; then
		cd "${S}"/build
		cp -pr build/webapps/{jsp-examples,servlets-examples,webdav} \
		"${D}"/usr/share/${TOMCAT_NAME}/webapps
		fi
}

pkg_postinst() {
	#due to previous ebuild bloopers, make sure everything is correct
	chown root:root /etc/init.d/${TOMCAT_NAME}
	chown root:root /etc/conf.d/${TOMCAT_NAME}

	#see #180519

	if [[ -e "${ROOT}/var/lib/${TOMCAT_NAME}/webapps/" ]] ; then
		elog "The latest webapps has NOT been installed into"
		elog "${ROOT}/var/lib/${TOMCAT_NAME}/webapps/ because the directory"
		elog "already exits"
		elog "and we do not want to overwrite any files you have put there."
		elog
		elog "Installing latest webroot into"
		elog "${ROOT}/usr/share/${TOMCAT_NAME}/webapps instead"
		elog
	else
		einfo "Installing webroot to ${WEBAPPS_DIR}"
		cp -prR  "${ROOT}"/usr/share/${TOMCAT_NAME}/webapps/* \
		"${ROOT}""${WEBAPPS_DIR}"
		cp "${ROOT}"/usr/share/${TOMCAT_NAME}/webapps/manager/manager.xml \
		"${ROOT}"/etc/${TOMCAT_NAME}/Catalina/localhost
	fi

	elog
	elog " This ebuild implements a new filesystem layout for tomcat"
	elog " please read http://www.gentoo.org/proj/en/java/tomcat-guide.xml"
	elog " for more information!."
	elog
	ewarn "naming-factory-dbcp.jar is not built at this time. Please fetch"
	ewarn "jar from upstream binary if you need it. Gentoo Bug # 144276"
	elog
	elog " Please file any bugs at http://bugs.gentoo.org/ or else it"
	elog " may not get seen.  Thank you."
	elog
	elog
	elog " To configure your TOMCAT home dir, please run"
	elog " emerge --config =${PF}"
	elog
}

#helpers
set_webapps_perms() {
	chown -R tomcat:tomcat ${1} || die "Failed to change owner off ${1}."
	chmod -R 750           ${1} || die "Failed to change permissions off ${1}."
}

pkg_config() {
	# Better suggestions are welcome
	local currentdir="$(getent passwd tomcat | gawk -F':' '{ print $6 }')"

	elog "The default home directory for Tomcat is /dev/null."
	elog "You need to change it if your applications needs it to"
	elog "be an actual directory. Current home directory:"
	elog "${currentdir}"
	elog ""
	elog "Do you want to change it [yes/no]?"

	local answer
	read answer

	if [[ "${answer}" == "yes" ]]; then
		elog ""
		elog "Suggestions:"
		elog "${WEBAPPS_DIR}"
		elog ""
		elog "If you want to suggest a directory, file a bug to"
		elog "http://bugs.gentoo.org"
		elog ""
		elog "Enter home directory:"

		local homedir
		read homedir

		elog ""
		elog "Setting home directory to: ${homedir}"

		/usr/sbin/usermod -d"${homedir}" tomcat

		elog "You can run emerge --config =${PF}"
		elog "again to change to homedir"
		elog "at any time."
	fi
}
