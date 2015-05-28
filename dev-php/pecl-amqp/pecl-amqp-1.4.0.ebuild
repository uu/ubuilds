# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5


PHP_EXT_NAME="amqp"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php5-5 php5-3 php5-4 php5-6"

inherit php-ext-pecl-r2

DESCRIPTION="PHP Bindings for AMQP 0-9-1 compatible brokers."
LICENSE="PHP 3.01"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND="net-libs/rabbitmq-c"
RDEPEND="${DEPEND}"
IUSE=""
