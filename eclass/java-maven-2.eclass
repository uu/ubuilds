# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit base java-pkg-2 java-ant-2

# We provide two ways to build maven based ebuilds.
# The first is with maven itself
# The second is via generated build.xml by the maven-ant plugin
# to control how to handle it there is two variables
# WANT_MAVEN_MAVEN_BUILD : if set use maven as the builder : TODO implement
# WANT_MAVEN_EANT_BUILD : use any generated build.xml found.
# if both two variables are set, the build will fail.
[[ -n ${WANT_MAVEN_EANT_BUILD} ]] && [[ -n ${WANT_MAVEN_MAVEN_BUILD} ]] \
&& die "Please choose between eant or maven to build !"

# using eant by default
[[ -z ${WANT_MAVEN_EANT_BUILD} ]] && [[ -z ${WANT_MAVEN_MAVEN_BUILD} ]] \
&& WANT_MAVEN_EANT_BUILD="eant"

JAVA_MAVEN_VERSION=${WANT_MAVEN_VERSION:=1}
SLOT="${JAVA_MAVEN_VERSION}"

case "${JAVA_MAVEN_VERSION}" in
	"1")
	JAVA_MAVEN_EXEC="/usr/bin/maven-1"
	;;
	"1.1")
	JAVA_MAVEN_EXEC="/usr/bin/maven-1.1"
	;;
	"2")
	JAVA_MAVEN_EXEC="/usr/bin/mvn"
	;;
esac

JAVA_MAVEN_SYSTEM_HOME="/usr/share/maven-${SLOT}/maven_home"

# maven 1 and 1.1 share the same repo
JAVA_MAVEN_SYSTEM_REPOSITORY="/usr/share/maven-${SLOT//1.1/1}/maven_home/gentoo-repo"
JAVA_MAVEN_SYSTEM_PLUGINS="${JAVA_MAVEN_SYSTEM_HOME}/plugins"
JAVA_MAVEN_SYSTEM_BIN="${JAVA_MAVEN_SYSTEM_HOME}/bin"
JAVA_MAVEN_SYSTEM_LIB="${JAVA_MAVEN_SYSTEM_HOME}/lib"

JAVA_MAVEN_BUILD_HOME=${JAVA_MAVEN_BUILD_HOME:="${T}/.maven"}
JAVA_MAVEN_BUILD_REPO=${JAVA_MAVEN_BUILD_REPO:="${JAVA_MAVEN_BUILD_HOME}/repository"}
JAVA_MAVEN_BUILD_PLUGINS=${JAVA_MAVEN_BUILD_PLUGINS:="${JAVA_MAVEN_BUILD_HOME}/plugins"}

JAVA_MAVEN_OPTS="${JAVA_MAVEN_OPTS} -Dmaven.home.local=${JAVA_MAVEN_BUILD_HOME}"
JAVA_MAVEN_OPTS="${JAVA_MAVEN_OPTS} -Dmaven.plugin.dir=${JAVA_MAVEN_BUILD_PLUGINS}"
JAVA_MAVEN_OPTS="${JAVA_MAVEN_OPTS}	-Dmaven.repo.remote=file:/${JAVA_MAVEN_BUILD_REPO}"
JAVA_MAVEN_OPTS="${JAVA_MAVEN_OPTS} -Dmaven.repo.remote=file:/${JAVA_MAVEN_SYSTEM_REPOSITORY}"

emaven() {
	local gcp="${EMAVEN_GENTOO_CLASSPATH}"
	local cp

	for atom in ${gcp}; do
		cp="${cp}:$(java-pkg_getjars ${atom})"
	done

	local 	maven_flags="${maven_flags} -Dmaven.plugin.dir=${JAVA_MAVEN_BUILD_PLUGINS}"
	maven_flags="${maven_flags} -Dmaven.home.local=${JAVA_MAVEN_BUILD_HOME}"
	maven_flags="${maven_flags} -Dmaven.repo.local=${JAVA_MAVEN_BUILD_REPO}"
	maven_flags="${maven_flags} -DsystemClasspath${cp}"

	# TODO launch with scope system and systemClasspath set
	# launching (offline mode, we dont get anything !)
	${JAVA_MAVEN_EXEC} ${maven_flags} "-o $@" || die "maven failed"
}

# in case we re using maven1, we will need to generate
# a build.xml to apply our classpath
java-maven-2-gen_build_xml() {
	# generate build.xml whereever there is a project.xml
	for project in $(find "${WORKDIR}" -name project*xml);do
		cd "$(dirname ${project})" || die
		emaven ant:ant\
		|| die "Generation of build.xml failed for ${project}"
	done
}

# searching for maven style generated ant build files
# rewrite their classpath and prevent them to use bundled jars !
# Separated from javava-maven-2-m1-gen_build_xml as we
# don't have always the ant plugin !
java-maven-2-rewrite_build_xml() {
	local file=$1
	java-ant_rewrite-classpath "${file}"

	debug-print "${FUNCNAME}: ${file}"

	if [[ -n "${JAVA_PKG_DEBUG}" ]]; then
		cp "${file}" "${file}.orig" || die "failed to copy ${file}"
	fi

	if [[ ! -w "${file}" ]]; then
		chmod u+w "${file}" || die "chmod u+w ${file} failed"
	fi

	local rewriter="/usr/bin/xml-rewrite-2.py"
	[[ -x "${rewriter}" ]] && local using_new="true"
	if [[ -z "${using_new}" ]]; then
		echo "Rewriting $file (using xml-rewrite.py)"
		rewriter="/usr/bin/xml-rewrite.py"
	fi

	# remove maven predefine depends to let us control the build
	# steps (order, and not use external jars)
	${rewriter} -f "${file}" -d \
	-e target -a depends \
	-e classpath -a refid \
	-e path -a refid \
	|| _bsfix_die "xml-rewrite failed: ${file}"
	# use our own classpath
	${rewriter} -f "${file}" -c -e classpath \
	-a path -v "\${gentoo.classpath}" || _bsfix_die "xml-rewrite failed: ${file}"

	if [[ -n "${JAVA_PKG_DEBUG}" ]]; then
		for file in "${@}"; do
			diff -NurbB "${file}.orig" "${file}"
		done
	fi
}

java-maven-2_src_unpack() {
	base_src_unpack
	if [[ ${WANT_MAVEN_EANT_BUILD} ]]; then
		# if build.xml are present we suppose they re generated from maven pom
		# then we rewrite them, see the rewrite function
		for build in $(find "${WORKDIR}" -name build*xml || die);do
			pushd "$(dirname ${build} || die )" > /dev/null || die
			java-maven-2-rewrite_build_xml ${build}
			popd > /dev/null || die
		done
	fi
}

java-maven-2_src_compile_from_build_xml() {
	EANT_BUILD_TARGET="clean compile jar"
	java-pkg-2_src_compile
}

java-maven-2_src_compile() {
	if [[ ${WANT_MAVEN_EANT_BUILD} ]]; then
		EANT_BUILD_TARGET="clean compile jar"
		java-pkg-2_src_compile
	fi
}

java-maven-2_src_test() {
	emaven test || die "Tests failed"
}

# in most cases we re safe, there is one jar but it can be
# either versionnated  or "SNAPSHOTED"
java-maven-2_src_install() {
	java-pkg_newjar target/*.jar ${PN}.jar
	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/*
}

EXPORT_FUNCTIONS src_test src_install src_unpack src_compile

