# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eclipse-rcp

KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="=dev-java/eclipse-osgi-${SLOT}* =dev-java/eclipse-equinox-common-${SLOT}*"
RDEPEND="${DEPEND}"

RCP_ROOT="org.eclipse.rcp.source_3.3.2.R33x_r20071022-8y8eE9CEV3FspP8HJrY1M2dS"
RCP_PACKAGE_DIR="org.eclipse.update.configurator_3.2.101.R33x_v20070810"
RCP_EXTRA_DEPS="eclipse-osgi-${SLOT},eclipse-equinox-common-${SLOT}"
