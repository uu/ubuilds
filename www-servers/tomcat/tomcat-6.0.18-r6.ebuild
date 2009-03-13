# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/tomcat/tomcat-6.0.18-r2.ebuild,v 1.1 2008/12/19 20:48:47 ali_bush Exp $

EAPI=1
JAVA_PKG_IUSE="doc source"
WANT_ANT_TASKS="ant-trax"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Tomcat Servlet-2.5/JSP-2.1 Container"

MY_P="apache-${P}-src"
SLOT="6"
SRC_URI="mirror://apache/${PN}/${PN}-6/v${PV/_/-}/src/${MY_P}.tar.gz"
HOMEPAGE="http://tomcat.apache.org/"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
LICENSE="Apache-2.0"

IUSE="examples test"

COMMON_DEPEND="dev-java/eclipse-ecj:3.3
	dev-java/ant-eclipse-ecj:3.3
	>=dev-java/commons-daemon-1.0.1
	>=dev-java/commons-dbcp-1.2.1
	>=dev-java/commons-logging-1.1
	>=dev-java/commons-pool-1.2
	~dev-java/tomcat-servlet-api-${PV}
	examples? ( dev-java/jakarta-jstl )"

RDEPEND=">=virtual/jre-1.5
	dev-java/ant-core
	${COMMON_DEPEND}"

DEPEND=">=virtual/jdk-1.5
	${COMMON_DEPEND}
	test? ( =dev-java/junit-3.8* )"

S=${WORKDIR}/${MY_P}

#Extra Vars
TOMCAT_NAME="${PN}-${SLOT}"
TOMCAT_HOME="/usr/share/${TOMCAT_NAME}"
WEBAPPS_DIR="/var/lib/${TOMCAT_NAME}/webapps"

pkg_setup() {
	java-pkg-2_pkg_setup
	enewgroup tomcat 265
	enewuser tomcat 265 -1 /dev/null tomcat
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${SLOT}/build-xml.patch"

	use examples && epatch "${FILESDIR}/${SLOT}/examples-cal.patch"

	cd "${S}/webapps/examples/WEB-INF/lib/"
	rm -v *.jar || die
}

src_compile(){
	# Fix for bug # 178980
	if use amd64 && [[ "${GENTOO_VM}" = "sun-jdk-1.5" ]] ; then
	        java-pkg_force-compiler ecj-3.3
	fi

	local antflags="build-jasper-jdt deploy -Dbase.path=${T}"
	antflags="${antflags} -Dcompile.debug=false"
	if ! use doc; then
		antflags="${antflags} -Dnobuild.docs=true"
	fi
	antflags="${antflags} -Dant.jar=$(java-pkg_getjar ant-core ant.jar)"
	antflags="${antflags} -Dcommons-daemon.jar=$(java-pkg_getjar commons-daemon commons-daemon.jar)"
	antflags="${antflags} -Djdt.jar=$(java-pkg_getjar eclipse-ecj-3.3 ecj.jar)"
	antflags="${antflags} -Djsp-api.jar=$(java-pkg_getjar tomcat-servlet-api-2.5 jsp-api.jar)"
	antflags="${antflags} -Dservlet-api.jar=$(java-pkg_getjar tomcat-servlet-api-2.5 servlet-api.jar)"
	antflags="${antflags} -Dversion=${PV} -Dversion.number=${PV}"
	eant ${antflags}
}

src_install() {
	cd "${S}/output/build/bin"
	rm -f *.bat commons-daemon.jar
	java-pkg_jar-from commons-daemon
	chmod 755 *.sh

	# register jars per bug #171496
	cd "${S}/output/build/lib/"
	for jar in *.jar; do
		java-pkg_dojar ${jar}
	done

	local CATALINA_BASE=/var/lib/${TOMCAT_NAME}/

	# init.d
	newinitd "${FILESDIR}"/${SLOT}/tomcat.init.2 ${TOMCAT_NAME}
	#conf.d
	newconfd "${FILESDIR}"/${SLOT}/tomcat.conf ${TOMCAT_NAME}

	# create dir structure
	dodir /usr/share/${TOMCAT_NAME}
	dodir /usr/share/${TOMCAT_NAME}/webapps

	diropts -m750 -o tomcat -g tomcat
	dodir   /etc/${TOMCAT_NAME}
	keepdir ${WEBAPPS_DIR}

	diropts -m755 -o tomcat -g tomcat
	dodir   ${CATALINA_BASE}

	diropts -m775 -o tomcat -g tomcat
	dodir   /etc/${TOMCAT_NAME}/Catalina/localhost
	keepdir /var/log/${TOMCAT_NAME}/
	keepdir /var/run/${TOMCAT_NAME}/
	keepdir /var/tmp/${TOMCAT_NAME}/

	cd "${S}"
	# fix context's so webapps will be deployed
	sed -i -e 's:Context a:Context docBase="${catalina.home}/webapps/host-manager"  a:' "${S}"/webapps/host-manager/META-INF/context.xml
	sed -i -e 's:Context a:Context docBase="${catalina.home}/webapps/manager"  a:' "${S}"/webapps/manager/META-INF/context.xml

	# replace the default pw with a random one, see #92281
	local randpw=$(echo ${RANDOM}|md5sum|cut -c 1-15)
	sed -e s:SHUTDOWN:${randpw}: -i conf/server.xml

	# copy over the directories
	chown -R tomcat:tomcat webapps/* conf/*
	cp -pR conf/* "${D}"/etc/${TOMCAT_NAME} || die "failed to copy conf"
	cp -pPR output/build/bin "${D}"/usr/share/${TOMCAT_NAME} \
		|| die "failed to copy"
	# webapps get stored in /usr/share/${TOMCAT_NAME}/webapps
	cd "${S}"/webapps
	ebegin "Installing webapps to /usr/share/${TOMCAT_NAME}"
	cp -pR ROOT "${D}"/usr/share/${TOMCAT_NAME}/webapps || die
	cp -pR host-manager "${D}"/usr/share/${TOMCAT_NAME}/webapps || die
	cp -pR manager "${D}"/usr/share/${TOMCAT_NAME}/webapps || die
		if use doc; then
		cp -pR docs "${D}"/usr/share/${TOMCAT_NAME}/webapps || die
		fi
		if use examples; then
		cd "${S}"/webapps/examples/WEB-INF/lib
		java-pkg_jar-from jakarta-jstl jstl.jar
		java-pkg_jar-from jakarta-jstl standard.jar
		cd "${S}"/webapps
		cp -pR examples "${D}"/usr/share/${TOMCAT_NAME}/webapps || die
		fi
		# replace catalina.policy with gentoo specific one bug #176701
#	cp ${FILESDIR}/${SLOT}/catalina.policy "${D}"/etc/${TOMCAT_NAME} \
#		|| die "failed to replace catalina.policy"

	cp "${T}"/tomcat6-deps/jdt/jasper-jdt.jar "${D}"/usr/share/${TOMCAT_NAME}/lib \
		|| die "failed to copy"

	cd "${D}/usr/share/${TOMCAT_NAME}/lib"
	java-pkg_jar-from tomcat-servlet-api-2.5

	# symlink the directories to make CATALINA_BASE possible
	dosym /etc/${TOMCAT_NAME} ${CATALINA_BASE}/conf
	dosym /var/log/${TOMCAT_NAME} ${CATALINA_BASE}/logs
	dosym /var/tmp/${TOMCAT_NAME} ${CATALINA_BASE}/temp
	dosym /var/run/${TOMCAT_NAME} ${CATALINA_BASE}/work

	dodoc  "${S}"/{RELEASE-NOTES,RUNNING.txt}
	fperms 640 /etc/${TOMCAT_NAME}/tomcat-users.xml
}

pkg_postinst() {
	ewarn "Changing ownership recursively on /etc/${TOMCAT_NAME}"
	# temp fix for bug #176097
	chown -fR tomcat:tomcat /etc/${TOMCAT_NAME}
	ewarn "Owner ship changed to tomcat:tomcat. Temp hack/fix."
	#see #180519

	if [[ -e "${ROOT}/var/lib/${TOMCAT_NAME}/webapps/ROOT" ]] ; then
		elog "The latest webapp has NOT been installed into"
		elog "${ROOT}/var/lib/${TOMCAT_NAME}/webapps/ because directory already exists"
		elog "and we do not want to overwrite any files you have put there."
		elog
		elog "Installing latest webapp into"
		elog "${ROOT}/usr/share/${TOMCAT_NAME}/webapps instead"
		elog
		elog "Manager Symbolic Links NOT created."
	else
		einfo "Installing latest webroot to ${ROOT}/${WEBAPPS_DIR}"
		cp -pR "${ROOT}"/usr/share/${TOMCAT_NAME}/webapps/* \
		"${ROOT}""${WEBAPPS_DIR}"
	# link the manager's context to the right position
	dosym ${TOMCAT_HOME}/webapps/host-manager/META-INF/context.xml /etc/${TOMCAT_NAME}/Catalina/localhost/host-manager.xml
	dosym ${TOMCAT_HOME}/webapps/manager/META-INF/context.xml /etc/${TOMCAT_NAME}/Catalina/localhost/manager.xml
	fi

	elog
	elog " This ebuild implements a FHS compliant layout for tomcat"
	elog " Please read http://www.gentoo.org/proj/en/java/tomcat6-guide.xml"
	elog " for more information."
	elog
	ewarn "tomcat-dbcp.jar is not built at this time. Please fetch jar"
	ewarn "from upstream binary if you need it. Gentoo Bug # 144276"
	elog
	ewarn "The manager webapps have known exploits, please refer to"
	ewarn "http://cve.mitre.org/cgi-bin/cvename.cgi?name=2007-2450"
	if use examples ; then
		elog
		ewarn "The examples webapp has a known exploit, please refer to"
		ewarn "http://cve.mitre.org/cgi-bin/cvename.cgi?name=2007-2449"
	fi
	elog
	elog "Eclipse-SDK plugin for ${P} does not respect split CATALINA_HOME AND"
	elog "CATALINA BASE"
	elog "Please see Gentoo Bug # 170292 for more info"
	elog
	elog "Please report any bugs to http://bugs.gentoo.org/"
	elog

	elog "Execute the following command to setup ${P} to work with 'dev-util/netbeans:6.5'"
	elog
	elog "emerge --config =${CATEGORY}/${PF}"
	elog
}

pkg_config() {
	#Make user aware of what this config is doing
	einfo "This Configure will setup your ${P} to be used within dev-util/netbeans:6.5"
	einfo "You will still have to manually add ${TOMCAT_NAME} to your Project"
	einfo
	einfo "Do you still wish to continue? (Y/n)"
	read answer
	[ -z $answer ] && answer=Y
	[ "$answer" == "Y" ] || [ "$answer" == "y" ] || die "aborted"

	einfo "Checking Netbeans Setup ..."
	einfo
	# check for Netbeans
	if ! has_version dev-util/netbeans:6.5 ; then
		eerror "Can't configure Tomcat for Netbeans without Netbeans!"
		eerror "Please 'emerge dev-util/netbeans:6.5"
	fi

	# make sure all Java EE NB Modules are installed to prevent
	# ClassDefNotFoundError
	if ! built_with_use dev-util/netbeans:6.5 netbeans_modules_j2ee ; then
	   eerror "Please rebuild 'dev-util/netbeans:6.5 with NETBEAN_MODULES='j2ee
	   mobility groovy gsf'"
	   die "Netbeans lacks required Modules for EE deployment"
	fi

	#add netbeans run user to tomcat group to prevent permission issues
	einfo "Please enter the user that runs 'dev-util/netbeans:6.5': "
	read user
	if [ "$user" == "root" ] || [ -z $user ] ; then
		eerror "This is not meant for user: 'root'"
		die "bad User"
	else
		gpasswd -a $user tomcat || die "failed to add user to group"
	fi

	#need to check ENV Vars
	source /etc/conf.d/${TOMCAT_NAME} || die "unable to source conf.d file"

	#Output and Check that that User is happy with Tomcat setup
	einfo
	einfo "Your ${TOMCAT_NAME} Configuration:(Please note these values)"
	einfo
	einfo "CATALINA_HOME = ${CATALINA_HOME}"
	einfo "CATALINA_BASE = ${CATALINA_BASE}"
	einfo "CATALINA_LIBDIR = ${CATALINA_LIBDIR}"
	einfo "CATALINA_TMPDIR = ${CATALINA_TMPDIR}"
	ewarn
	ewarn "Edit Runtime ops inside NetBeans Services"
	ewarn
	einfo
	einfo "${TOMCAT_NAME} runs as ${CATALINA_USER} : ${CATALINA_GROUP}"
	ewarn "If you plan on changing those, you are on your own"
	einfo
	einfo "Would you still like to continue? (Y/n)"
	read answer
	[ -z $answer ] && answer=Y
	[ "$answer" == "Y" ] || [ "$answer" == "y" ] || die "aborted"
	#Warn user about changing conf.d file
	ewarn
	ewarn "Changing the ${TOMCAT_NAME}  conf.d file AFTER you have setup NetBeans"
	ewarn "could result in runtime failure"
	ewarn
	sleep 5 #Make sure that ewarn is read

	einfo "Checking ${TOMCAT_NAME} Symlinks for Breakage ..."
	#Check Tomcat Symlink Breakage, important for Split Tomcat
	test -h ${CATALINA_BASE}/conf || die "bad tomcat-conf symlink"
	test -h ${CATALINA_BASE}/logs || die "bad tomcat-logs symlink"
	test -h ${CATALINA_BASE}/temp || die "bad tomcat-temp symlink"
	test -h ${CATALINA_BASE}/work || die "bad tomcat-work symlink"

	#NB Private Configuration does not read  server.xml from CATALINA_BASE
	#See http://www.netbeans.org/issues/show_bug.cgi?id=156913
	dosym /etc/${TOMCAT_NAME} ${CATALINA_HOME}/conf || die "failed to make extra sym"

	#Output Inside-Netbeans final steps, including external info
	einfo
	einfo "You are now ready to start 'dev-util/netbeans:6.5' and add "
	einfo "${TOMCAT_NAME} to Server Node"
	einfo
	sleep 2 #wait
	einfo "Please follow these instructions for FINAL configuration:"
	sleep 2 #wait
	einfo
	einfo "Please add a User/Password to the tomcat-users.xml file"
	einfo
	einfo "Please consult link for more info: "
	einfo "http://tomcat.apache.org/tomcat-6.0-doc/realm-howto.html#DigestedPasswords"
	einfo
	einfo "Open up the 'Runtime Tab'. "
	einfo
	einfo "Right click on the 'Servers Node' and in the contexts menu select on Add Server."
	einfo
	einfo "Select ${TOMCAT_NAME}"
	einfo
	einfo "In the 'Tomcat Server Instance Properties' window enter: "
	einfo
	einfo "both 'Catalina Home' and 'Catalina Base' fields."
	einfo
	einfo "Enter the Username/Password that you inserted in the the "
	einfo "tomcat-users.xml"
	einfo
	einfo "Click Finish, you should now be able to see ${TOMCAT_NAME} as an added Server"
	einfo
	einfo "For More Info, Please See:"
	einfo "http://wiki.netbeans.org/AddExternalTomcat"
}
