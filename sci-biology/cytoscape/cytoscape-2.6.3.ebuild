# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EANT_ANT_TASKS="jakarta-regexp-1.4 batik-1.7 xalan xsdlib relaxng-datatype jaxb-2"
EANT_GENTOO_CLASSPATH="swing-layout-1,stax-ex,xmlstreambuffer,sjsxp,concurrent-util,jsr173,jsr181,jsr250,saaj-api,fastinfoset,junit,batik-1.7,freehep-graphicsio-svg,freehep-util,freehep-xml,freehep-export,freehep-graphicsio,freehep-graphicsio-java,freehep-swing,freehep-graphicsio-ps,freehep-io,freehep-graphics2d,freehep-misc-deps,itext,swingx,piccolo2d,tclib"
JAVA_ANT_REWRITE_CLASSPATH="true"

inherit versionator java-pkg-2 java-ant-2 eutils

MY_PV=$(replace_all_version_separators '_')

DESCRIPTION="A visualization platform for molecular interaction networks"
HOMEPAGE="http://www.cytoscape.org/"
SRC_URI="http://chianti.ucsd.edu/Cyto-${MY_PV}/cytoscapeSource-v${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

COMMON_DEPS="dev-java/swing-layout:1
	dev-java/stax-ex
	dev-java/xmlstreambuffer
	dev-java/sjsxp
	dev-java/concurrent-util
	dev-java/jsr173
	dev-java/jsr181
	dev-java/jsr250
	java-virtuals/saaj-api
	dev-java/fastinfoset
	dev-java/itext
	dev-java/jdom:1.0
	dev-java/junit
	dev-java/colt
	dev-java/javahelp
	=dev-java/swingx-20070211-r1
	>=dev-java/l2fprod-common-7.3-r1
	dev-java/tclib
	dev-java/piccolo2d
	~dev-java/biojava-1.6
	dev-java/freehep-graphicsio-java
	dev-java/freehep-graphicsio-ps
	dev-java/freehep-graphicsio-svg
	dev-java/freehep-xml
	dev-java/jgoodies-looks:2.0"
#	dev-java/jaxb dev-java/javahelp
DEPEND=">=virtual/jdk-1.6
	dev-java/jakarta-regexp:1.4
	>=dev-java/batik-1.7-r1
	dev-java/xalan
	dev-java/xsdlib
	dev-java/relaxng-datatype
	${COMMON_DEPS}"
RDEPEND=">=virtual/jre-1.6
	${COMMON_DEPS}"

S="${WORKDIR}"

java_prepare() {
	einfo "Removing bundled jars..."
	find -name 'stax-ex.jar' -print -delete
	find -name 'saaj.jar' -print -delete
	find -name 'streambuffer.jar' -print -delete
	find -name 'sjsxp.jar' -print -delete
	find -name 'concurrent.jar' -print -delete
	find -name 'jsr*.jar' -print -delete
	find -name 'FastInfoset.jar' -print -delete
	find -name 'jaxws-*.jar' -print -delete
	find -name 'http.jar' -print -delete
	find -name 'activation.jar' -print -delete
	find -name 'glf.jar' -print -delete
	find -name 'freehep*.jar' -print -delete
	find -name 'itext*.jar' -print -delete
	find -name 'swingx*.jar' -print -delete
	find -name 'piccolo*.jar' -print -delete
	find -name 'jnlp.jar' -print -delete
#	find -name 'wizard.jar' -print -delete
#	find -name 'jaxb*.jar' -print -delete
#	find -name 'swingunit.jar' -print -delete

	cd extra-jars
	find -name '*.jar' -print -delete
	cd "${S}"

	cd lib
	find -name 'colt.jar' -print -delete
	java-pkg_jar-from colt
	find -name 'jhall.jar' -print -delete
	java-pkg_jar-from javahelp
	find -name 'looks-*.jar' -print -delete
	java-pkg_jar-from jgoodies-looks-2.0
	find -name 'jdom*.jar' -print -delete
	java-pkg_jar-from jdom-1.0
	find -name 'junit.jar' -print -delete
	java-pkg_jar-from junit
	find -name 'l2fprod-common*.jar' -print -delete
	java-pkg_jar-from l2fprod-common
	find -name 'swing-layout*.jar' -print -delete
	java-pkg_jar-from swing-layout-1
	find -name 'biojava*.jar' -print -delete
	java-pkg_jar-from biojava
	find -name 'tclib.jar' -print -delete
	cd "${S}"

	cd lib/build-libs
	find -name 'batik*.jar' -print -delete
	java-pkg_jar-from batik-1.7
	find -name 'jakarta*.jar' -print -delete
	java-pkg_jar-from jakarta-regexp-1.4
	find -name 'xalan*.jar' -print -delete
	java-pkg_jar-from xalan
	find -name 'xsdlib*.jar' -print -delete
	java-pkg_jar-from xsdlib
	find -name 'relaxngDatatype.jar' -print -delete
	java-pkg_jar-from relaxng-datatype
	cd "${S}"

	# Skip the jalopy ant build target (produces access violations)
	perl -i -ne 'print unless /taskdef.*name="jalopy"/../<\/target>/' build.xml || die

	# TODO: HACK. Rip out the rasterize task because of batik incompatibility
	perl -i -ne 'print unless /taskdef.*name="rasterize"/../<\/taskdef>/' build.xml || die
	perl -i -ne 'print unless /^\s*<rasterize/../^\s*dest=.*>/' build.xml || die
}

src_install() {
	java-pkg_dojar cytoscape.jar
	java-pkg_dojar lib/*.jar
	java-pkg_jarinto /usr/share/${PN}/plugins
	java-pkg_dojar plugins/core/*.jar

	# replacement for resources/bin/cytoscape.sh
	java-pkg_dolauncher cytoscape.sh --main cytoscape.CyMain \
		--java_args '-Dswing.aatext=true -Xss5M -Xmx512M' \
		--pkg_args '-p '/usr/share/${PN}/plugins' \"$@\"'
	insinto /usr/share/pixmaps
	newins images/icon100.png cytoscape.png
	make_desktop_entry cytoscape.sh Cytoscape /usr/share/pixmaps/cytoscape.png

	dodoc docs/pdf/manual.pdf
}
