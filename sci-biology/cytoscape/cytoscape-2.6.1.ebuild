# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

EANT_ANT_TASKS="jakarta-regexp-1.4 batik-1.7 xalan xsdlib relaxng-datatype jaxb-2 jaxb-tools-2"
EANT_GENTOO_CLASSPATH="swing-layout-1,stax-ex,xmlstreambuffer,sjsxp,concurrent-util,jsr173,jsr181,jsr250,saaj-api,fastinfoset,itext,jdom-1.0,junit,colt,javahelp,jgoodies-looks-2.0,swingx,l2fprod-common,tclib,piccolo2d,freehep-graphicsio-svg,freehep-util,freehep-xml,freehep-export,freehep-graphicsio,freehep-graphicsio-java,freehep-swing,freehep-graphicsio-ps,freehep-io,freehep-graphics2d,freehep-misc-deps,jaxb-2,jaxb-tools-2,batik-1.7"
JAVA_ANT_REWRITE_CLASSPATH="true"

inherit versionator java-pkg-2 java-ant-2 eutils

MY_PV=$(replace_all_version_separators '_')

DESCRIPTION="A visualization platform for molecular interaction networks"
HOMEPAGE="http://www.cytoscape.org/"
SRC_URI="http://chianti.ucsd.edu/Cyto-${MY_PV}/cytoscapeSource-v${PV}.tar.gz
	http://java.sun.com/developer/technicalArticles/GUI/swing/wizard/WizardSource.jar"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

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
	java-virtuals/jsr224
	dev-java/javahelp
	dev-java/jgoodies-looks
	=dev-java/swingx-20070211-r1
	>=dev-java/l2fprod-common-7.3-r1
	dev-java/tclib
	dev-java/piccolo2d
	dev-java/biojava
	dev-java/freehep-graphicsio-java
	dev-java/freehep-graphicsio-ps
	dev-java/freehep-graphicsio-svg
	dev-java/freehep-xml
	dev-java/jaxb
	dev-java/jaxb-tools"
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

src_unpack() {
	unpack ${A}
#	java-ant_remove-taskdefs

	einfo "Removing bundled jars..."
	find -name 'batik*.jar' -print -delete
	find -name 'jakarta*.jar' -print -delete
	find -name 'xalan*.jar' -print -delete
	find -name 'xsdlib*.jar' -print -delete
	find -name 'relaxngDatatype.jar' -print -delete
	find -name 'swing-layout*.jar' -print -delete
	find -name 'swingx*.jar' -print -delete
	find -name 'stax-ex.jar' -print -delete
	find -name 'saaj.jar' -print -delete
	find -name 'streambuffer.jar' -print -delete
	find -name 'sjsxp.jar' -print -delete
	find -name 'concurrent.jar' -print -delete
	find -name 'jsr*.jar' -print -delete
	find -name 'FastInfoset.jar' -print -delete
	find -name 'jdom*.jar' -print -delete
	find -name 'itext*.jar' -print -delete
	find -name 'colt.jar' -print -delete
	find -name 'junit.jar' -print -delete
	find -name 'jaxws-*.jar' -print -delete
	find -name 'jhall.jar' -print -delete
	find -name 'looks-*.jar' -print -delete
	find -name 'l2fprod-common*.jar' -print -delete
	find -name 'http.jar' -print -delete
	find -name 'activation.jar' -print -delete
	find -name 'glf.jar' -print -delete
	find -name 'tclib.jar' -print -delete
	find -name 'piccolo*.jar' -print -delete
	find -name 'freehep*.jar' -print -delete
#	find -name 'wizard.jar' -print -delete
#	find -name 'jaxb*.jar' -print -delete
#	find -name 'jnlp.jar' -print -delete
#	find -name 'swingunit.jar' -print -delete

# Unhandled deps:
# jaxb is dev-java/jaxb, dev-java/jaxb-tools, and jaxb-ri
# jnlp is dev-java/jnlp-bin or maybe app-misc/openjnlp
# sun-jaf sun-httpserver-bin:2

	# Skip the jalopy ant build target (produces access violations)
	perl -i -ne 'print unless /taskdef.*name="jalopy"/../<\/target>/' build.xml || die

	# TODO: HACK. Rip out the rasterize task because of batik incompatibility
	perl -i -ne 'print unless /taskdef.*name="rasterize"/../<\/taskdef>/' build.xml || die
	perl -i -ne 'print unless /^\s*<rasterize/../^\s*dest=.*>/' build.xml || die
#	sed -i 's/org.apache.tools.ant.taskdefs.optional.RasterizerTask/org.apache.batik.apps.rasterizer.Main/' build.xml || die
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
