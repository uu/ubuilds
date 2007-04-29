# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils
DESCRIPTION="Netbeans Platform"
HOMEPAGE="http://www.netbeans.org/products/platform/"
SRC_URI=""
LICENSE="CDDL"
SLOT="6.0"
KEYWORDS="~x86"
IUSE=""
DEPEND=""
RDEPEND=">=virtual/jdk-1.5
	dev-java/javahelp
	dev-java/jnlp-bin
	dev-java/jsr223
	dev-java/swing-layout
	=dev-util/netbeans-apisupport-harness-${SLOT}*
	=dev-util/netbeans-autoupdate-${SLOT}*
	=dev-util/netbeans-autoupdate-services-${SLOT}*
	=dev-util/netbeans-autoupdate-ui-${SLOT}*
	=dev-util/netbeans-boot-${SLOT}*
	=dev-util/netbeans-core-${SLOT}*
	=dev-util/netbeans-core-applemenu-${SLOT}*
	=dev-util/netbeans-core-core-${SLOT}*
	=dev-util/netbeans-core-execution-${SLOT}*
	=dev-util/netbeans-core-favorites-${SLOT}*
	=dev-util/netbeans-core-javahelp-${SLOT}*
	=dev-util/netbeans-core-multiview-${SLOT}*
	=dev-util/netbeans-core-options-${SLOT}*
	=dev-util/netbeans-core-output2-${SLOT}*
	=dev-util/netbeans-core-progress-api-${SLOT}*
	=dev-util/netbeans-core-progress-ui-${SLOT}*
	=dev-util/netbeans-core-sendopts-${SLOT}*
	=dev-util/netbeans-core-settings-${SLOT}*
	=dev-util/netbeans-core-ui-${SLOT}*
	=dev-util/netbeans-core-windows-${SLOT}*
	=dev-util/netbeans-editor-mimelookup-${SLOT}*
	=dev-util/netbeans-editor-mimelookup-impl-${SLOT}*
	=dev-util/netbeans-editor-options-${SLOT}*
	=dev-util/netbeans-graph-visual-api-${SLOT}*
	=dev-util/netbeans-libs-jsr223-${SLOT}*
	=dev-util/netbeans-libs-swing-layout-${SLOT}*
	=dev-util/netbeans-openide-actions-${SLOT}*
	=dev-util/netbeans-openide-awt-${SLOT}*
	=dev-util/netbeans-openide-compat-${SLOT}*
	=dev-util/netbeans-openide-dialogs-${SLOT}*
	=dev-util/netbeans-openide-execution-${SLOT}*
	=dev-util/netbeans-openide-explorer-${SLOT}*
	=dev-util/netbeans-openide-filesystems-${SLOT}*
	=dev-util/netbeans-openide-io-${SLOT}*
	=dev-util/netbeans-openide-loaders-${SLOT}*
	=dev-util/netbeans-openide-masterfs-${SLOT}*
	=dev-util/netbeans-openide-modules-${SLOT}*
	=dev-util/netbeans-openide-nodes-${SLOT}*
	=dev-util/netbeans-openide-options-${SLOT}*
	=dev-util/netbeans-openide-templates-${SLOT}*
	=dev-util/netbeans-openide-text-${SLOT}*
	=dev-util/netbeans-openide-util-${SLOT}*
	=dev-util/netbeans-openide-util-enumerations-${SLOT}*
	=dev-util/netbeans-openide-windows-${SLOT}*
	=dev-util/netbeans-projects-queries-${SLOT}*
	=dev-util/netbeans-swing-plaf-${SLOT}*
	=dev-util/netbeans-swing-tabcontrol-${SLOT}*
	=dev-util/netbeans-tasks-${SLOT}*
	=dev-util/netbeans-updater-${SLOT}*
"

src_compile() { :; }

src_install() { :; }
