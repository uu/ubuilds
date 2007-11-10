# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eclipse-rcp

KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="=dev-java/eclipse-osgi-3* =dev-java/eclipse-equinox-common-3*"
RDEPEND="${DEPEND}"

RCP_ROOT="org.eclipse.rcp.source_3.3.2.R33x_r20071022-8y8eE9CEV3FspP8HJrY1M2dS"
RCP_PACKAGE_DIR="org.eclipse.core.runtime.compatibility.auth_3.2.100.v20070502"
RCP_EXTRA_DEPS="eclipse-osgi-3,eclipse-equinox-common-3"
