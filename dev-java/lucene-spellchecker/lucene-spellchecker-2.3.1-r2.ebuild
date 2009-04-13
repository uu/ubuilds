# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
SLOT=2.3
inherit lucene-contrib

DESCRIPTION="Spellchecker addon for lucene"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	lucene-contrib_src_prepare
	cd "${S}" || die

	#copy needed util class from lucene tests
	mkdir -p contrib/${LUCENE_MODULE}/src/test/org/apache/lucene/util || die
	cp src/test/org/apache/lucene/util/English.java \
	contrib/${LUCENE_MODULE}/src/test/org/apache/lucene/util/English.java || die

	if use test; then
		# tests fail when this depend is included in the compile-test target,
		# but tests seem to pass without, so let's get rid of it.
		sed -i -e "s/build-lucene-tests,//" contrib/${LUCENE_MODULE}/build.xml
	fi
}
