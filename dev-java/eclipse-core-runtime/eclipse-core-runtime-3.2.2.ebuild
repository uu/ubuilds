# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eclipse-rcp

KEYWORDS="~x86"
IUSE=""

DEPEND="=dev-java/eclipse-osgi-3*
	=dev-java/eclipse-equinox-common-3*
	=dev-java/eclipse-core-jobs-3*
	=dev-java/eclipse-core-auth-3*
	=dev-java/eclipse-equinox-preferences-3*
	=dev-java/eclipse-equinox-registry-3*
	=dev-java/eclipse-core-contenttype-3*"
RDEPEND="${DEPEND}"

RCP_ROOT="org.eclipse.rcp.source_3.2.2.r322_v20090104-8pcviKVqd8J7C1U"
RCP_PACKAGE_DIR="org.eclipse.core.runtime_3.2.0.v20090603"
RCP_EXTRA_DEPS="eclipse-osgi-3,eclipse-equinox-common-3,eclipse-core-jobs-3,eclipse-core-auth-3,eclipse-equinox-preferences-3,eclipse-equinox-registry-3,eclipse-core-contenttype-3"
