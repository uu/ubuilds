# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/quartz/quartz-1.4.5.ebuild,v 1.4 2005/10/15 11:41:22 axxo Exp $

JAVA_PKG_IUSE="dbcp digester jboss java5 log4j modeler oracle pool source test validator"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Quartz Scheduler from OpenSymphony"
HOMEPAGE="http://www.opensymphony.com/quartz/"
SRC_URI="https://quartz.dev.java.net/files/documents/1267/43545/${P}.zip"

LICENSE="Apache-2.0"
SLOT="1.6"
KEYWORDS="~amd64 ~ppc ~x86"

# Still left
# /usr/portage/tmp/portage/dev-java/quartz-1.6.0/work/lib/build/ejb.jar
# /usr/portage/tmp/portage/dev-java/quartz-1.6.0/work/lib/build/javax.jms.jar

# Removed struts use flag does not seem to be a dep anymore
#	struts? ( =dev-java/struts-1.2* )"

COMMON_DEPEND="dev-java/commons-collections
		dev-java/commons-logging
		beanutils? ( dev-java/commons-beanutils )
		dbcp? ( dev-java/commons-dbcp )
		digester? ( >=dev-java/commons-digester-1.7 )
		modeler? ( dev-java/commons-modeler )
		pool? ( dev-java/commons-pool )
		validator? ( dev-java/commons-validator )
		dev-java/jdbc2-stdext
		dev-java/jta
		test? ( dev-java/junit )
		log4j? ( >=dev-java/log4j-1.2.11 )
		~dev-java/servletapi-2.4
		dev-java/sun-jaf
		dev-java/sun-javamail
		dev-java/sun-jms
		!java5? ( >=dev-java/sun-jmx-1.2.1 )
		oracle? ( =dev-java/jdbc-oracle-bin-9.2* )
		jboss? ( >=www-servers/jboss-3.2.3 )"


RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPEND}"

DEPEND=">=virtual/jdk-1.4
	${COMMON_DEPEND}
	app-arch/unzip"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	echo "Removing bundled jars"
	rm -v *.jar examples/*.jar lib/*/*.jar
}

src_compile() {
	local antflags=""
	CLASSPATH="$CLASSPATH:$(java-pkg_getjars commons-collections)"
	CLASSPATH="$CLASSPATH:$(java-pkg_getjars commons-logging)"
	use beanutils && CLASSPATH="$CLASSPATH:$(java-pkg_getjars commons-beanutils)"
	use dbcp && CLASSPATH="$CLASSPATH:$(java-pkg_getjars commons-dbcp)"
	use digester && CLASSPATH="$CLASSPATH:$(java-pkg_getjars commons-digester)"
	use modeler && CLASSPATH="$CLASSPATH:$(java-pkg_getjars commons-modeler)"
	use pool && CLASSPATH="$CLASSPATH:$(java-pkg_getjars commons-pool)"
	use validator && CLASSPATH="$CLASSPATH:$(java-pkg_getjars commons-validator)"
	CLASSPATH="$CLASSPATH:$(java-pkg_getjars jdbc2-stdext)"
	CLASSPATH="$CLASSPATH:$(java-pkg_getjars jta)"
	use test && CLASSPATH="$CLASSPATH:$(java-pkg_getjars junit)"
	use log4j && CLASSPATH="$CLASSPATH:$(java-pkg_getjars log4j)"
	CLASSPATH="$CLASSPATH:$(java-pkg_getjars servletapi-2.4)"
	CLASSPATH="$CLASSPATH:$(java-pkg_getjars sun-jaf)"
	CLASSPATH="$CLASSPATH:$(java-pkg_getjars sun-javamail)"
	CLASSPATH="$CLASSPATH:$(java-pkg_getjars sun-jms)"
	use ! java5 && CLASSPATH="$CLASSPATH:$(java-pkg_getjars sun-jmx)"
	use oracle && CLASSPATH="$CLASSPATH:$(java-pkg_getjars jdbc-oracle-bin-9.2)"
	if use jboss; then

#		Nastyness
#		Jars should be available via eclass if jars are registered on install

#		cp /usr/share/jboss/lib/jboss-common.jar ${S}/lib
#		cp /usr/share/jboss/lib/jboss-jmx.jar ${S}/lib
#		cp /usr/share/jboss/lib/jboss-system.jar ${S}/lib
#		cp /var/lib/jboss/default/lib/jboss.jar ${S}/lib
#		antflags="${antflags} -Dlib.jboss-common.jar=/usr/share/jboss/lib/jboss-common.jar"
#		antflags="${antflags} -Dlib.jboss-jmx.jar=/usr/share/jboss/lib/jboss-jmx.jar"
#		antflags="${antflags} -Dlib.jboss-system.jar=/usr/share/jboss/lib/jboss-system.jar"
#		antflags="${antflags} -Dlib.jboss.jar=/var/lib/jboss/default/lib/jboss.jar"

		antflags="${antflags} -Dlib.jboss-common.jar=$(java-pkg_getjar jboss jboss-common.jar)"
		antflags="${antflags} -Dlib.jboss-jmx.jar=$(java-pkg_getjar jboss jboss-jmx.jar)"
		antflags="${antflags} -Dlib.jboss-system.jar=$(java-pkg_getjar jboss jboss-system.jar)"
		antflags="${antflags} -Dlib.jboss.jar=$(java-pkg_getjar jboss jboss.jar)"
	fi
#	use struts && CLASSPATH="$CLASSPATH:$(java-pkg_getjars struts-1.2)"
	eant ${antflags} compile jar
}


src_install() {
	java-pkg_newjar build/${P}.jar ${PN}.jar

	use source && java-pkg_dosrc src/*
}
