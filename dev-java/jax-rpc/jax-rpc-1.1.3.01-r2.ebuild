# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jax-rpc/jax-rpc-1.1.3.01-r1.ebuild,v 1.4 2008/05/04 09:05:11 opfer Exp $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Reference Implementation of JAX-RPC, the Java APIs for XML based RPC"
HOMEPAGE="http://jax-rpc.dev.java.net/"
# CVS: cvs -d :pserver:guest@cvs.dev.java.net:/cvs checkout -r JAXRPC_1_1_3_01_PKG_081806 jax-rpc/jaxrpc-ri
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

COMMON_DEP="java-virtuals/servlet-api:2.4
	dev-java/fastinfoset
	java-virtuals/jaxp-virtual
	java-virtuals/saaj-api
	dev-java/jsr101
	java-virtuals/stax-virtual
	dev-java/relaxng-datatype
	dev-java/saaj
	dev-java/sax
	java-virtuals/jaf
	java-virtuals/javamail
	dev-java/xsdlib
	>=dev-java/xerces-2.8"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"

#EANT_GENTOO_CLASSPATH="servlet-api-2.4,fastinfoset,jaxp-virtual,saaj-api,jsr101,stax-virtual,relaxng-datatype,saaj,sax,jaf,javamail,xsdlib,xerces-2"
EANT_BUILD_TARGET="image"
EANT_DOC_TARGET="javadocs"
EANT_EXTRA_ARGS="-Djava.mail=lib/mail.jar"

S="${WORKDIR}/jaxrpc-ri"

src_unpack() {

	unpack ${A}
	cd "${S}" || die
	epatch "${FILESDIR}/${P}-length.patch"
	#java-ant_rewrite-classpath
	cd lib || die

	java-pkg_jar-from --build-only ant-core
	java-pkg_jar-from fastinfoset fastinfoset.jar FastInfoset.jar
	java-pkg_jar-from --virtual jaxp-virtual
	java-pkg_jar-from --virtual saaj-api
	java-pkg_jar-from jsr101
	java-pkg_jar-from --virtual stax-virtual
	java-pkg_jar-from relaxng-datatype
	java-pkg_jar-from saaj saaj.jar saaj-impl.jar
	java-pkg_jar-from sax
	java-pkg_jar-from --virtual servlet-api-2.4 servlet-api.jar servlet.jar
	java-pkg_jar-from --virtual jaf
	java-pkg_jar-from --virtual javamail
	java-pkg_jar-from xsdlib
	java-pkg_jar-from xerces-2

	cd ../src || die
	find . -name '*.java' -exec sed -i \
		-e 's,com.sun.org.apache.xerces.internal,org.apache.xerces,g' \
		{} \;

}

src_install() {

	java-pkg_dojar "build/lib/jaxrpc-spi.jar"
	java-pkg_dojar "build/lib/jaxrpc-impl.jar"

	use doc && java-pkg_dojavadoc build/javadocs
	use source && java-pkg_dosrc src

}
