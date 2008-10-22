# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/netbeans/netbeans-5.5-r4.ebuild,v 1.1 2007/01/28 19:40:16 fordfrog Exp $

EAPI=1
WANT_SPLIT_ANT="true"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="NetBeans IDE for Java"
HOMEPAGE="http://www.netbeans.org"

SLOT="6.5"
SRC_URI="http://download.netbeans.org/netbeans/6.5/rc/zip/netbeans-6.5rc1-200810171318-src.zip"

LICENSE="CDDL"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE_NETBEANS="apisupport cnd groovy gsf harness ide identity j2ee java mobility nb php profiler ruby soa visualweb webcommon websvccommon xml"
IUSE="+apisupport cnd debug doc groovy gsf +harness +ide identity j2ee +java mobility +nb php profiler ruby soa visualweb webcommon websvccommon xml linguas_ja linguas_pt_BR linguas_zh_CN"

RDEPEND=">=virtual/jdk-1.5
	>=dev-java/ant-core-1.7.1_beta2
	harness? (
		>=dev-java/javahelp-2:0
	)
	ide? (
		>=dev-java/commons-logging-1.1:0
		>=dev-java/commons-net-1.4:0
		>=dev-java/flyingsaucer-7:0
		>=dev-java/freemarker-2.3.8:2.3
		>=dev-java/ini4j-0.2.6:0
		>=dev-java/jakarta-oro-2:2.0
		>=dev-java/jaxb-2:2
		>=dev-java/jdbc-mysql-5.1:0
		>=dev-java/jdbc-postgresql-8.3_p603:0
		>=dev-java/jsch-0.1.24:0
		dev-java/jsr173:0
		>=dev-java/lucene-2.2:2
		dev-java/sun-jaf:0
		~dev-java/tomcat-servlet-api-3:2.2
		>=dev-java/xerces-2.8.1:2
	)
	j2ee? (
		>=dev-java/antlr-2.7.6:0
		>=dev-java/asm-3.1:3
		dev-java/commons-beanutils:1.7
		dev-java/commons-collections:0
		dev-java/commons-digester:0
		>=dev-java/commons-fileupload-1:0
		>=dev-java/commons-logging-1.1:0
		dev-java/commons-validator:0
		>=dev-java/httpunit-1.6:0
		dev-java/jakarta-jstl:0
		>=dev-java/jakarta-oro-2:2.0
		dev-java/jdom:1.0
		dev-java/rome:0
	)
	java? (
		>=dev-java/ant-1.7:0
		>=dev-java/antlr-2.7.6:0
		>=dev-java/appframework-1:0
		dev-java/asm:2.2
		>=dev-java/beansbinding-1.2.1:0
		>=dev-java/cglib-2.1:2.1
		dev-java/commons-collections:0
		>=dev-java/dom4j-1.6:1
		dev-java/ehcache:1.4
		dev-java/fastinfoset:0
		dev-java/glassfish-persistence:0
		dev-java/glassfish-transaction-api:0
		dev-java/hibernate:3.2
		dev-java/hibernate-annotations:3.2
		dev-java/hibernate-entitymanager:3.2
		dev-java/javassist:3
		dev-java/jax-ws:2
		dev-java/jax-ws-api:2
		dev-java/jax-ws-tools:2
		dev-java/jdbc2-stdext:0
		dev-java/jsr181:0
		dev-java/jsr250:0
		dev-java/jsr67:0
		dev-java/jtidy:0
		>=dev-java/junit-3.8.2:0
		dev-java/saaj:0
		dev-java/sjsxp:0
		dev-java/stax-ex:0
		dev-java/toplink-essentials:0
		dev-java/xmlstreambuffer:0
	)
	mobility? (
		>=dev-java/ant-contrib-1.0_beta:0
		dev-java/bcprov:0
		>=dev-java/commons-codec-1.3:0
		dev-java/commons-httpclient:3
		dev-java/jdom:1.0
		>=dev-java/proguard-4.2:0
	)
	php? (
		>=dev-java/javacup-0.11a_beta20060608
	)
	soa? (
		dev-java/jsr173:0
		dev-java/wsdl4j:0
		dev-java/xml-xmlbeans:1
	)
	xml? (
		>=dev-java/commons-jxpath-1.1:0
		dev-java/prefuse:2006
	)"

DEPEND="=virtual/jdk-1.5*
	app-arch/unzip
	>=dev-java/ant-core-1.7.1_beta2
	>=dev-java/ant-nodeps-1.7.1
	>=dev-java/javahelp-2:0
	>=dev-java/jna-3:0
	dev-java/jsr223:0
	>=dev-java/junit-4:4
	>=dev-java/swing-layout-1:1
	gsf? (
		>=dev-java/flute-1.3:0
		>=dev-java/sac-1.3:0
	)
	ide? (
		>=dev-java/commons-logging-1.1:0
		>=dev-java/commons-net-1.4:0
		>=dev-java/flyingsaucer-7:0
		>=dev-java/freemarker-2.3.8:2.3
		>=dev-java/ini4j-0.2.6:0
		>=dev-java/jakarta-oro-2:2.0
		>=dev-java/javacc-3.2:0
		>=dev-java/jaxb-2:2
		>=dev-java/jaxb-tools-2:2
		>=dev-java/jdbc-mysql-5.1:0
		>=dev-java/jdbc-postgresql-8.3_p603:0
		>=dev-java/jsch-0.1.24:0
		dev-java/jsr173:0
		>=dev-java/lucene-2.2:2
		dev-java/sun-jaf:0
		~dev-java/tomcat-servlet-api-3:2.2
		>=dev-java/xerces-2.8.1:2
	)
	j2ee? (
		>=dev-java/commons-fileupload-1:0
		>=dev-java/httpunit-1.6:0
		dev-java/jakarta-jstl:0
		dev-java/tomcat-servlet-api:2.3
	)
	java? (
		>=dev-java/appframework-1:0
		>=dev-java/beansbinding-1.2.1:0
		>=dev-java/cglib-2.1:2.1
		>=dev-java/junit-3.8.2:0
	)
	mobility? (
		>=dev-java/ant-contrib-1.0_beta:0
		dev-java/bcprov:0
		>=dev-java/commons-codec-1.3:0
		dev-java/commons-httpclient:3
		>=dev-java/jakarta-slide-webdavclient-2.1:0
		dev-java/jdom:1.0
		>=dev-java/proguard-4.2:0
	)
	php? (
		>=dev-java/javacup-0.11a_beta20060608
	)
	soa? (
		>=dev-java/itext-2:0
	)
	xml? (
		>=dev-java/commons-jxpath-1.1:0
		dev-java/prefuse:2006
	)"

S="${WORKDIR}"
BUILDDESTINATION="${S}/nbbuild/netbeans"
ENTERPRISE="5"
IDE_VERSION="10"
PLATFORM="9"
MY_FDIR="${FILESDIR}/${SLOT}"
DESTINATION="/usr/share/netbeans-${SLOT}"
JAVA_PKG_BSFIX="off"

pkg_setup() {
	if use doc ; then
		ewarn "Currently building with 'doc' USE flag fails, see bugs http://www.netbeans.org/issues/show_bug.cgi?id=109722 http://www.netbeans.org/issues/show_bug.cgi?id=107510"
	fi

	if use apisupport && ! ( use harness && use ide && use java ) ; then
		eerror "'apisupport' USE flag requires 'harness', 'ide' and 'java' USE flags"
		exit 1
	fi

	if use cnd && ! use ide ; then
		eerror "'cnd' USE flag requires 'ide' USE flag"
		exit 1
	fi

	if use groovy && ! (use gsf && use ide && use java ) ; then
		eerror "'groovy' USE flag requires 'gsf', 'ide' and 'java'"
		exit 1
	fi

	if use gsf && ! use ide ; then
		eerror "'gsf' USE flag requires 'ide' USE flag"
		exit 1
	fi

	if use identity && ! ( use gsf && use ide && use j2ee && use java ) ; then
		eerror "'identity' USE flag requires 'gsf', 'ide', 'j2ee' and 'java' USE flags"
		exit 1
	fi

	if use j2ee && ! ( use groovy && use gsf && use ide && use java ) ; then
		eerror "'j2ee' USE flag requires 'groovy', 'gsf', 'ide' and 'java' USE flags"
		exit 1
	fi

	if use java && ! ( use ide && use websvccommon ) ; then
		eerror "'java' USE flag requires 'ide' and 'websvccommon' USE flag"
		exit 1
	fi

	# because of failure with "No dependent module org.netbeans.api.web.webmodule", it seems
	# j2ee cluster is also needed to build mobility cluster
	if use mobility && ! ( use ide && use j2ee && use java ) ; then
		eerror "'mobility' USE flag requires 'ide', 'j2ee' and 'java' USE flags"
		exit 1
	fi

	if use nb && ! ( use harness && use ide ) ; then
		eerror "'nb' USE flag requires 'harness' and 'ide' USE flag"
		exit 1
	fi

	if use php && ! ( use gsf && use ide && use websvccommon ) ; then
		eerror "'php' USE flag requires 'gsf', 'ide' and 'websvccommon' USE flags"
		exit 1
	fi

	if use profiler && ! ( use gsf && use ide && use j2ee && use java ) ; then
		eerror "'profiler' USE flag requires 'gsf', 'ide', 'j2ee' and 'java' USE flags"
		exit 1
	fi

	if use ruby && ! ( use gsf && use ide ) ; then
		eerror "'ruby' USE flag requires 'gsf' and 'ide' USE flag"
		exit 1
	fi

	if use soa && ! ( use gsf && use ide && use j2ee && use java && use xml ) ; then
		eerror "'soa' USE flag requires 'gsf', 'ide', 'j2ee', 'java' and 'xml' USE flags"
		exit 1
	fi

	if use visualweb && ! ( use gsf && use ide && use j2ee && use java ) ; then
		eerror "'visualweb' USE flag requires 'gsf', 'ide', 'j2ee' and 'java' USE flags"
		exit 1
	fi

	if use webcommon && ! ( use gsf && use ide ) ; then
		eerror "'webcommon' USE flag requires 'gsf' and 'ide' USE flags"
		exit 1
	fi

	if use websvccommon && ! use ide ; then
		eerror "'websvccommon' USE flag requires 'ide' USE flag"
		exit 1
	fi

	if use xml && ! use ide ; then
		eerror "'xml' USE flag requires 'ide' USE flag"
		exit 1
	fi

	java-pkg-2_pkg_setup
}

src_unpack () {
	unpack ${A}

	epatch ${FILESDIR}/${SLOT}/nbbuild_build.xml.patch \
		${FILESDIR}/${SLOT}/nbbuild_templates_projectized.xml.patch \
		${FILESDIR}/${SLOT}/nbbuild_cluster.properties.patch

	# Clean up nbbuild
	einfo "Removing prebuilt *.class files from nbbuild"
	find "${S}" -name "*.class" -delete

	if [ -z "${JAVA_PKG_NB_USE_BUNDLED}" ] ; then
		place_unpack_symlinks
	fi

	# We do not remove jars that we are not able to replace atm
	if [ -n "${JAVA_PKG_NB_REMOVE_BUNDLED}" ] ; then
		local tmpfile="${T}/bundled.txt"

		einfo "Removing rest of the bundled jars..."
		find "${S}" -type f -name "*.jar" > ${tmpfile} || die "Cannot put jars in tmp file"

		if use groovy ; then
			local tmpfilegroovy="${T}/bundled-groovy.txt"
			cat ${tmpfile} | grep -v "groovy.editor/external/groovy-all-1.5.6.jar" > ${tmpfilegroovy}
			mv ${tmpfilegroovy} ${tmpfile}
		fi

		if use ide ; then
			local tmpfileide="${T}/bundled-ide.txt"
			cat ${tmpfile} | grep -v "libs.jaxb/external/jaxb-xjc.jar" | \
				grep -v "libs.jaxb/external/jaxb-impl.jar" | \
				grep -v "libs.svnClientAdapter/external/svnjavahl-1.5.0.jar" | \
				grep -v "libs.svnClientAdapter/external/svnClientAdapter-1.4.0.jar" | \
				grep -v "o.apache.xml.resolver/external/resolver-1.2.jar" | \
				grep -v "libs.javacapi/external/javac-api-nb-7.0-b07.jar" | \
				grep -v "httpserver/external/tomcat-webserver-3.2.jar" > ${tmpfileide}
			mv ${tmpfileide} ${tmpfile}
		fi

		if use j2ee ; then
			local tmpfilej2ee="${T}/bundled-j2ee.txt"
			cat ${tmpfile} | grep -v "j2eeapis/external/jsr88javax.jar" | \
				grep -v "servletjspapi/external/servlet2.5-jsp2.1-api.jar" | \
				grep -v "web.jspparser/external/glassfish-jspparser-2.0.jar" | \
				grep -v "j2ee.sun.appsrv81/external/appservapis-2.0.58.3.jar" | \
				grep -v "j2ee.sun.appsrv81/external/org-netbeans-modules-j2ee-sun-appsrv81.jar" | \
				grep -v "libs.glassfish_logging/external/glassfish-logging-2.0.jar" | \
				grep -v "spring.webmvc/external/spring-webmvc-2.5.jar" | \
				grep -v "web.jsf/external/shale-remoting-1.0.4.jar" > ${tmpfilej2ee}
			mv ${tmpfilej2ee} ${tmpfile}
		fi

		if use java ; then
			local tmpfilejava="${T}/bundled-java.txt"
			cat ${tmpfile} | grep -v "libs.javacimpl/external/javac-impl-nb-7.0-b07.jar" | \
				grep -v "j2ee.toplinklib/external/glassfish-persistence-v2ur1-build-09d.jar" | \
				grep -v "junit/external/Ant-1.7.1-binary-patch-72080.jar" |
				grep -v "libs.springframework/external/spring-2.5.jar" > ${tmpfilejava}
			mv ${tmpfilejava} ${tmpfile}
		fi

		if use mobility ; then
			local tmpfilemobility="${T}/bundled-mobility.txt"
			cat ${tmpfile} | grep -v "o.n.mobility.lib.activesync/external/nbactivesync-5.0.jar" | \
				grep -v "j2me.cdc.project.bdj/external/security.jar" | \
				grep -v "j2me.cdc.project.bdj/external/bdjo.jar" | \
				grep -v "j2me.cdc.project.ricoh/external/RicohAntTasks-2.0.jar" | \
				grep -v "mobility.databindingme/lib/netbeans_databindingme.jar" | \
				grep -v "mobility.databindingme/lib/netbeans_databindingme_pim.jar" | \
				grep -v "mobility.databindingme/lib/netbeans_databindingme_svg.jar" | \
				grep -v "mobility.deployment.webdav/external/jakarta-slide-ant-webdav-2.1.jar" | \
				grep -v "mobility.j2meunit/external/jmunit4cldc11-1.1.0.jar" | \
				grep -v "mobility.j2meunit/external/jmunit4cldc10-1.1.0.jar" | \
				grep -v "svg.perseus/external/perseus-nb-1.0.jar" | \
				grep -v "vmd.components.midp/netbeans_midp_components_basic/dist/netbeans_midp_components_basic.jar" | \
				grep -v "vmd.components.midp.pda/netbeans_midp_components_pda/dist/netbeans_midp_components_pda.jar" | \
				grep -v "vmd.components.midp.wma/netbeans_midp_components_wma/dist/netbeans_midp_components_wma.jar" | \
				grep -v "vmd.components.svg/nb_svg_midp_components/dist/nb_svg_midp_components.jar" > ${tmpfilemobility}
			mv ${tmpfilemobility} ${tmpfile}
		fi

		if use soa ; then
			local tmpfilesoa="${T}/bundled-soa.txt"
			cat ${tmpfile} | grep -v "bpel.debugger.bdi/external/bdi-1.0.0.jar" | \
				grep -v "o.n.soa.libs.jgo/external/JGoLayout5.1.jar" | \
				grep -v "o.n.soa.libs.jgo/external/JGo5.1.jar" | \
				grep -v "o.n.soa.libs.jgo/external/JGoInstruments5.1.jar" > ${tmpfilesoa}
			mv ${tmpfilesoa} ${tmpfile}
		fi

		if use xml ; then
			local tmpfilexml="${T}/bundled-xml.txt"
			cat ${tmpfile} | grep -v "libs.jxpath/external/jxpath1.1.jar" | \
				grep -v "o.n.soa.libs.jbiadmincommon/external/jbi-admin-common.jar" > ${tmpfilexml}
			mv ${tmpfilexml} ${tmpfile}
		fi

		cat ${tmpfile} | xargs rm -v
	fi
}

src_compile() {
	local antflags="-Dstop.when.broken.modules=true"

	if use debug; then
		antflags="${antflags} -Dbuild.compiler.debug=true"
		antflags="${antflags} -Dbuild.compiler.deprecation=true"
	else
		antflags="${antflags} -Dbuild.compiler.deprecation=false"
	fi

	local clusters="-Dnb.clusters.list=nb.cluster.platform"
	use apisupport && clusters="${clusters},nb.cluster.apisupport"
	use cnd && clusters="${clusters},nb.cluster.cnd"
	use groovy && clusters="${clusters},nb.cluster.groovy"
	use gsf && clusters="${clusters},nb.cluster.gsf"
	use harness && clusters="${clusters},nb.cluster.harness"
	use ide && clusters="${clusters},nb.cluster.ide"
	use identity && clusters="${clusters},nb.cluster.identity"
	use j2ee && clusters="${clusters},nb.cluster.j2ee"
	use java && clusters="${clusters},nb.cluster.java"
	use mobility && clusters="${clusters},nb.cluster.mobility"
	use nb && clusters="${clusters},nb.cluster.nb"
	use php && clusters="${clusters},nb.cluster.php"
	use profiler && clusters="${clusters},nb.cluster.profiler"
	use ruby && clusters="${clusters},nb.cluster.ruby"
	use soa && clusters="${clusters},nb.cluster.soa"
	use webcommon && clusters="${clusters},nb.cluster.webcommon"
	use websvccommon && clusters="${clusters},nb.cluster.websvccommon"
	use xml && clusters="${clusters},nb.cluster.xml"

	# Fails to compile
	java-pkg_filter-compiler ecj-3.1 ecj-3.2

	# Build the clusters
	use ruby && addpredict /root/.jruby
	ANT_TASKS="ant-nodeps"
	#use cnd && ANT_TASKS="${ANT_TASKS} antlr-netbeans-cnd"
	ANT_OPTS="-Xmx1g -Djava.awt.headless=true" eant ${antflags} ${clusters} -f nbbuild/build.xml build-nozip

	use linguas_de && compile_locale_support "${antflags}" "${clusters}" de
	use linguas_es && compile_locale_support "${antflags}" "${clusters}" es
	use linguas_ja && compile_locale_support "${antflags}" "${clusters}" ja
	use linguas_pt_BR && compile_locale_support "${antflags}" "${clusters}" pt_BR
	use linguas_sq && compile_locale_support "${antflags}" "${clusters}" sq
	use linguas_zh_CN && compile_locale_support "${antflags}" "${clusters}" zh_CN

	# Running build-javadoc from the same command line as build-nozip doesn't work
	# so we must run it separately
	if use doc ; then
		#! use testtools && ANT_TASKS="${ANT_TASKS} ant-trax"
		ANT_OPTS="-Xmx1g" eant ${antflags} ${clusters} build-javadoc
	fi

	# Remove non-Linux binaries
	find ${BUILDDESTINATION} -type f \
		-name "*.exe" -o \
		-name "*.cmd" -o \
		-name "*.bat" -o \
		-name "*.dll"	  \
		| xargs rm -f

	# Removing external stuff. They are api docs from external libs.
	rm -f ${BUILDDESTINATION}/ide${IDE_VERSION}/docs/*.zip

	# Remove zip files from generated javadocs.
	rm -f ${BUILDDESTINATION}/javadoc/*.zip

	# Use the system ant
	if use ide ; then
		cd ${BUILDDESTINATION}/java2/ant || die "Cannot cd to ${BUILDDESTINATION}/ide${IDE_VERSION}/ant"
		rm -fr lib
		rm -fr bin
	fi

	# Set initial default jdk
	if [[ -e ${BUILDDESTINATION}/etc/netbeans.conf ]]; then
		echo "netbeans_jdkhome=\"\$(java-config -O)\"" >> ${BUILDDESTINATION}/etc/netbeans.conf
	fi

	# Install Gentoo Netbeans ID
	echo "NBGNT" > ${BUILDDESTINATION}/nb${SLOT}/config/productid || die "Could not set Gentoo Netbeans ID"

	# fix paths per bug# 163483
	if [[ -e ${BUILDDESTINATION}/bin/netbeans ]]; then
		sed -i -e 's:"$progdir"/../etc/:/etc/netbeans-6.5/:' ${BUILDDESTINATION}/bin/netbeans
		sed -i -e 's:"${userdir}"/etc/:/etc/netbeans-6.5/:' ${BUILDDESTINATION}/bin/netbeans
	fi
}

src_install() {
	insinto ${DESTINATION}

	einfo "Installing the program..."
	cd ${BUILDDESTINATION}
	doins -r *

	# Remove the build helper files
	rm -f "${D}"/${DESTINATION}/nb.cluster.*
	rm -f "${D}"/${DESTINATION}/*.built
	rm -f "${D}"/${DESTINATION}/moduleCluster.properties
	rm -f "${D}"/${DESTINATION}/module_tracking.xml
	rm -f "${D}"/${DESTINATION}/build_info

	# Change location of etc files
	if [[ -e ${BUILDDESTINATION}/etc ]]; then
		insinto /etc/${PN}-${SLOT}
		doins ${BUILDDESTINATION}/etc/*
		rm -fr "${D}"/${DESTINATION}/etc
		dosym /etc/${PN}-${SLOT} ${DESTINATION}/etc
	fi

	# Replace bundled jars with system jars - currently commented out
	symlink_extjars

	# Correct permissions on executables
	local nbexec_exe="${DESTINATION}/platform${PLATFORM}/lib/nbexec"
	fperms 775 ${nbexec_exe} || die "Cannot update perms on ${nbexec_exe}"
	if [[ -e "${D}"/${DESTINATION}/bin/netbeans ]] ; then
		local netbeans_exe="${DESTINATION}/bin/netbeans"
		fperms 755 ${netbeans_exe} || die "Cannot update perms on ${netbeans_exe}"
	fi
	if use ruby ; then
		local ruby_path="${DESTINATION}/ruby2/jruby-1.1.4/bin"
		cd "${D}"/${ruby_path} || die "Cannot cd to ${D}/${ruby_path}"
		for file in * ; do
			fperms 755 ${ruby_path}/${file} || die "Cannot update perms on ${ruby_path}/${file}"
		done
	fi

	# Link netbeans executable from bin
	if [[ -f "${D}"/${DESTINATION}/bin/netbeans ]]; then
		dosym ${DESTINATION}/bin/netbeans /usr/bin/${PN}-${SLOT}
	else
		dosym ${DESTINATION}/platform7/lib/nbexec /usr/bin/${PN}-${SLOT}
	fi

	# Ant installation
	if use java ; then
		local ANTDIR="${DESTINATION}/java2/ant"
		dosym /usr/share/ant/lib ${ANTDIR}/lib
		dosym /usr/share/ant-core/bin ${ANTDIR}/bin
	fi

	# Documentation
	einfo "Installing Documentation..."

	cd "${D}"/${DESTINATION}
	dohtml CREDITS.html README.html netbeans.css
	rm -f build_info CREDITS.html README.html netbeans.css

	use doc && java-pkg_dojavadoc "${S}"/nbbuild/build/javadoc

	# Icons and shortcuts
	if use nb ; then
		einfo "Installing icon..."
		dodir /usr/share/icons/hicolor/32x32/apps
		dosym ${DESTINATION}/nb${SLOT}/netbeans.png /usr/share/icons/hicolor/32x32/apps/netbeans-${SLOT}.png

	fi

	make_desktop_entry netbeans-${SLOT} "Netbeans ${SLOT}" netbeans-${SLOT}.png Development
}

pkg_postinst() {
	einfo "If you want to use specific locale of netbeans, use --locale argument, for example:"
	einfo "${PN}-${SLOT} --locale de"
	einfo "${PN}-${SLOT} --locale pt:BR"
}

# Supporting functions for this ebuild

place_unpack_symlinks() {
	local target=""

	einfo "Symlinking compilation-time jars"

	dosymcompilejar "javahelp/external" javahelp jh.jar jh-2.0_05.jar
	dosymcompilejar "o.jdesktop.layout/external" swing-layout-1 swing-layout.jar swing-layout-1.0.3.jar
	dosymcompilejar "libs.jna/external" jna jna.jar jna-3.0.2.jar
	dosymcompilejar "libs.jsr223/external" jsr223 script-api.jar jsr223-api.jar
	dosymcompilejar "libs.junit4/external" junit-4 junit.jar junit-4.5.jar

	if use harness || use ide ; then
		dosymcompilejar "apisupport.harness/external" javahelp jhall.jar jsearch-2.0_05.jar
	fi

	#if use groovy ; then
		#dosymcompilejar "groovy.editor/external" groovy-1 groovy.jar groovy-all-1.5.6.jar
	#fi

	if use gsf ; then
		dosymcompilejar "css.visual/external" sac sac.jar sac-1.3.jar
		dosymcompilejar "css.visual/external" flute flute.jar flute-1.3.jar
	fi

	if use ide ; then
		dosymcompilejar "db.drivers/external" jdbc-postgresql jdbc-postgresql.jar postgresql-8.3-603.jdbc3.jar
		dosymcompilejar "db.drivers/external" jdbc-mysql jdbc-mysql.jar mysql-connector-java-5.1.6-bin.jar
		dosymcompilejar "db.sql.visualeditor/external" javacc javacc.jar javacc-3.2.jar
		dosymcompilejar "servletapi/external" tomcat-servlet-api-2.2 servlet.jar servlet-2.2.jar
		dosymcompilejar "libs.commons_logging/external" commons-logging commons-logging.jar commons-logging-1.1.jar
		dosymcompilejar "libs.jakarta_oro/external" jakarta-oro-2.0 jakarta-oro.jar jakarta-oro-2.0.8.jar
		dosymcompilejar "libs.commons_net/external" commons-net commons-net.jar commons-net-1.4.1.jar
		dosymcompilejar "libs.freemarker/external" freemarker-2.3 freemarker.jar freemarker-2.3.8.jar
		dosymcompilejar "libs.ini4j/external" ini4j ini4j.jar ini4j-0.2.6.jar
		dosymcompilejar "libs.jaxb/external" jsr173 jsr173.jar jsr173_api.jar
		dosymcompilejar "libs.jaxb/external" jaxb-2 jaxb-api.jar jaxb-api.jar
		dosymcompilejar "libs.jaxb/external" sun-jaf activation.jar activation.jar
		#dosymcompilejar "libs.jaxb/external" jaxb-2 jaxb-impl.jar jaxb-impl.jar
		#dosymcompilejar "libs.jaxb/external" jaxb-tools-2 jaxb-tools.jar jaxb-xjc.jar
		#dosymcompilejar "o.apache.xml.resolver/external" xml-commons resolver.jar resolver-1.2.jar
		dosymcompilejar "libs.jsch/external" jsch jsch.jar jsch-0.1.39.jar
		dosymcompilejar "libs.lucene/external" lucene-2 lucene-core.jar lucene-core-2.3.2.jar
		# svnClientAdapter
		# svnjavahl
		# javac-api-nb-7.0-b07.jar
		# tomcat-webserver-3.2.jar
		dosymcompilejar "libs.xerces/external" xerces-2 xercesImpl.jar xerces-2.8.0.jar
		dosymcompilejar "web.flyingsaucer/external" flyingsaucer core-renderer.jar core-renderer-R7final.jar
	fi

	if use j2ee ; then
		# j2eeapis/external/jsr88javax.jar
		# servlet2.5-jsp2.1-api.jar
		# appservapis-2.0.58.3.jar
		# org-netbeans-modules-j2ee-sun-appsrv81.jar
		dosymcompilejar "libs.commons_fileupload/external" commons-fileupload commons-fileupload.jar commons-fileupload-1.0.jar
		# glassfish-logging-2.0.jar
		dosymcompilejar "libs.httpunit/external" httpunit httpunit.jar httpunit-1.6.2.jar
		# spring-webmvc-2.5.jar
		# shale-remoting-1.0.4.jar
		dosymcompilejar "web.jstl11/external" jakarta-jstl jstl.jar jstl-1.1.2.jar
		dosymcompilejar "web.jstl11/external" jakarta-jstl standard.jar standard-1.1.2.jar
		dosymcompilejar "web.monitor/external" tomcat-servlet-api-2.3 servlet.jar servlet-2.3.jar
	fi

	if use java ; then
		# javac-impl-nb-7.0-b07.jar
		dosymcompilejar "o.jdesktop.beansbinding/external" beansbinding beansbinding.jar beansbinding-1.2.1.jar
		# glassfish-persistence-v2ur1-build-09d.jar
		# Ant-1.7.1-binary-patch-72080.jar
		dosymcompilejar "junit/external" junit junit.jar junit-3.8.2.jar
		dosymcompilejar "libs.cglib/external" cglib-2.1 cglib.jar cglib-2.2.jar
		# spring-2.5.jar
		dosymcompilejar "swingapp/external" appframework appframework.jar appframework-1.0.3.jar
	fi

	if use mobility ; then
		dosymcompilejar "mobility.antext/external" ant-contrib ant-contrib.jar ant-contrib-1.0b3.jar
		# nbactivesync-5.0.jar
		# security.jar
		# bdjo.jar
		dosymcompilejar "j2me.cdc.project.bdj/external" bcprov bcprov.jar bcprov-jdk15-139.jar
		# RicohAntTasks-2.0.jar
		dosymcompilejar "j2me.cdc.project.ricoh/external" commons-httpclient-3 commons-httpclient.jar commons-httpclient-3.0.jar
		dosymcompilejar "j2me.cdc.project.ricoh/external" commons-codec commons-codec.jar commons-codec-1.3.jar
		# netbeans_databindingme.jar
		# netbeans_databindingme_pim.jar
		# netbeans_databindingme_svg.jar
		dosymcompilejar "mobility.deployment.webdav/external" jakarta-slide-webdavclient jakarta-slide-webdavlib.jar jakarta-slide-webdavlib-2.1.jar
		dosymcompilejar "mobility.deployment.webdav/external" commons-httpclient-3 commons-httpclient.jar commons-httpclient-3.0.1.jar
		# jakarta-slide-ant-webdav-2.1.jar
		dosymcompilejar "mobility.deployment.webdav/external" jdom-1.0 jdom.jar jdom-1.0.jar
		# jmunit4cldc11-1.1.0.jar
		# jmunit4cldc10-1.1.0.jar
		dosymcompilejar "mobility.proguard/external" proguard proguard.jar proguard4.2.jar
		# perseus-nb-1.0.jar
		# netbeans_midp_components_basic.jar
		# netbeans_midp_components_pda.jar
		# netbeans_midp_components_wma.jar
		# nb_svg_midp_components.jar
	fi

	if use php ; then
		dosymcompilejar "libs.javacup/external" javacup javacup.jar java-cup-11a.jar
	fi

	if use soa ; then
		# bdi-1.0.0.jar
		dosymcompilejar "soa.reportgenerator/external" itext iText.jar itext-2.0.5.jar
		# jbi-admin-common.jar
		# JGoLayout5.1.jar
		# JGo5.1.jar
		# JGoInstruments5.1.jar
	fi

	if use xml ; then
		#dosymcompilejar "libs.jxpath/external" commons-jxpath commons-jxpath.jar jxpath1.1.jar
		dosymcompilejar "o.n.xml.libs.jxpath/external" commons-jxpath commons-jxpath.jar jxpath-1.2.jar
		dosymcompilejar "visdev.prefuse/external" prefuse-2006 prefuse.jar prefuse-beta.jar
	fi

	if [ -n "${NB_DOSYMCOMPILEJARFAILED}" ] ; then
		die "Some compilation-time jars could not be symlinked"
	fi
}

symlink_extjars() {
	local targetdir=""

	einfo "Symlinking runtime jars"

	targetdir="platform${PLATFORM}/modules/ext"
	dosyminstjar ${targetdir} javahelp jh.jar jh-2.0_05.jar
	dosyminstjar ${targetdir} jna jna.jar jna-3.0.2.jar
	dosyminstjar ${targetdir} jsr223 script-api.jar script-api.jar
	dosyminstjar ${targetdir} junit-4 junit.jar junit-4.5.jar
	dosyminstjar ${targetdir} swing-layout-1 swing-layout.jar swing-layout-1.0.3.jar

	if use groovy ; then
		targetdir="groovy1/modules/ext"
		# groovy-all.jar
	fi

	if use gsf ; then
		targetdir="gsf1/modules"
		# org-mozilla-rhino-patched.jar
		targetdir="gsf1/modules/ext"
		dosyminstjar ${targetdir} flute flute.jar flute-1.3.jar
		dosyminstjar ${targetdir} sac sac.jar sac-1.3.jar
	fi

	if use harness ; then
		targetdir="harness"
		dosyminstjar ${targetdir} javahelp jhall.jar jsearch-2.0_05.jar
	fi

	if use ide ; then
		targetdir="ide${IDE_VERSION}/modules/ext"
		dosyminstjar ${targetdir} commons-logging commons-logging.jar commons-logging-1.1.jar
		dosyminstjar ${targetdir} commons-net commons-net.jar commons-net-1.4.1.jar
		dosyminstjar ${targetdir} flyingsaucer core-renderer.jar core-renderer.jar
		dosyminstjar ${targetdir} freemarker-2.3 freemarker.jar freemarker-2.3.8.jar
		dosyminstjar ${targetdir} ini4j ini4j.jar ini4j-0.2.6.jar
		dosyminstjar ${targetdir} jakarta-oro-2.0 jakarta-oro.jar jakarta-oro-2.0.8.jar
		dosyminstjar ${targetdir} jdbc-mysql jdbc-mysql.jar mysql-connector-java-5.1.6-bin.jar
		dosyminstjar ${targetdir} jdbc-postgresql jdbc-postgresql.jar postgresql-8.3-603.jdbc3.jar
		dosyminstjar ${targetdir} jsch jsch.jar jsch-0.1.39.jar
		dosyminstjar ${targetdir} lucene-2 lucene-core.jar lucene-core-2.3.2.jar
		# resolver-1.2.jar
		dosyminstjar ${targetdir} tomcat-servlet-api-2.2 servlet.jar servlet-2.2.jar
		# svnClientAdapter-1.4.0.jar
		# svnjavahl-1.5.0.jar
		# webserver.jar
		dosyminstjar ${targetdir} xerces-2 xercesImpl.jar xerces-2.8.0.jar
		targetdir="ide${IDE_VERSION}/modules/ext/jaxb"
		dosyminstjar ${targetdir} sun-jaf activation.jar activation.jar
		# jaxb-impl.jar
		# jaxb-xjc.jar
		targetdir="ide${IDE_VERSION}/modules/ext/jaxb/api"
		dosyminstjar ${targetdir} jsr173 jsr173.jar jsr173_api.jar
		dosyminstjar ${targetdir} jaxb-2 jaxb-api.jar jaxb-api.jar
	fi

	if use j2ee ; then
		targetdir="/enterprise5/modules/ext"
		dosyminstjar ${targetdir} commons-fileupload commons-fileupload commons-fileupload-1.0.jar
		# glassfish-jspparser-2.0.jar
		# glassfish-logging-2.0.jar
		dosyminstjar ${targetdir} httpunit httpunit.jar httpunit-1.6.2.jar
		dosyminstjar ${targetdir} jakarta-jstl jstl.jar jstl.jar
		dosyminstjar ${targetdir} jakarta-jstl standard.jar standard.jar
		# jsr88javax.jar
		# servlet2.5-jsp2.1-api.jar
		# shale-remoting-1.0.4.jar
		targetdir="enterprise5/modules/ext/jsf-1_2"
		dosyminstjar ${targetdir} commons-beanutils-1.7 commons-beanutils.jar commons-beanutils.jar
		dosyminstjar ${targetdir} commons-collections commons-collections.jar commons-collections.jar
		dosyminstjar ${targetdir} commons-digester commons-digester.jar commons-digester.jar
		dosyminstjar ${targetdir} commons-logging commons-logging.jar commons-logging.jar
		# jsf-impl.jar
		# jsf-api.jar
		targetdir="/enterprise5/modules/ext/rest"
		dosyminstjar ${targetdir} asm-3 asm.jar asm-3.1.jar
		# grizzly-servlet-webserver-1.7.3.2.jar
		# http.jar
		dosyminstjar ${targetdir} jdom-1.0 jdom.jar jdom-1.0.jar
		# jersey.jar
		# jersey-spring-0.9-ea-SNAPSHOT.jar
		# jettison-1.0-RC1.jar
		# jsr311-api.jar
		dosyminstjar ${targetdir} rome rome.jar rome-0.9.jar
		# wadl2java.jar
		targetdir="enterprise5/modules/ext/spring"
		# spring-webmvc-2.5.jar
		targetdir="enterprise5/modules/ext/struts"
		dosyminstjar ${targetdir} antlr antlr.jar antlr.jar
		dosyminstjar ${targetdir} commons-beanutils-1.7 commons-beanutils.jar commons-beanutils.jar
		dosyminstjar ${targetdir} commons-digester commons-digester.jar commons-digester.jar
		dosyminstjar ${targetdir} commons-logging commons-logging.jar commons-logging.jar
		dosyminstjar ${targetdir} commons-validator commons-validator.jar commons-validator.jar
		dosyminstjar ${targetdir} jakarta-oro-2.0 jakarta-oro.jar jakarta-oro.jar
		# struts.jar
	fi

	if use java ; then
		targetdir="java2/ant/etc"
		dosyminstjar ${targetdir} ant ant-bootstrap.jar ant-bootstrap.jar
		targetdir="java2/ant/nblib"
		# bridge.jar
		targetdir="java2/ant/patches"
		# 72080.jar
		targetdir="java2/modules"
		# org-apache-tools-ant-module.jar
		targetdir="java2/modules/ext"
		dosyminstjar ${targetdir} appframework appframework.jar appframework-1.0.3.jar
		dosyminstjar ${targetdir} beansbinding beansbinding.jar beansbinding-1.2.1.jar
		dosyminstjar ${targetdir} cglib-2.1 cglib.jar cglib-2.2.jar
		# javac-impl-nb-7.0-b07.jar
		# javac-api-nb-7.0-b07.jar
		dosyminstjar ${targetdir} junit junit.jar junit-3.8.2.jar
		targetdir="java2/modules/ext/jaxws21"
		dosyminstjar ${targetdir} fastinfoset fastinfoset.jar FastInfoset.jar
		# http.jar
		dosyminstjar ${targetdir} jax-ws-2 jax-ws.jar jaxws-rt.jar
		dosyminstjar ${targetdir} jaxb-tools-2 jaxb-tools.jar jaxws-tools.jar
		# mimepull.jar
		# resolver.jar
		dosyminstjar ${targetdir} saaj saaj.jar saaj-impl.jar
		dosyminstjar ${targetdir} sjsxp sjsxp.jar sjsxp.jar
		dosyminstjar ${targetdir} stax-ex stax-ex.jar stax-ex.jar
		dosyminstjar ${targetdir} xmlstreambuffer streambuffer.jar streambuffer.jar
		targetdir="java2/modules/ext/jaxws21/api"
		dosyminstjar ${targetdir} jax-ws-api-2 jax-ws-api.jar jaxws-api.jar
		dosyminstjar ${targetdir} jsr181 jsr181.jar jsr181-api.jar
		dosyminstjar ${targetdir} jsr250 jsr250.jar jsr250-api.jar
		dosyminstjar ${targetdir} jsr67 jsr67.jar saaj-api.jar
		targetdir="java2/modules/ext/hibernate"
		dosyminstjar ${targetdir} antlr antlr.jar antlr-2.7.6.jar
		dosyminstjar ${targetdir} asm-2.2 asm.jar asm.jar
		dosyminstjar ${targetdir} asm-2.2 asm-attrs.jar asm-attrs.jar
		dosyminstjar ${targetdir} cglib-2.1 cglib.jar cglib-2.1.3.jar
		dosyminstjar ${targetdir} commons-collections commons-collections,jar commons-collections-2.1.1.jar
		dosyminstjar ${targetdir} dom4j-1 dom4j.jar dom4j-1.6.1.jar
		dosyminstjar ${targetdir} ehcache-1.4 ehcache.jar ehcache-1.2.3.jar
		dosyminstjar ${targetdir} glassfish-persistence glassfish-persistence.jar ejb3-persistence.jar
		dosyminstjar ${targetdir} hibernate-annotations-3.2 hibernate-annotations.jar hibernate-annotations.jar
		# hibernate-commons-annotations.jar
		dosyminstjar ${targetdir} hibernate-entitymanager hibernate-entitymanager.jar hibernate-entitymanager.jar
		# hibernate-tools.jar
		dosyminstjar ${targetdir} hibernate-3.2 hibernate3.jar hibernate3.jar
		dosyminstjar ${targetdir} javassist-3 javassist.jar javassist.jar
		dosyminstjar ${targetdir} jdbc2-stdext jdbc2-stdext.jar jdbc2_0-stdext.jar
		dosyminstjar ${targetdir} glassfish-transaction-api jta.jar jta.jar
		dosyminstjar ${targetdir} jtidy Tidy.jar jtidy-r8-20060801.jar
		targetdir="java2/modules/ext/spring"
		# spring-2.5.jar
		targetdir="java2/modules/ext/toplink"
		dosyminstjar ${targetdir} toplink-essentials toplink-essentials.jar toplink-essentials.jar
		dosyminstjar ${targetdir} toplink-essentials toplink-essentials-agent.jar toplink-essentials-agent.jar
	fi

	if use mobility ; then
		targetdir="mobility8/external/proguard"
		dosyminstjar ${targetdir} proguard proguard.jar proguard4.2.jar
		targetdir="mobility8/modules/ext"
		dosyminstjar ${targetdir} ant-contrib ant-contrib.jar ant-contrib-1.0b3.jar
		dosyminstjar ${targetdir} bcprov bcprov.jar bcprov-jdk15-139.jar
		# cdc-agui-swing-layout.jar
		# cdc-pp-awt-layout.jar
		dosyminstjar ${targetdir} commons-codec commons-codec.jar commons-codec-1.3.jar
		dosyminstjar ${targetdir} commons-httpclient-3 commons-httpclient.jar commons-httpclient-3.0.jar
		dosyminstjar ${targetdir} commons-httpclient-3 commons-httpclient.jar commons-httpclient-3.0.1.jar
		# bdjo.jar
		# jakarta-slide-ant-webdav-2.1.jar
		dosyminstjar ${targetdir} jakarta-slide-webdavclient jakarta-slide-webdavlib.jar jakarta-slide-webdavlib-2.1.jar
		dosyminstjar ${targetdir} jdom-1.0 jdom.jar jdom-1.0.jar
		# jmunit4cldc11-1.1.0.jar
		# jmunit4cldc10-1.1.0.jar
		# perseus-nb-1.0.jar
		# RicohAntTasks-2.0.jar
		# security.jar
	fi

	if use php ; then
		targetdir="php1/modules/ext"
		dosyminstjar ${targetdir} javacup javacup.jar java-cup-11a.jar
	fi

	if use soa ; then
		targetdir="soa2/modules/ext/jbi"
		# jbi-admin-common.jar
		targetdir="soa2/modules/ext/jgo"
		# JGo5.1.jar
		# JGoInstruments5.1.jar
		# JGoLayout5.1.jar
		targetdir="soa2/modules/ext/reportgenerator"
		dosyminstjar ${targetdir} itext iText.jar itext-2.0.5.jar
		targetdir="soa2/modules/ext/wsdl4j-1.5.2"
		dosyminstjar ${targetdir} wsdl4j wsdl4j.jar wsdl4j.jar
		dosyminstjar ${targetdir} wsdl4j qname.jar qname.jar
		targetdir="soa2/modules/ext/xmlbeans-2.1.0"
		dosyminstjar ${targetdir} jsr173 jsr173.jar jsr173_1.0_api.jar
		dosyminstjar ${targetdir} xml-xmlbeans-1 xbean.jar xbean.jar
		dosyminstjar ${targetdir} xml-xmlbeans-1 xbean_xpath.jar xbean_xpath.jar
		# resolver.jar
		# xmlpublic.jar
	fi

	if use xml ; then
		targetdir="xml2/modules/ext"
		dosyminstjar ${targetdir} prefuse-2006 prefuse.jar prefuse-beta.jar
		targetdir="xml2/modules/ext/jxpath"
		dosyminstjar ${targetdir} commons-jxpath commons-jxpath.jar jxpath1.1.jar
		targetdir="xml2/modules/ext/xpath"
		# jxpath-1.2.jar
	fi

	if [ -n "${NB_DOSYMINSTJARFAILED}" ] ; then
		die "Some runtime jars could not be symlinked"
	fi
}

dosymcompilejar() {
	if [ -z "${JAVA_PKG_NB_BUNDLED}" ] ; then
		local dest="${1}"
		local package="${2}"
		local jar_file="${3}"
		local target_file="${4}"

		# We want to know whether the target jar exists and fail if it doesn't so we know
		# something is wrong
		local target="${S}/${dest}/${target_file}"
		if [ -e "${target}" ] ; then
			java-pkg_jar-from --build-only --into "${S}"/${dest} ${package} ${jar_file} ${target_file}
		else
			ewarn "Target jar does not exist so will not create link: ${target}"
			NB_DOSYMCOMPILEJARFAILED="1"
		fi
	fi
}

dosyminstjar() {
	if [ -z "${JAVA_PKG_NB_BUNDLED}" ] ; then
		local dest="${1}"
		local package="${2}"
		local jar_file="${3}"
		local target_file=""
		if [ -z "${4}" ]; then
			target_file="${3}"
		else
			target_file="${4}"
		fi

		# We want to know whether the target jar exists and fail if it doesn't so we know
		# something is wrong
		local target="${DESTINATION}/${dest}/${target_file}"
		if [ -e "${D}/${target}" ] ; then
			dosym /usr/share/${package}/lib/${jar_file} ${target}
		else
			ewarn "Target jar does not exist so will not create link: ${D}/${target}"
			NB_DOSYMINSTJARFAILED="1"
		fi
	fi
}

# Compiles locale support
# Arguments
# 1 - ant flags
# 2 - clusters
# 3 - locale
compile_locale_support() {
	einfo "Compiling support for '${3}' locale"
	ANT_OPTS="-Xmx1g -Djava.awt.headless=true" eant ${1} ${2} -Dlocales=${3} build-nozip-ml
}