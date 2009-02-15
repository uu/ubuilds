# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1
WANT_ANT_TASKS="ant-trax" #TODO Figure out what,where,how,why
JAVA_PKG_IUSE="source doc"
inherit java-pkg-2 java-ant-2

MY_PV="${PV/_rc/-rc}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="Spring is a layered Java/J2EE application framework"
HOMEPAGE="http://www.springframework.org/"
SRC_URI="mirror://sourceforge/${MY_PN/-/}/${MY_P}-with-dependencies.zip"

LICENSE="Apache-2.0"
SLOT="2.0"

KEYWORDS=""
IUSE=""

ANT_DEPEND="dev-java/ant-trax"

#TODO organise CDEPEND, separate any build only libraries.

#dev-java/jcommon
CDEPEND="=dev-java/asm-2.2*
		>=dev-java/aopalliance-1
		dev-java/axis
		dev-java/wsdl4j
		dev-java/bsh
		dev-java/c3p0
		>=dev-java/hessian-3.0.20
		>=dev-java/cglib-2.1
		>=dev-java/dom4j-1.6
		dev-java/ehcache
		dev-java/freemarker
		=dev-java/groovy-1*
		~dev-java/itext-1.4
		dev-java/commons-beanutils:1.7
		=dev-java/commons-httpclient-3*
		>=dev-java/commons-io-1
		>=dev-java/commons-lang-2.1
		=dev-java/commons-validator-1.1*
		dev-java/commons-codec
		dev-java/commons-collections
		dev-java/commons-dbcp
		dev-java/commons-digester
		dev-java/commons-discovery
		dev-java/commons-fileupload
		dev-java/commons-logging
		dev-java/commons-pool
		dev-java/jakarta-jstl
		dev-java/jamon
		>=dev-java/jaxb-2.1
		>=dev-java/jexcelapi-2.5
		=dev-java/junit-3.8*
		>=dev-java/junit-4.4
		dev-java/log4j
		dev-java/poi
		"

#?? aspectj runtime?

#Optional packages ( still required for build )
BLAH="~java-virtuals/servlet-api-2.4
	dev-java/glassfish-persistence
	java-virtuals/javamail
	dev-java/jsfapi
	dev-java/saaj
	~dev-java/jax-ws-api-2
	dev-java/glassfish-persistence
	=dev-java/struts-1.2*
	dev-java/jruby
	>=dev-java/portletapi-1"

# ARGH! 1.6 breaks it already!
DEPEND="
	>=virtual/jdk-1.5
	>=dev-java/antlr-2.7.6
	dev-java/aspectj
	app-arch/zip
	~dev-java/bnd-0.0.208
	~dev-java/easymock-1.2
	dev-java/testng
	~dev-java/easymockclassextension-1.2
	>=dev-java/qdox-1.6
	${BLAH}
	${ANT_DEPEND}
	${CDEPEND}"
# TODO replace sun-jdbc-rowset-bin with free implementation?
RDEPEND="
	>=virtual/jre-1.5
	${CDEPEND}"
S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	
	#TODO Figure out why there is a aspectj directory
	#rm -R aspectj

	local MODULES="spring-aop spring-beans spring-context spring-jms spring-tx"
	for mod in ${MODULES}; do
		mkdir -p "jarcontent/${mod}"
		cat "src/META-INF/spring.handlers" | egrep "${mod/spring-/}" > \
			jarcontent/${mod}/spring.handlers
		cat "src/META-INF/spring.schemas" | egrep "${mod/spring-/}" > \
			jarcontent/${mod}/spring.schemas
	done

	#To allow javadocs to work.
	#cp docs/api/stylesheet.css docs/stylesheet.css || die "Unable to copy stylesheet.css"
	#cp docs/api/overview*.html docs/
	#touch docs/overview.html
	replace_deps

}

# Jikes is broken:
# http://opensource.atlassian.com/projects/spring/browse/SPR-1097
src_compile() {
	#Use bundled documentation for now.  Some issues with building docs
	#local antflags="clean alljars"
	local antflags="clean modulejars"
	#use java5 && antflags="${antflags} ajdoc"

	eant ${antflags} || die "Compilation failed"
}

src_install() {
	java-pkg_dojar dist/modules/*.jar

	use source && java-pkg_dosrc src/*
	#use doc && java-pkg_dojavadoc docs/api
	use doc && dohtml docs/taglib docs/*/html_single
}


#TODO the following deps
#aspectj
#jcommon
#concurrent-backport
#jaxen-1.1[_beta9]
#glassfish-clapi
#hibernate3
#ibatis
#j2ee (includes servletapi etc)
#>=jarjar-1.0rc4
#jaxes (saaj jws-api etc)
#jmx (only for 1.4, which I don't plan on supporting )
#jotm (Dead upstream?)
#oc4j  #Oracle Container 4 Java (Build Only)
#openjpa ( Build Time/ Optional Runtime )
#jdox
#quartz
#tiles
#toplink (not toplink-essentuals)

replace_deps() {
	#TODO replace rm *.jar with one big rm

	pushd lib/ant > /dev/null
		rm *.jar || die "Unable to remove jars"
	popd > /dev/null
	pushd lib/antlr > /dev/null
		rm *.jar || die "Unable to remove jars"
		java-pkg_jar-from --build-only antlr
	popd > /dev/null
	pushd lib/aopalliance > /dev/null
		rm *.jar || die "Unable to remove jars"
		java-pkg_jar-from aopalliance-1
	popd > /dev/null
	pushd lib/asm > /dev/null
		java-pkg_jar-from asm-2.2 asm.jar asm-2.2.3.jar
		java-pkg_jar-from asm-2.2 asm-commons.jar asm-commons-2.2.3.jar
		java-pkg_jar-from asm-2.2 asm-util.jar asm-util-2.2.3.jar
	popd > /dev/null
	pushd lib/aspectj > /dev/null
		#rm *.jar || die "Unable to remove jars"
	popd > /dev/null
	pushd lib/axis > /dev/null
		#rm *.jar || die "Unable to remove jars"
		java-pkg_jar-from axis-1 axis.jar
		java-pkg_jar-from wsdl4j
	popd > /dev/null
	pushd lib/bnd > /dev/null
		#TODO bnd ali_bush started
		java-pkg_jar-from --build-only bnd-0.0.208
	popd > /dev/null
	pushd lib/bsh > /dev/null
		rm *.jar || die "Unable to remove jars"
		java-pkg_jar-from bsh
	popd > /dev/null
	pushd lib/c3p0 > /dev/null
		rm *.jar || die "Unable to remove jars"
		java-pkg_jar-from c3p0
	popd > /dev/null
	pushd lib/caucho > /dev/null
		java-pkg_jar-from hessian-3.0.20 hessian.jar hessian-3.0.20.jar	
	popd > /dev/null
	pushd lib/cglib > /dev/null
		rm *.jar || die "Unable to remove jars"
		java-pkg_jar-from cglib-2.1
	popd > /dev/null
	#pushd lib/commonj > /dev/null
	# TODO jcommon
	#	rm *.jar || die "Unable to remove jars"
	#	java-pkg_jar-from jcommon-1.0
	#popd > /dev/null
	
	#TODO concurrent backport

	pushd lib/dom4j > /dev/null
		rm *.jar || die "Unable to remove jars"
		java-pkg_jar-from dom4j-1
		#java-pkg_jar-from jaxen-1.1[_beta9]
	popd > /dev/null
	pushd lib/easymock > /dev/null
		#TODO Easymock-1 or Easymock2
		java-pkg_jarfrom --build-only "easymock-1,easymockclassextension-1"
	popd > /dev/null
	pushd lib/ehcache > /dev/null
		java-pkg_jar-from ehcache-1.2 ehcache.jar ehcache-1.2.4.jar
	popd > /dev/null
	pushd lib/freemarker > /dev/null
		java-pkg_jar-from freemarker-2.3
	popd > /dev/null
	#pushd lib/ > /dev/null
	#	rm *.jar || die "Unable to remove jars"
	#	java-pkg_jar-from 
	#popd > /dev/null
	pushd lib/glassfish > /dev/null
		#rm *.jar || die "Unable to remove jars"
		#java-pkg_jar-from 
		#TODO glassfish-clapi.jar
	popd > /dev/null
	pushd lib/groovy > /dev/null
		rm *.jar || die "Unable to remove jars"
		java-pkg_jar-from groovy-1
	popd > /dev/null
	pushd lib/hibernate > /dev/null
		#rm *.jar || die "Unable to remove jars"
		#java-pkg_jar-from
		$TODO
		#hibernate3.jar
		#hibernate-annoatations.jar
		#hibernate-commons.annotations.jar
		#hibernate-entitymanager.jar
		#jboss-archive-browsing.jar
	popd > /dev/null
	pushd lib/hsqldb > /dev/null
		rm *.jar || die "Unable to remove jars"
		#TODO Think this is for examples only
		#java-pkg_jar-from 
	popd > /dev/null
	pushd lib/ibatis > /dev/null
		#TODO ibatis
		#rm *.jar || die "Unable to remove jars"
		#java-pkg_jar-from 
	popd > /dev/null
	pushd lib/itext > /dev/null
		rm *.jar || die "Unable to remove jars"
		java-pkg_jar-from itext-1.4
	popd > /dev/null
	pushd lib/j2ee > /dev/null
		#TODO Look that the dir name, fool!
		# Includes servlet-api, so not that bad
		#rm *.jar || die "Unable to remove jars"
		#java-pkg_jar-from
		java-pkg_jar-from --build-only --virtual servlet-api-2.4
		rm rowset.jar #Not supporting 1.4
		java-pkg_jar-from --build-only glassfish-persistence
		java-pkg_jar-from --build-only --virtual javamail
		java-pkg_jar-from --build-only jsfapi-1
	popd > /dev/null
	pushd lib/jakarta-commons > /dev/null
		#rm *.jar || die "Unable to remove jars"
		#commons-attributes-api
		#commons-attributes-compiler

		#java-pkg_jar-from commons-beanutils-1.6
		java-pkg_jar-from \
			"commons-beanutils-1.7,commons-codec,commons-collections,commons-dbcp,commons-digester,commons-discovery"
		java-pkg_jar-from \
			"commons-fileupload,commons-httpclient-3,commons-io-1,commons-lang-2.1,commons-logging,commons-pool,commons-validator"
	popd > /dev/null

	pushd lib/jakarta-taglibs > /dev/null
		rm *.jar || die "Unable to remove jars"
		java-pkg_jar-from jakarta-jstl
	popd > /dev/null
	pushd lib/jamon > /dev/null
		rm *.jar || die "Unable to remove jars"
		java-pkg_jar-from jamon-2
	popd > /dev/null

	pushd lib/jarjar > /dev/null
		#TODO jarjar
		#rm *.jar || die "Unable to remove jars"
		#java-pkg_jar-from --build-only jarjar-1
	popd > /dev/null
	pushd lib/jasperreports > /dev/null
		#TODO jasperreports :(
		
		#rm *.jar || die "Unable to remove jars"
		#java-pkg_jar-from 
	popd > /dev/null
	pushd lib/jaxws > /dev/null
		#rm *.jar || die "Unable to remove jars"
		java-pkg_jar-from --build-only saaj saaj.jar saaj-api.jar
		#TODO jws-api.jar
		#TODO jaxws-api.jar
		java-pkg_jar-from --build-only jax-ws-api-2 jax-ws-api.jar jaxws-api.jar
		
		java-pkg_jar-from --build-only jaxb-2 jaxb-api.jar
	popd > /dev/null
	pushd lib/jexcelapi > /dev/null
		rm *.jar || die "Unable to remove jars"
		java-pkg_jar-from jexcelapi-2.5
	popd > /dev/null
	pushd lib/jmx > /dev/null
		rm *.jar || die "Unable to remove jars"
		#java-pkg_jar-from 
		#TODO jmx
	popd > /dev/null
	pushd lib/jotm > /dev/null
		#rm *.jar || die "Unable to remove jars"
		#java-pkg_jar-from 
		#TODO jotm
	popd > /dev/null
	pushd lib/jruby > /dev/null
		rm *.jar || die "Unable to remove jars"
		java-pkg_jar-from --build-only jruby
	popd > /dev/null
	pushd lib/junit > /dev/null
		rm *.jar || die "Unable to remove jars"
		java-pkg_jar-from junit junit.jar junit-3.8.2.jar
		java-pkg_jar-from junit-4 junit.jar junit-4.4.jar
	popd > /dev/null

	pushd lib/log4j > /dev/null
		rm *.jar || die "Unable to remove jars"
		java-pkg_jar-from log4j
	popd > /dev/null
	pushd lib/maven > /dev/null
		rm *.jar || die "Unable to remove jars"
		java-pkg_jar-from log4j
		#TODO maven-ant-tasks hopefully not required
	popd > /dev/null
	pushd lib/oc4j > /dev/null
		#TODO oc4j
		#rm *.jar || die "Unable to remove jars"
		#java-pkg_jar-from 
	popd > /dev/null
	pushd lib/openjpa > /dev/null
		#TODO openjpa
		#rm *.jar || die "Unable to remove jars"
		#java-pkg_jar-from 
	popd > /dev/null
	pushd lib/poi > /dev/null
		rm *.jar || die "Unable to remove jars"
		java-pkg_jar-from poi
	popd > /dev/null
	pushd lib/portlet > /dev/null
		rm *.jar || die "Unable to remove jars"
		java-pkg_jar-from --build-only portletapi-1
	popd > /dev/null
	pushd lib/qdox > /dev/null
		#rm *.jar || die "Unable to remove jars"
		#java-pkg_jar-from qdox-1.6
	popd > /dev/null
	pushd lib/quartz > /dev/null
		#TODO quartz in java-experimental
		#rm *.jar || die "Unable to remove jars"
		#java-pkg_jar-from 
	popd > /dev/null
	pushd lib/serp > /dev/null
		#TODO serp
		#rm *.jar || die "Unable to remove jars"
		#java-pkg_jar-from 
	popd > /dev/null
	pushd lib/struts > /dev/null
		rm *.jar || die "Unable to remove jars"
		java-pkg_jar-from --build-only struts-1.2
	popd > /dev/null
	pushd lib/testng > /dev/null
		rm *.jar || die "Unable to remove jars"
		java-pkg_jar-from --build-only testng
	popd > /dev/null
	pushd lib/tiles > /dev/null
		#TODO tiles 
		#rm *.jar || die "Unable to remove jars"
		##java-pkg_jar-from struts-1.2
	popd > /dev/null
	pushd lib/toplink > /dev/null
		# TODO toplink (not toplink-essentuals)
		#rm *.jar || die "Unable to remove jars"
		#java-pkg_jar-from "toplink-essentials,glassfish-persistence"
	popd > /dev/null

	#pushd lib/ > /dev/null
	#	rm *.jar || die "Unable to remove jars"
	#	java-pkg_jar-from 
	#popd > /dev/null

}
