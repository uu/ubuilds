# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT=2.3
inherit lucene-contrib

DESCRIPTION="Spellchecker addon for lucene"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="test"
#TODO: Figure out why it's not working.

src_unpack() {
	lucene-contrib_src_unpack
	cd "${S}"
	#copy needed util class from lucene tests
	mkdir -p contrib/${LUCENE_MODULE}/src/test/org/apache/lucene/util
	cp src/test/org/apache/lucene/util/English.java \
	contrib/${LUCENE_MODULE}/src/test/org/apache/lucene/util/English.java
}
