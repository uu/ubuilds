# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT=2.4
inherit lucene-contrib java-osgi

DESCRIPTION="Analyzer addon for lucene"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_compile() {
	lucene-contrib_src_compile
	java-osgi_makejar-fromfile build/contrib/${LUCENE_MODULE}/${P}.jar \
			"${FILESDIR}"/manifest "Apache Lucene Analysis" 1
}
