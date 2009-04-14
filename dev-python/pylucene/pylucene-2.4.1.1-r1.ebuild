# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI=2
NEED_PYTHON=2.5
JAVA_PKG_IUSE="doc examples source"
WANT_ANT_TASKS="ant-python"

inherit versionator python distutils java-pkg-2 java-ant-2

MY_PV="$(replace_version_separator 3 '-')"
MY_P=${PN}-${MY_PV}
LUCENE_PV="$(get_version_component_range 1-3)"
LUCENE_SLOT="$(get_version_component_range 1-2)"

DESCRIPTION="Python bindings od Lucene search engine"
HOMEPAGE="http://lucene.apache.org/pylucene/"
SRC_URI="http://apache.promopeddler.com/lucene/${PN}/${MY_P}-src-.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug test"

# If problems arise between bugfix releases of lucene, use the following instead
# of LUCENE_SLOT.
#COMMON_DEPEND="~dev-java/lucene-${LUCENE_PV}
COMMON_DEPEND="dev-java/lucene:${LUCENE_SLOT}
	dev-java/lucene-analyzers:${LUCENE_SLOT}
	dev-java/lucene-snowball:${LUCENE_SLOT}
	dev-java/lucene-highlighter:${LUCENE_SLOT}
	dev-java/lucene-regex:${LUCENE_SLOT}
	dev-java/lucene-queries:${LUCENE_SLOT}
	dev-java/lucene-instantiated:${LUCENE_SLOT}"
# A word to the wise: on version bumps, don't forget to update pylucene-jcc
# version number
DEPEND=">=virtual/jdk-1.4
	~dev-python/pylucene-jcc-2.2
	dev-python/setuptools
	${COMMON_DEPEND}
	test? ( app-text/poppler )"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPEND}"

S="${WORKDIR}/${MY_P}"

PYTHON_MODNAME="lucene"

EANT_GENTOO_CLASSPATH="lucene-${LUCENE_SLOT},lucene-analyzers-${LUCENE_SLOT},lucene-snowball-${LUCENE_SLOT},lucene-highlighter-${LUCENE_SLOT},lucene-regex-${LUCENE_SLOT},lucene-queries-${LUCENE_SLOT},lucene-instantiated-${LUCENE_SLOT}"

EANT_EXTRA_ARGS="-Dpython=${python} -Dversion=${MY_PV} -Dlucene.pv=${LUCENE_PV} -Dpython.modname=${PYTHON_MODNAME} -Dpython.sitedir=$(python_get_sitedir) -Dgentoo.numfiles=2"

EANT_BUILD_TARGET="jar build"
EANT_DOC_TARGET="docs"

src_prepare() {
	rm -v build.xml || die
	cp -f "${FILESDIR}/build-${PV}.xml" "${S}/build.xml" || die "copying build.xml failed"
	mkdir -p "${S}"/lib "${S}"/dist
	cd lib
	# Though --with-dependencies is not needed for compiling the java
	# extensions.jar that is part of pylucene - It *is* needed to grab
	# jakarta-regexp, a dependency of lucene-regex, because otherwise, the
	# python module will choke when it can't find all of the the related jars.
	java-pkg_jar-from --with-dependencies ${EANT_GENTOO_CLASSPATH//:/ }
}

src_compile() {
	EANT_EXTRA_ARGS="${EANT_EXTRA_ARGS} -Dgentoo.debug=$(use debug && echo --debug)"
	java-pkg-2_src_compile

	# The Python egg needs the gentoo classpath so we'll generate the python
	# version of it here and stick it in __init__.py
	local cp
	for atom in ${EANT_GENTOO_CLASSPATH}; do
		cp="${cp}:$(java-pkg_getjars --with-dependencies ${atom})"
	done
	cp="${cp#:}"
	# We need to use ${S} to grab extensions.jar for now, so that any references
	# to it during src_test (if used) will find it. The final path will be
	# inserted during src_install - a sed here and a sed there is better than
	# several if loops.
	cp="${cp}:${S}/build/dist/extensions.jar"
	local python_modpath="${S}/build/${PYTHON_MODNAME}"
	local init_cp="\'${cp//:/\', \'}\'"
	sed -i -e "s~CLASSPATH = \[.*\]$~CLASSPATH = \[${init_cp}\]~" \
		"${python_modpath}"/__init__.py \
		|| die "Updating __init__.py's compile CLASSPATH didn't work!"

	rm -f "${python_modpath}"/*.jar
}

src_test() {
	local _pythonpath="$(ls -d ${S}/build/lib.*/lucene):${S}/build"

	if use examples; then
		# The test will untar some stuff in the samples directory. But we'll
		# want a clean samples to be installed on the users system.
		cp -r samples samples.clean || die "copying the samples directory failed."
	fi

	cd "${S}"/samples/LuceneInAction || die "The LuceneInAction directory cd failed!"
	PYTHONPATH="${_pythonpath}" ${python} index.py || die "test part 1 failed"
	einfo "LuceneInAction index made"

	cd "${S}"
	[[ -n ${PYTHONPATH} ]] && local pythonpath_old="${PYTHONPATH}"
	export PYTHONPATH="${_pythonpath}"
	
	find test -name 'test_*.py' | xargs -t -n 1 ${python} \
		|| die "test part 2 failed"
	einfo "Main Tests Complete"
	ls samples/LuceneInAction/*Test.py | xargs -t -n 1 ${python} \
		|| die "test part 3 failed"
	einfo "LuceneInAction Tests Complete"

	if [[ -n ${pythonpath_old} ]]; then
		export PYTHONPATH="${pythonpath_old}"
	else
		unset -v PYTHONPATH
	fi

	if use examples; then
		rm -rf samples || die "removing the used samples directory failed."
		mv samples.clean samples || die "putting the samples directory in place failed."
	fi
}

src_install() {
	java-pkg_dojar "${S}/build/dist/extensions.jar"
	# Fix the classpath with the new path to extensions.jar
	sed -i -e \
		"s~${S}/build/dist/extensions.jar~/usr/share/${PN}-${LUCENE_SLOT}/lib/extensions.jar~" \
		"${S}/build/${PYTHON_MODNAME}/__init__.py" \
		|| die "Updating __init__.py's install CLASSPATH didn't work!"

	# If ant were not called during the install phase a lot of doins/doexe would
	# be necessary to insall the python module. The ant install target does not
	# compile anything - it installs, so it belongs here, not in src_compile.
	EANT_EXTRA_ARGS="${EANT_EXTRA_ARGS} -Dgentoo.root=${D}"
	eant install ${EANT_EXTRA_ARGS}
	
	dodoc CHANGES CREDITS NOTICE || die "Docs weren't installed right"
	if use doc; then
		dohtml -r doc/*
		java-pkg_dojavadoc docs
	fi
	use source && java-pkg_dosrc java/
	use examples && java-pkg_doexamples samples
}
