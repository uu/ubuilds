# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit base java-pkg-2 java-ant-2

DEPEND=">=dev-java/javatoolkit-0.2.0-r3 source? ( app-arch/zip )"
RDEPEND=">=dev-java/javatoolkit-0.2.0-r3"

# We provide two ways to build maven based ebuilds.
# The first is with maven itself
# The second is via generated build.xml by the maven-ant plugin
# to control how to handle it there is two variables
# WANT_MAVEN_MAVEN_BUILD : if set use maven as the builder : TODO implement
# JAVA_MAVEN_EANT_BUILD : use any generated build.xml found.
# if both two variables are set, the build will fail.
#
# For multi projects you can use EMAVEN_PROJECTS which is a space separated
# list of inner modules to build in a maven multiproject based build.
# Remember to generate all necessary build.xml.
# Normally, doing mvn ant:ant on the parent project is suffisant.
#
# If the generated build.xml doesn't fit to your needs,
# you can use your own build.xml to compile and assembly
# sources by placing it in ${FILESDIR}/build-${PV}.xml.
# eg: doesn't contain any javac target but some is needed,
#
# For javadoc generation and source bundling,
# you can set JAVA_MAVEN_SRC_DIRS as a comma sepated
# list of java source directories and add "doc" and
# "source" uses in IUSE.

[[ -n ${JAVA_MAVEN_EANT_BUILD} ]] && [[ -n ${WANT_MAVEN_MAVEN_BUILD} ]] \
&& die "Please choose between eant or maven to build !"

# using eant by default
[[ -z ${JAVA_MAVEN_EANT_BUILD} ]] && [[ -z ${WANT_MAVEN_MAVEN_BUILD} ]] \
&& JAVA_MAVEN_EANT_BUILD="eant"

# SPECIFIC TO MODELLO BASED EBUILDS
# used to facilitate modello plugiin integration
# - generate sources with a maven installation, compress them
#   to fit in subdirs of src/main/java
# - name the tarball ${PN}-gen-src-${PV}.tar.bz2

if [[ -n ${IS_MODELLO_EBUILD} ]];then
	MVN_MOD_GEN_SRC="${PN}-gen-src-${PV}.tar.bz2"
	BASE_URL="http://dev.gentooexperimental.org/~kiorky"
	SRC_URI="${BASE_URL}/${P}.tar.bz2 ${BASE_URL}/${MVN_MOD_GEN_SRC} ${SRC_URI}"
fi

JAVA_MAVEN_VERSION=${WANT_MAVEN_VERSION:=2}
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

# our pom helper
MAVEN_POM_HELPER="/usr/share/javatoolkit/maven-helper.py"

# maven 1 and 1.1 share the same repo
JAVA_MAVEN_SYSTEM_REPOSITORY="/usr/share/maven-${SLOT//1.1/1}/maven_home/gentoo-repo"
JAVA_MAVEN_SYSTEM_PLUGINS="${JAVA_MAVEN_SYSTEM_HOME}/plugins"
JAVA_MAVEN_SYSTEM_BIN="${JAVA_MAVEN_SYSTEM_HOME}/bin"

# repo used by maven when running as root
# that s what upstream calls glocal repository, something available for all
# users
JAVA_MAVEN_ROOT_HOME="/usr/share/maven-${SLOT}/maven_root"
JAVA_MAVEN_ROOT_REPOSITORY="/usr/share/maven-${SLOT//1.1/1}/maven_root/gentoo-repo"
JAVA_MAVEN_ROOT_PLUGINS="${JAVA_MAVEN_ROOT_HOME}/plugins"
JAVA_MAVEN_ROOT_BIN="${JAVA_MAVEN_ROOT_HOME}/bin"


JAVA_MAVEN_BUILD_HOME=${JAVA_MAVEN_BUILD_HOME:="${T}/.maven"}
JAVA_MAVEN_BUILD_REPO=${JAVA_MAVEN_BUILD_REPO:="${JAVA_MAVEN_BUILD_HOME}/repository"}
JAVA_MAVEN_BUILD_PLUGINS=${JAVA_MAVEN_BUILD_PLUGINS:="${JAVA_MAVEN_BUILD_HOME}/plugins"}

JAVA_MAVEN_OPTS="${JAVA_MAVEN_OPTS} -Dmaven.home.local=${JAVA_MAVEN_BUILD_HOME}"
JAVA_MAVEN_OPTS="${JAVA_MAVEN_OPTS} -Dmaven.plugin.dir=${JAVA_MAVEN_BUILD_PLUGINS}"
JAVA_MAVEN_OPTS="${JAVA_MAVEN_OPTS}	-Dmaven.repo.remote=file:/${JAVA_MAVEN_BUILD_REPO}"
JAVA_MAVEN_OPTS="${JAVA_MAVEN_OPTS} -Dmaven.repo.remote=file:/${JAVA_MAVEN_SYSTEM_REPOSITORY}"

# multiproject
JAVA_MAVEN_MULTIPROJECT_CLASSESPATH="${WORKDIR}/maven_classes"

# Where sources are hold in a maven project
JAVA_MAVEN_SOURCES="src/main/"
JAVA_MAVEN_SRC_DIRS=${JAVA_MAVEN_SRC_DIRS}

# maven build file
POM_XML="pom.xml"

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


java-maven-2_src_unpack() {
	if  ! has_version ">=dev-java/javatoolkit-0.2.0-r2";then
		die "please upgrade to at least dev-java/javatoolkit-0.2.0-r2"
	fi
	base_src_unpack

	# if present using specific build.xml
	if [[ -f "${FILESDIR}/build-${PV}.xml" ]];then
		cp "${FILESDIR}/build-${PV}.xml" "${S}/build.xml" || die
	fi

	# specific to modello based ebuild
	# eventually copy build.xml from filesdir then unpack pre-generated sources.
	if [[ -n ${IS_MODELLO_EBUILD} ]];then
		mkdir -p "${S}/src/main/java" || die
		cd "${S}/src/main/java" || die
		unpack "${MVN_MOD_GEN_SRC}"
	fi

	# if build.xml are present we suppose they re generated from maven pom
	# then we rewrite them, see the rewrite function
	if [[ -n ${JAVA_MAVEN_EANT_BUILD} ]]; then
		for build in $(find "${WORKDIR}" -name build.xml || die);do
			pushd "$(dirname ${build} || die )" > /dev/null || die
			# make specials dir and put generated stuff in there
			local maven_group="" maven_artifact="" maven_version="" maven_dest_dir=""
			if [[ -f ${POM_XML} ]];then
				maven_group=$(${MAVEN_POM_HELPER}     -g -f ${POM_XML})
				maven_group="${maven_group//*:/}"
				maven_artifact=$(${MAVEN_POM_HELPER}  -a -f ${POM_XML})
				maven_artifact="${maven_artifact//*:}"
				maven_version=$(${MAVEN_POM_HELPER}   -v -f ${POM_XML})
				maven_version=${maven_version//*:/}
				maven_dest_dir="src/main/resources/META-INF/maven/${maven_group}/${maven_artifact}"
				maven_pom_properties="${maven_dest_dir}/pom.properties"
				mkdir -p "${maven_dest_dir}" || die
				cp ${POM_XML} "${maven_dest_dir}" || die
				# fake properties
				echo "#Generated by Maven" > ${maven_pom_properties}
				echo "#$(date  +"%a %b %d %H:%M:%S %Z %Y")" >> ${maven_pom_properties}
				echo "version=${maven_version}" >> ${maven_pom_properties}
				echo "groupId=${maven_group}" >> ${maven_pom_properties}
				echo "artifactId=${maven_artifact}" >> ${maven_pom_properties}
			fi
			popd > /dev/null || die
		done
	fi

	# set default source directories and javadoc input directories
	# maven projects may not contain java sources or maybe
	# in a non-standart place, in this case
	# please use JAVA_ANT_JAVADOC_INPUT_DIRS directly
	for project in ${EMAVEN_PROJECTS} ./;do
		if [[ -d "${S}/${project}/${JAVA_MAVEN_SOURCES}/java" ]];then
			JAVA_MAVEN_SRC_DIRS="${JAVA_MAVEN_SRC_DIRS} ${S}/${project//.\//}/${JAVA_MAVEN_SOURCES}/java"
		fi
	done

	if hasq doc ${IUSE} && use doc; then
		JAVA_ANT_JAVADOC_INPUT_DIRS="${JAVA_ANT_JAVADOC_INPUT_DIRS} ${JAVA_MAVEN_SRC_DIRS}"
	fi

	# create temporary class output for classpath and interdeps
	# for multi project based maven ebuilds.
	if [[ -n "${EMAVEN_PROJECTS}" ]];then
		mkdir -p "${JAVA_MAVEN_MULTIPROJECT_CLASSESPATH}" || die
	fi

	# disabling bsfix auto-call as wa need to call it with our maven args.
	JAVA_PKG_BSFIX="off"
}

java-maven-2_src_compile_from_build_xml() {
	# compile order
	EANT_BUILD_TARGET="clean compile jar"

	# remove maven predefined depends to let us control the build
	# steps (order, and not use external jars)
	BSFIX_EXTRA_ARGS="${BSFIX_EXTRA_ARGS} --maven-cleaning"


	# javadoc is controlled as in ant builds, see ant eclass.
	if [[ -n ${EMAVEN_PROJECTS} ]];then
		# use our own classpath and append it tempory classes path in case of maven
		# multiproject
		BSFIX_EXTRA_ARGS="${BSFIX_EXTRA_ARGS} -s ${JAVA_MAVEN_MULTIPROJECT_CLASSESPATH}"
		for module in ${EMAVEN_PROJECTS};do
			einfo "Compiling module: ${module}"
			pushd "${module}" >> /dev/null || die
			[[ -f build.xml ]] && java-ant_bsfix_files build.xml
			java-pkg-2_src_compile
			# need to unset unless bsfix will just die after the first call as
			# EANT_DOC_TARGET cannot be set if JAVA_ANT_JAVADOC_INPUT_DIRS is
			# set.
			EANT_DOC_TARGET=""
			cp -rf target/classes/* "${JAVA_MAVEN_MULTIPROJECT_CLASSESPATH}" || die
			popd >> /dev/null || die
		done
	fi

	if [[ -z "${EMAVEN_PROJECTS}" ]];then
		[[ -f build.xml ]] && java-ant_bsfix_files build.xml
		java-pkg-2_src_compile
	fi

}

java-maven-2_src_compile() {
	if [[ -n "${JAVA_MAVEN_EANT_BUILD}" ]]; then
		java-maven-2_src_compile_from_build_xml
	fi
}

#java-maven-2_src_test() {
# there isnt any maven running out there for the moment
#	emaven test || die "Tests failed"
#}

# do md5sum and sha1sum of a specified file in maven format
java-maven-2_do_sig() {
	if [[ -f ${1} ]];then
		local input_file=$(basename $1)
		md5sum  ${1} | awk '{print $1}' > ${input_file}.md5
		sha1sum ${1} | awk '{print $1}' > ${input_file}.sha1
	else
		die "please specify input file"
	fi
}

# do signatures and install into maven repository
# first arguement is inner repository directory where the files goes
# it must be created before calling this funcion.
# second argument is the file itself
java-maven-2_install_file_into_repo() {
	local rep_dir="${1}" input_file="${2}"
	[[ ! -d ${D}${rep_dir} ]] && die "Directory in repository doesn't exist"
	[[ ! -f ${input_file} ]] && die "Input file doesn't exists"
	java-maven-2_do_sig  "${input_file}"
	insinto "${rep_dir}"
	# in case of jar, do not try to install them as the symlink to the real jar
	# is allready done
	[[ ! -f "${rep_dir}/${input_file}" ]] && doins "${input_file}"
	doins "${input_file}.md5"
	doins "${input_file}.sha1"
}

# if repositories are not created yet, create them
java-maven-2_ensure_repo_exists() {
	if [[ ! -d "${JAVA_MAVEN_SYSTEM_REPOSITORY}" ]];then
		keepdir "${JAVA_MAVEN_SYSTEM_HOME}"
		keepdir "${JAVA_MAVEN_SYSTEM_PLUGINS}"
		keepdir "${JAVA_MAVEN_SYSTEM_REPOSITORY}"
	fi
}

# get versionnated name of a pom taking ${POM_XML} as default
java-maven-2_get_name() {
	local pom="$(java-maven-2_verify_pom ${1})"
	local name="" maven_artifact="" maven_version=""
	if [[ -f ${pom} ]];then
		maven_artifact=$(${MAVEN_POM_HELPER}  -a -f ${pom})
		maven_artifact="${maven_artifact//*:}"
		maven_version=$(${MAVEN_POM_HELPER}   -v -f ${pom})
		maven_version=${maven_version//*:/}
		name=${maven_artifact}-${maven_version}
	fi
	echo ${name}
}

# return the directory into the repo where will be installed all stuff of a
# specified pom.
# take a pom in input or ${POM_XML} as default
java-maven-2_get_repo_dir() {
	local pom="$(java-maven-2_verify_pom ${1})"
	local maven_group="" maven_artifact="" maven_version=""
	maven_group=$(${MAVEN_POM_HELPER}     -g -f ${pom})
	maven_group="${maven_group//*:}"
	maven_artifact=$(${MAVEN_POM_HELPER}  -a -f ${pom})
	maven_artifact="${maven_artifact//*:}"
	maven_version=$(${MAVEN_POM_HELPER}   -v -f ${pom})
	maven_version=${maven_version//*:/}
	# returning in our faked repository directory
	echo "${JAVA_MAVEN_SYSTEM_REPOSITORY}/${maven_group//.//}/${maven_artifact}/${maven_version}"
}

# return ${POM_XML} or arg1 if arg1 is given and is a pom
java-maven-2_verify_pom() {
	local pom="${1}"
	[[ ! -f ${1} ]] && pom=${POM_XML}
	echo ${pom}
}

# prepare to a file in a repository
# all jar installed will be symlink and real location
# will be in /usr/share/PN_SLOT/lib as usual
# don't forget to cd to pom dir before calling
#  * take a maven pom as input and use ${POM_XML} as default pom.
java-maven-2_install_one() {
	local pom="$(java-maven-2_verify_pom ${1})"
	local rep_dir="$(java-maven-2_get_repo_dir ${pom})"
	local myname="$(java-maven-2_get_name ${pom})"
	local myjar="${myname}.jar"
	local maven_pom="${myname}.pom" maven_artifact=""

	java-maven-2_ensure_repo_exists

	if [[ -f ${pom} ]];then
		if [[ -n ${rep_dir} ]];then
			dodir ${rep_dir}
			# install jar if existing
			if [[ -f  target/${myjar} ]];then
				# get a non versionnated name for our jar
				maven_artifact=$(${MAVEN_POM_HELPER}  -a -f ${pom})
				maven_artifact="${maven_artifact//*:}"
				java-pkg_newjar target/${myjar} "${maven_artifact}.jar"
			fi
			if [[ -n ${maven_artifact} ]];then
				local pn_slot="${PN}"
				if [[ ! ${SLOT} == "0" ]] && [[ ! -z ${SLOT} ]];then
					pn_slot="${PN}-${SLOT}"
				fi
				if [[ -f "${D}usr/share/${pn_slot}/lib/${maven_artifact}.jar" ]] \
				   && [[ -f "target/${myjar}" ]];then
					# symlink our jar in the maven repo
					dosym \
					"/usr/share/${pn_slot}/lib/${maven_artifact}.jar" \
					"${rep_dir}/${myjar}"
					# install jar in repo
					# use the target jar instead one in /usr/share/pnslot/lib
					# to allow dosig to generate the right name and version
					pushd target >> /dev/null || die
					java-maven-2_install_file_into_repo ${rep_dir} ${myjar}
					popd >> /dev/null || die
				fi
			fi
			# install pom in repo
			cp ${pom} ${maven_pom} || die
			java-maven-2_install_file_into_repo ${rep_dir} ${maven_pom}
		fi
	fi
}

# basic src_install which can install in most cases (multi and single project
# mode)
java-maven-2_src_install() {
	hasq doc ${IUSE} && use doc \
	&& [[ -n ${JAVA_ANT_JAVADOC_INPUT_DIRS} ]] \
	&& java-pkg_dojavadoc ${JAVA_ANT_JAVADOC_OUTPUT_DIR}
	if hasq source ${IUSE} && use source; then
		for dir in ${JAVA_MAVEN_SRC_DIRS};do
			[[ -d ${dir} ]] && java-pkg_dosrc ${dir}
		done
	fi

	# install all subprojects
	if [[ -n "${EMAVEN_PROJECTS}" ]];then
		for module in ${EMAVEN_PROJECTS};do
			pushd "${module}" >> /dev/null || die
			java-maven-2_install_one
			popd >> /dev/null || die
		done
	fi

	# either install parent pom in multi-projects mode
	# or just install in single project mode
	java-maven-2_install_one
}

EXPORT_FUNCTIONS src_unpack src_compile src_install

