# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

# Maintainer notes:
# - http_rewrite-independent pcre-support makes sense for matching locations without an actual rewrite
# - any http-module activates the main http-functionality and overrides USE=-http
# - keep the following requirements in mind before adding external modules:
#	* alive upstream
#	* sane packaging
#	* builds cleanly
#	* does not need a patch for nginx core
# - TODO: test the google-perftools module (included in vanilla tarball)

# prevent perl-module from adding automagic perl DEPENDs
GENTOO_DEPEND_ON_PERL="no"

# devel_kit (https://github.com/simpl/ngx_devel_kit, BSD license)
DEVEL_KIT_MODULE_PV="0.3.0rc1"
DEVEL_KIT_MODULE_P="ngx_devel_kit-${DEVEL_KIT_MODULE_PV}-r1"
DEVEL_KIT_MODULE_URI="https://github.com/simpl/ngx_devel_kit/archive/v${DEVEL_KIT_MODULE_PV}.tar.gz"
DEVEL_KIT_MODULE_WD="${WORKDIR}/ngx_devel_kit-${DEVEL_KIT_MODULE_PV}"

# http_uploadprogress (https://github.com/masterzen/nginx-upload-progress-module, BSD-2 license)
HTTP_UPLOAD_PROGRESS_MODULE_PV="0.9.1"
HTTP_UPLOAD_PROGRESS_MODULE_P="ngx_http_upload_progress-${HTTP_UPLOAD_PROGRESS_MODULE_PV}-r1"
HTTP_UPLOAD_PROGRESS_MODULE_URI="https://github.com/masterzen/nginx-upload-progress-module/archive/v${HTTP_UPLOAD_PROGRESS_MODULE_PV}.tar.gz"
HTTP_UPLOAD_PROGRESS_MODULE_WD="${WORKDIR}/nginx-upload-progress-module-${HTTP_UPLOAD_PROGRESS_MODULE_PV}"

# http_headers_more (https://github.com/agentzh/headers-more-nginx-module, BSD license)
HTTP_HEADERS_MORE_MODULE_PV="0.30rc1"
HTTP_HEADERS_MORE_MODULE_P="ngx_http_headers_more-${HTTP_HEADERS_MORE_MODULE_PV}"
HTTP_HEADERS_MORE_MODULE_URI="https://github.com/agentzh/headers-more-nginx-module/archive/v${HTTP_HEADERS_MORE_MODULE_PV}.tar.gz"
HTTP_HEADERS_MORE_MODULE_WD="${WORKDIR}/headers-more-nginx-module-${HTTP_HEADERS_MORE_MODULE_PV}"

# http_cache_purge (http://labs.frickle.com/nginx_ngx_cache_purge/, BSD-2 license)
HTTP_CACHE_PURGE_MODULE_PV="2.3"
HTTP_CACHE_PURGE_MODULE_P="ngx_http_cache_purge-${HTTP_CACHE_PURGE_MODULE_PV}"
HTTP_CACHE_PURGE_MODULE_URI="http://labs.frickle.com/files/ngx_cache_purge-${HTTP_CACHE_PURGE_MODULE_PV}.tar.gz"
HTTP_CACHE_PURGE_MODULE_WD="${WORKDIR}/ngx_cache_purge-${HTTP_CACHE_PURGE_MODULE_PV}"

# http_slowfs_cache (http://labs.frickle.com/nginx_ngx_slowfs_cache/, BSD-2 license)
HTTP_SLOWFS_CACHE_MODULE_PV="1.10"
HTTP_SLOWFS_CACHE_MODULE_P="ngx_http_slowfs_cache-${HTTP_SLOWFS_CACHE_MODULE_PV}"
HTTP_SLOWFS_CACHE_MODULE_URI="http://labs.frickle.com/files/ngx_slowfs_cache-${HTTP_SLOWFS_CACHE_MODULE_PV}.tar.gz"
HTTP_SLOWFS_CACHE_MODULE_WD="${WORKDIR}/ngx_slowfs_cache-${HTTP_SLOWFS_CACHE_MODULE_PV}"

# http_fancyindex (https://github.com/aperezdc/ngx-fancyindex, BSD license)
HTTP_FANCYINDEX_MODULE_PV="0.3.6"
HTTP_FANCYINDEX_MODULE_P="ngx_http_fancyindex-${HTTP_FANCYINDEX_MODULE_PV}"
HTTP_FANCYINDEX_MODULE_URI="https://github.com/aperezdc/ngx-fancyindex/archive/v${HTTP_FANCYINDEX_MODULE_PV}.tar.gz"
HTTP_FANCYINDEX_MODULE_WD="${WORKDIR}/ngx-fancyindex-${HTTP_FANCYINDEX_MODULE_PV}"

# http_lua (https://github.com/openresty/lua-nginx-module, BSD license)
HTTP_LUA_MODULE_PV="0.10.2"
HTTP_LUA_MODULE_P="ngx_http_lua-${HTTP_LUA_MODULE_PV}"
HTTP_LUA_MODULE_URI="https://github.com/openresty/lua-nginx-module/archive/v${HTTP_LUA_MODULE_PV}.tar.gz"
HTTP_LUA_MODULE_WD="${WORKDIR}/lua-nginx-module-${HTTP_LUA_MODULE_PV}"

# http_auth_pam (https://github.com/stogh/ngx_http_auth_pam_module/, http://web.iti.upv.es/~sto/nginx/, BSD-2 license)
HTTP_AUTH_PAM_MODULE_PV="1.5"
HTTP_AUTH_PAM_MODULE_P="ngx_http_auth_pam-${HTTP_AUTH_PAM_MODULE_PV}"
HTTP_AUTH_PAM_MODULE_URI="https://github.com/stogh/ngx_http_auth_pam_module/archive/v${HTTP_AUTH_PAM_MODULE_PV}.tar.gz"
HTTP_AUTH_PAM_MODULE_WD="${WORKDIR}/ngx_http_auth_pam_module-${HTTP_AUTH_PAM_MODULE_PV}"

# http_upstream_check (https://github.com/yaoweibin/nginx_upstream_check_module, BSD license)
HTTP_UPSTREAM_CHECK_MODULE_PV="0.3.0"
HTTP_UPSTREAM_CHECK_MODULE_P="ngx_http_upstream_check-${HTTP_UPSTREAM_CHECK_MODULE_PV}"
HTTP_UPSTREAM_CHECK_MODULE_URI="https://github.com/yaoweibin/nginx_upstream_check_module/archive/v${HTTP_UPSTREAM_CHECK_MODULE_PV}.tar.gz"
HTTP_UPSTREAM_CHECK_MODULE_WD="${WORKDIR}/nginx_upstream_check_module-${HTTP_UPSTREAM_CHECK_MODULE_PV}"

# http_metrics (https://github.com/zenops/ngx_metrics, BSD license)
HTTP_METRICS_MODULE_PV="0.1.1"
HTTP_METRICS_MODULE_P="ngx_metrics-${HTTP_METRICS_MODULE_PV}"
HTTP_METRICS_MODULE_URI="https://github.com/madvertise/ngx_metrics/archive/v${HTTP_METRICS_MODULE_PV}.tar.gz"
HTTP_METRICS_MODULE_WD="${WORKDIR}/ngx_metrics-${HTTP_METRICS_MODULE_PV}"

# naxsi-core (https://github.com/nbs-system/naxsi, GPLv2+)
HTTP_NAXSI_MODULE_PV="0.55rc1"
HTTP_NAXSI_MODULE_P="ngx_http_naxsi-${HTTP_NAXSI_MODULE_PV}"
HTTP_NAXSI_MODULE_URI="https://github.com/nbs-system/naxsi/archive/${HTTP_NAXSI_MODULE_PV}.tar.gz"
HTTP_NAXSI_MODULE_WD="${WORKDIR}/naxsi-${HTTP_NAXSI_MODULE_PV}/naxsi_src"

# nginx-rtmp-module (https://github.com/arut/nginx-rtmp-module, BSD license)
RTMP_MODULE_PV="1.1.7"
RTMP_MODULE_P="ngx_rtmp-${RTMP_MODULE_PV}"
RTMP_MODULE_URI="https://github.com/arut/nginx-rtmp-module/archive/v${RTMP_MODULE_PV}.tar.gz"
RTMP_MODULE_WD="${WORKDIR}/nginx-rtmp-module-${RTMP_MODULE_PV}"

# nginx-dav-ext-module (https://github.com/arut/nginx-dav-ext-module, BSD license)
HTTP_DAV_EXT_MODULE_PV="0.0.3"
HTTP_DAV_EXT_MODULE_P="ngx_http_dav_ext-${HTTP_DAV_EXT_MODULE_PV}"
HTTP_DAV_EXT_MODULE_URI="https://github.com/arut/nginx-dav-ext-module/archive/v${HTTP_DAV_EXT_MODULE_PV}.tar.gz"
HTTP_DAV_EXT_MODULE_WD="${WORKDIR}/nginx-dav-ext-module-${HTTP_DAV_EXT_MODULE_PV}"

# echo-nginx-module (https://github.com/agentzh/echo-nginx-module, BSD license)
HTTP_ECHO_MODULE_PV="0.58"
HTTP_ECHO_MODULE_P="ngx_http_echo-${HTTP_ECHO_MODULE_PV}"
HTTP_ECHO_MODULE_URI="https://github.com/agentzh/echo-nginx-module/archive/v${HTTP_ECHO_MODULE_PV}.tar.gz"
HTTP_ECHO_MODULE_WD="${WORKDIR}/echo-nginx-module-${HTTP_ECHO_MODULE_PV}"

# mod_security for nginx (https://modsecurity.org/, Apache-2.0)
# keep the MODULE_P here consistent with upstream to avoid tarball duplication
HTTP_SECURITY_MODULE_PV="2.9.1"
HTTP_SECURITY_MODULE_P="modsecurity-${HTTP_SECURITY_MODULE_PV}"
HTTP_SECURITY_MODULE_URI="https://www.modsecurity.org/tarball/${HTTP_SECURITY_MODULE_PV}/${HTTP_SECURITY_MODULE_P}.tar.gz"
HTTP_SECURITY_MODULE_WD="${WORKDIR}/${HTTP_SECURITY_MODULE_P}"

# push-stream-module (http://www.nginxpushstream.com, https://github.com/wandenberg/nginx-push-stream-module, GPL-3)
HTTP_PUSH_STREAM_MODULE_PV="0.5.1"
HTTP_PUSH_STREAM_MODULE_P="ngx_http_push_stream-${HTTP_PUSH_STREAM_MODULE_PV}"
HTTP_PUSH_STREAM_MODULE_URI="https://github.com/wandenberg/nginx-push-stream-module/archive/${HTTP_PUSH_STREAM_MODULE_PV}.tar.gz"
HTTP_PUSH_STREAM_MODULE_WD="${WORKDIR}/nginx-push-stream-module-${HTTP_PUSH_STREAM_MODULE_PV}"

# sticky-module (https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng, BSD-2)
HTTP_STICKY_MODULE_PV="1.2.6"
HTTP_STICKY_MODULE_P="nginx_http_sticky_module_ng-${HTTP_STICKY_MODULE_PV}"
HTTP_STICKY_MODULE_URI="https://bitbucket.org/nginx-goodies/nginx-sticky-module-ng/get/${HTTP_STICKY_MODULE_PV}.tar.bz2"
HTTP_STICKY_MODULE_WD="${WORKDIR}/nginx-goodies-nginx-sticky-module-ng-c78b7dd79d0d"

# mogilefs-module (https://github.com/vkholodkov/nginx-mogilefs-module, BSD-2)
HTTP_MOGILEFS_MODULE_PV="1.0.4"
HTTP_MOGILEFS_MODULE_P="ngx_mogilefs_module-${HTTP_MOGILEFS_MODULE_PV}"
HTTP_MOGILEFS_MODULE_URI="https://github.com/vkholodkov/nginx-mogilefs-module/archive/${HTTP_MOGILEFS_MODULE_PV}.tar.gz"
HTTP_MOGILEFS_MODULE_WD="${WORKDIR}/nginx_mogilefs_module-${HTTP_MOGILEFS_MODULE_PV}"

# memc-module (https://github.com/openresty/memc-nginx-module, BSD-2)
HTTP_MEMC_MODULE_PV="0.16"
HTTP_MEMC_MODULE_P="ngx_memc_module-${HTTP_MEMC_MODULE_PV}"
HTTP_MEMC_MODULE_URI="https://github.com/openresty/memc-nginx-module/archive/v${HTTP_MEMC_MODULE_PV}.tar.gz"
HTTP_MEMC_MODULE_WD="${WORKDIR}/memc-nginx-module-${HTTP_MEMC_MODULE_PV}"

# nginx-ldap-auth-module (https://github.com/kvspb/nginx-auth-ldap, BSD-2)
HTTP_LDAP_MODULE_PV="8517bb05ecc896b54429ca5e95137b0a386bd41a"
HTTP_LDAP_MODULE_P="nginx-auth-ldap-${HTTP_LDAP_MODULE_PV}"
HTTP_LDAP_MODULE_URI="https://github.com/kvspb/nginx-auth-ldap/archive/${HTTP_LDAP_MODULE_PV}.tar.gz"
HTTP_LDAP_MODULE_WD="${WORKDIR}/nginx-auth-ldap-${HTTP_LDAP_MODULE_PV}"

# We handle deps below ourselves
SSL_DEPS_SKIP=1

# http_redis (https://github.com/openresty/redis2-nginx-module, BSD license)
HTTP_REDIS_MODULE_PV="0.12"
HTTP_REDIS_MODULE_P="ngx_redis-${HTTP_REDIS_MODULE_PV}"
HTTP_REDIS_MODULE_SHA1="e4a157f"
HTTP_REDIS_MODULE_URI="http://github.com/openresty/redis2-nginx-module/tarball/v${HTTP_REDIS_MODULE_PV}"

# http_push (http://pushmodule.slact.net/, MIT license)
HTTP_PUSH_MODULE_PV="0.73"
HTTP_PUSH_MODULE_P="nginx_http_push_module-${HTTP_PUSH_MODULE_PV}"

# HTTP Upload module from Valery Kholodkov
# (http://www.grid.net.ru/nginx/upload.en.html, BSD license)
HTTP_UPLOAD_MODULE_PV="2.2.0"
HTTP_UPLOAD_MODULE_P="nginx_upload_module-${HTTP_UPLOAD_MODULE_PV}"

# ey-balancer/maxconn module (https://github.com/msva/nginx-ey-balancer, as-is)
HTTP_EY_BALANCER_MODULE_PV="0.0.9"
HTTP_EY_BALANCER_MODULE_P="nginx-ey-balancer-${HTTP_EY_BALANCER_MODULE_PV}"
HTTP_EY_BALANCER_MODULE_SHA1="c650e1f"

# https://github.com/openresty/drizzle-nginx-module/releases
HTTP_DRIZZLE_MODULE_PV="0.1.9"
HTTP_DRIZZLE_MODULE_P="drizzle-nginx-module-${HTTP_DRIZZLE_MODULE_PV}"
HTTP_DRIZZLE_MODULE_SHA1="7d2b1d9"

# NginX for-input module (https://github.com/calio/form-input-nginx-module, BSD)
HTTP_FORM_INPUT_MODULE_PV="0.11"
HTTP_FORM_INPUT_MODULE_P="form-input-nginx-module-${HTTP_FORM_INPUT_MODULE_PV}"
HTTP_FORM_INPUT_MODULE_SHA1="bab98b4"

# NginX RDS-JSON module (https://github.com/openresty/rds-json-nginx-module, BSD)
HTTP_RDS_JSON_MODULE_PV="0.14"
HTTP_RDS_JSON_MODULE_P="rds-json-nginx-module-${HTTP_RDS_JSON_MODULE_PV}"
HTTP_RDS_JSON_MODULE_SHA1="b73fc29"

# NginX SRCache module (https://github.com/openresty/srcache-nginx-module, BSD)
HTTP_SRCACHE_MODULE_PV="0.30"
HTTP_SRCACHE_MODULE_P="srcache-nginx-module-${HTTP_SRCACHE_MODULE_PV}"
HTTP_SRCACHE_MODULE_SHA1="b3fd3e2"

# NginX Set-Misc module (https://github.com/openresty/set-misc-nginx-module, BSD)
HTTP_SET_MISC_MODULE_PV="0.30"
HTTP_SET_MISC_MODULE_P="set-misc-nginx-module-${HTTP_SET_MISC_MODULE_PV}"
HTTP_SET_MISC_MODULE_SHA1="4637b0d"
HTTP_SET_MISC_MODULE_URI="http://github.com/openresty/set-misc-nginx-module/tarball/v${HTTP_SET_MISC_MODULE_PV}"

# NginX Set-Misc module (https://github.com/fluent/nginx-fluentd-module/releases, BSD)
HTTP_FLUENTD_MODULE_PV="0.3"
HTTP_FLUENTD_MODULE_P="fluentd-nginx-module-${HTTP_FLUENTD_MODULE_PV}"
HTTP_FLUENTD_MODULE_SHA1="cf4ef2a"
HTTP_FLUENTD_MODULE_URI="https://github.com/fluent/nginx-fluentd-module/tarball/v${HTTP_FLUENTD_MODULE_PV}"

# NginX XSS module (https://github.com/openresty/xss-nginx-module, BSD)
HTTP_XSS_MODULE_PV="0.05"
HTTP_XSS_MODULE_P="xss-nginx-module-${HTTP_XSS_MODULE_PV}"
HTTP_XSS_MODULE_SHA1="368c47b"

# NginX Array-Var module (https://github.com/openresty/array-var-nginx-module, BSD)
HTTP_ARRAY_VAR_MODULE_PV="0.04"
HTTP_ARRAY_VAR_MODULE_P="array-var-nginx-module-${HTTP_ARRAY_VAR_MODULE_PV}"
HTTP_ARRAY_VAR_MODULE_SHA1="3d435fc"

# NginX Iconv module (https://github.com/calio/iconv-nginx-module, BSD)
HTTP_ICONV_MODULE_PV="0.13"
HTTP_ICONV_MODULE_P="iconv-nginx-module-${HTTP_ICONV_MODULE_PV}"
HTTP_ICONV_MODULE_SHA1="cc3bc69"

# NginX Featured mecached module (http://labs.frickle.com/nginx_ngx_postgres, BSD-2)
HTTP_POSTGRES_MODULE_PV="1.0rc5"
HTTP_POSTGRES_MODULE_P="ngx_postgres-${HTTP_POSTGRES_MODULE_PV}"
HTTP_POSTGRES_MODULE_SHA1="f9479fb"

# NginX coolkit module (http://labs.frickle.com/nginx_ngx_coolkit/, BSD-2)
HTTP_COOLKIT_MODULE_PV="1.0"
HTTP_COOLKIT_MODULE_P="ngx_coolkit-${HTTP_COOLKIT_MODULE_PV}"

# NginX Supervisord module (http://labs.frickle.com/nginx_ngx_supervisord/, BSD-2)
HTTP_SUPERVISORD_MODULE_PV="1.4"
HTTP_SUPERVISORD_MODULE_P="ngx_supervisord-${HTTP_SUPERVISORD_MODULE_PV}"

# NginX Auth Request module (BSD)
HTTP_AUTH_REQUEST_MODULE_PV="0.2"
HTTP_AUTH_REQUEST_MODULE_P="ngx_http_auth_request_module-${HTTP_AUTH_REQUEST_MODULE_PV}"

CHUNKIN_MODULE_PV="0.23"
CHUNKIN_MODULE_SHA1="81c04f6"

# tidehunter (https://github.com/ruoshan/tidehunter)
HTTP_TIDEHUNTER_MODULE_PV="202cd81739976b6cff17a6a1504f7002c128bb71"
HTTP_TIDEHUNTER_MODULE_P="ngx_tidehunter-${HTTP_TIDEHUNTER_MODULE_PV}"
HTTP_TIDEHUNTER_MODULE_URI="https://github.com/ruoshan/tidehunter/archive/${HTTP_TIDEHUNTER_MODULE_PV}.zip"
HTTP_TIDEHUNTER_MODULE_WD="${WORKDIR}/tidehunter-${HTTP_TIDEHUNTER_MODULE_PV}/"

# add the feature of tcp proxy with nginx, with health check and status monitor
# (git://github.com/yaoweibin/nginx_tcp_proxy_module.git, AS-IS)
HTTP_TCP_PROXY_MODULE_PV="0.4.5"
HTTP_TCP_PROXY_MODULE_P="ngx-tcp-proxy"
HTTP_TCP_PROXY_MODULE_SHA1="4a8c314"
HTTP_TCP_PROXY_MODULE_URI="https://github.com/dreamcommerce/nginx_tcp_proxy_module/archive/dc.zip"

# ajp-module (https://github.com/yaoweibin/nginx_ajp_module, BSD-2)
HTTP_AJP_MODULE_PV="0.3.0"
HTTP_AJP_MODULE_P="ngx_http_ajp_module-${HTTP_AJP_MODULE_PV}"
HTTP_AJP_MODULE_URI="https://github.com/yaoweibin/nginx_ajp_module/archive/v${HTTP_AJP_MODULE_PV}.tar.gz"
HTTP_AJP_MODULE_WD="${WORKDIR}/nginx_ajp_module-${HTTP_AJP_MODULE_PV}"

# eval-module (http://www.grid.net.ru/nginx/eval.ru.html, BSD-2)
HTTP_EVAL_MODULE_PV="1.0.3"
HTTP_EVAL_MODULE_P="ngx_eval_module-${HTTP_EVAL_MODULE_PV}"
HTTP_EVAL_MODULE_URI="https://github.com/vkholodkov/nginx-eval-module/archive/${HTTP_EVAL_MODULE_PV}.tar.gz"
HTTP_EVAL_MODULE_WD="${WORKDIR}/nginx-eval-module-${HTTP_EVAL_MODULE_PV}"

# websockify (https://github.com/tg123/websockify-nginx-module)
HTTP_WEBSOCKIFY_MODULE_PV="0.0.3"
HTTP_WEBSOCKIFY_MODULE_P="ngx_websockify_module-${HTTP_WEBSOCKIFY_MODULE_PV}"
HTTP_WEBSOCKIFY_MODULE_URI="https://github.com/tg123/websockify-nginx-module/archive/v${HTTP_WEBSOCKIFY_MODULE_PV}.tar.gz"
HTTP_WEBSOCKIFY_MODULE_WD="${WORKDIR}/websockify-nginx-module-${HTTP_WEBSOCKIFY_MODULE_PV}"

# poller(https://github.com/dbcode/nginx-poller-module)
HTTP_POLLER_MODULE_PV="406c83c9e57ca2a613fe361d639a29bdeddf63ca" # no releases :(
HTTP_POLLER_MODULE_P="ngx_poller_module-${HTTP_POLLER_MODULE_PV}"
HTTP_POLLER_MODULE_URI="https://github.com/dbcode/nginx-poller-module/archive/${HTTP_POLLER_MODULE_PV}.zip"
HTTP_POLLER_MODULE_WD="${WORKDIR}/nginx-poller-module-${HTTP_POLLER_MODULE_PV}"

# bodytime(https://github.com/koordinates/bodytime-nginx-module)
HTTP_BODYTIME_MODULE_PV="8b47f5c049b8afd5b0d639f747e47446597c22e4"
HTTP_BODYTIME_MODULE_P="ngx_bodytime_module-${HTTP_BODYTIME_MODULE_PV}"
HTTP_BODYTIME_MODULE_URI="https://github.com/koordinates/bodytime-nginx-module/archive/${HTTP_BODYTIME_MODULE_PV}.zip"
HTTP_BODYTIME_MODULE_WD="${WORKDIR}/bodytime-nginx-module-${HTTP_BODYTIME_MODULE_PV}"

# nchan https://github.com/slact/nchan/releases
HTTP_NCHAN_MODULE_PV="0.99.4"
HTTP_NCHAN_MODULE_P="ngx_http_nchan_module-${HTTP_NCHAN_MODULE_PV}"
HTTP_NCHAN_MODULE_SHA1="9fdc668"

inherit ssl-cert toolchain-funcs perl-module flag-o-matic user systemd versionator multilib

DESCRIPTION="Robust, small and high performance http and reverse proxy server"
HOMEPAGE="http://nginx.org"
SRC_URI="http://nginx.org/download/${P}.tar.gz
	${DEVEL_KIT_MODULE_URI} -> ${DEVEL_KIT_MODULE_P}.tar.gz
	nginx_modules_http_upload_progress? ( ${HTTP_UPLOAD_PROGRESS_MODULE_URI} -> ${HTTP_UPLOAD_PROGRESS_MODULE_P}.tar.gz )
	nginx_modules_http_headers_more? ( ${HTTP_HEADERS_MORE_MODULE_URI} -> ${HTTP_HEADERS_MORE_MODULE_P}.tar.gz )
	nginx_modules_http_cache_purge? ( ${HTTP_CACHE_PURGE_MODULE_URI} -> ${HTTP_CACHE_PURGE_MODULE_P}.tar.gz )
	nginx_modules_http_slowfs_cache? ( ${HTTP_SLOWFS_CACHE_MODULE_URI} -> ${HTTP_SLOWFS_CACHE_MODULE_P}.tar.gz )
	nginx_modules_http_fancyindex? ( ${HTTP_FANCYINDEX_MODULE_URI} -> ${HTTP_FANCYINDEX_MODULE_P}.tar.gz )
	nginx_modules_http_lua? ( ${HTTP_LUA_MODULE_URI} -> ${HTTP_LUA_MODULE_P}.tar.gz )
	nginx_modules_http_auth_pam? ( ${HTTP_AUTH_PAM_MODULE_URI} -> ${HTTP_AUTH_PAM_MODULE_P}.tar.gz )
	nginx_modules_http_upstream_check? ( ${HTTP_UPSTREAM_CHECK_MODULE_URI} -> ${HTTP_UPSTREAM_CHECK_MODULE_P}.tar.gz )
	nginx_modules_http_metrics? ( ${HTTP_METRICS_MODULE_URI} -> ${HTTP_METRICS_MODULE_P}.tar.gz )
	nginx_modules_http_naxsi? ( ${HTTP_NAXSI_MODULE_URI} -> ${HTTP_NAXSI_MODULE_P}.tar.gz )
	rtmp? ( ${RTMP_MODULE_URI} -> ${RTMP_MODULE_P}.tar.gz )
	nginx_modules_http_dav_ext? ( ${HTTP_DAV_EXT_MODULE_URI} -> ${HTTP_DAV_EXT_MODULE_P}.tar.gz )
	nginx_modules_http_echo? ( ${HTTP_ECHO_MODULE_URI} -> ${HTTP_ECHO_MODULE_P}.tar.gz )
	nginx_modules_http_security? ( ${HTTP_SECURITY_MODULE_URI} -> ${HTTP_SECURITY_MODULE_P}.tar.gz )
	nginx_modules_http_push_stream? ( ${HTTP_PUSH_STREAM_MODULE_URI} -> ${HTTP_PUSH_STREAM_MODULE_P}.tar.gz )
	nginx_modules_http_sticky? ( ${HTTP_STICKY_MODULE_URI} -> ${HTTP_STICKY_MODULE_P}.tar.bz2 )
	nginx_modules_http_mogilefs? ( ${HTTP_MOGILEFS_MODULE_URI} -> ${HTTP_MOGILEFS_MODULE_P}.tar.gz )
	nginx_modules_http_memc? ( ${HTTP_MEMC_MODULE_URI} -> ${HTTP_MEMC_MODULE_P}.tar.gz )
	nginx_modules_http_auth_ldap? ( ${HTTP_LDAP_MODULE_URI} -> ${HTTP_LDAP_MODULE_P}.tar.gz )
	nginx_modules_http_redis? ( ${HTTP_REDIS_MODULE_URI} ->	${HTTP_REDIS_MODULE_P}.tar.gz )
	nginx_modules_http_push? ( https://github.com/slact/nginx_http_push_module/archive/v${HTTP_PUSH_MODULE_PV}.tar.gz -> ${HTTP_PUSH_MODULE_P}.tar.gz )
	nginx_modules_http_upload? ( http://www.grid.net.ru/nginx/download/${HTTP_UPLOAD_MODULE_P}.tar.gz )
	nginx_modules_http_ey_balancer? ( https://github.com/msva/nginx-ey-balancer/tarball/v${HTTP_EY_BALANCER_MODULE_PV} -> ${HTTP_EY_BALANCER_MODULE_P}.tar.gz )
	nginx_modules_http_drizzle? ( https://github.com/chaoslawful/drizzle-nginx-module/tarball/v${HTTP_DRIZZLE_MODULE_PV} -> ${HTTP_DRIZZLE_MODULE_P}.tar.gz )
	nginx_modules_http_form_input? ( https://github.com/calio/form-input-nginx-module/tarball/v${HTTP_FORM_INPUT_MODULE_PV} -> ${HTTP_FORM_INPUT_MODULE_P}.tar.gz )
	nginx_modules_http_rds_json? ( https://github.com/openresty/rds-json-nginx-module/tarball/v${HTTP_RDS_JSON_MODULE_PV} -> ${HTTP_RDS_JSON_MODULE_P}.tar.gz )
	nginx_modules_http_srcache? ( https://github.com/openresty/srcache-nginx-module/tarball/v${HTTP_SRCACHE_MODULE_PV} -> ${HTTP_SRCACHE_MODULE_P}.tar.gz )
	nginx_modules_http_set_misc? ( ${HTTP_SET_MISC_MODULE_URI} -> ${HTTP_SET_MISC_MODULE_P}.tar.gz )
	nginx_modules_http_fluentd? ( ${HTTP_FLUENTD_MODULE_URI} -> ${HTTP_FLUENTD_MODULE_P}.tar.gz )
	nginx_modules_http_xss? ( https://github.com/openresty/xss-nginx-module/tarball/v${HTTP_XSS_MODULE_PV} -> ${HTTP_XSS_MODULE_P}.tar.gz )
	nginx_modules_http_array_var? ( https://github.com/openresty/array-var-nginx-module/tarball/v${HTTP_ARRAY_VAR_MODULE_PV} -> ${HTTP_ARRAY_VAR_MODULE_P}.tar.gz )
	nginx_modules_http_iconv? ( https://github.com/calio/iconv-nginx-module/tarball/v${HTTP_ICONV_MODULE_PV} -> ${HTTP_ICONV_MODULE_P}.tar.gz )
	nginx_modules_http_nchan? ( https://github.com/slact/nchan/tarball/v${HTTP_NCHAN_MODULE_PV} -> ${HTTP_NCHAN_MODULE_P}.tar.gz )
	nginx_modules_http_postgres? ( https://github.com/FRiCKLE/ngx_postgres/tarball/${HTTP_POSTGRES_MODULE_PV} -> ${HTTP_POSTGRES_MODULE_P}.tar.gz )
	nginx_modules_http_coolkit? ( https://codeload.github.com/FRiCKLE/ngx_coolkit/legacy.tar.gz/master -> ${HTTP_COOLKIT_MODULE_P}.tar.gz )
	nginx_modules_http_supervisord? ( https://codeload.github.com/FRiCKLE/ngx_supervisord/legacy.tar.gz/master -> ${HTTP_SUPERVISORD_MODULE_P}.tar.gz )
	nginx_modules_http_tcp_proxy? (	${HTTP_TCP_PROXY_MODULE_URI} -> ${HTTP_TCP_PROXY_MODULE_P}-${HTTP_TCP_PROXY_MODULE_PV}.zip )
	nginx_modules_http_pagespeed? (	http://github.com/pagespeed/ngx_pagespeed/archive/master.zip ->	ngx_pagespeed.zip )
	nginx_modules_http_pinba? 	  ( http://github.com/tony2001/ngx_http_pinba_module/archive/master.zip ->	ngx_pinba.zip )
	nginx_modules_http_zip? 	  ( https://github.com/evanmiller/mod_zip/archive/master.zip ->	ngx_zip.zip )
	nginx_modules_http_tidehunter? ( ${HTTP_TIDEHUNTER_MODULE_URI} -> ${HTTP_TIDEHUNTER_MODULE_P}.zip )
	nginx_modules_http_ajp? ( ${HTTP_AJP_MODULE_URI} -> ${HTTP_AJP_MODULE_P}.tar.gz )
	nginx_modules_http_eval? ( ${HTTP_EVAL_MODULE_URI} -> ${HTTP_EVAL_MODULE_P}.tar.gz )
	nginx_modules_http_websockify? ( ${HTTP_WEBSOCKIFY_MODULE_URI} -> ${HTTP_WEBSOCKIFY_MODULE_P}.tar.gz )
	nginx_modules_http_poller? ( ${HTTP_POLLER_MODULE_URI} -> ${HTTP_POLLER_MODULE_P}.zip )
	nginx_modules_http_bodytime? ( ${HTTP_BODYTIME_MODULE_URI} -> ${HTTP_BODYTIME_MODULE_P}.zip )
	rrd? ( http://wiki.nginx.org/images/9/9d/Mod_rrd_graph-0.2.0.tar.gz )
	chunk? ( https://github.com/agentzh/chunkin-nginx-module/tarball/v${CHUNKIN_MODULE_PV} -> chunkin-nginx-module-${CHUNKIN_MODULE_PV}.tgz )"

LICENSE="BSD-2 BSD SSLeay MIT GPL-2 GPL-2+
	nginx_modules_http_security? ( Apache-2.0 )
	nginx_modules_http_push_stream? ( GPL-3 )"

SLOT="mainline"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"

NGINX_MODULES_STD="access auth_basic autoindex browser charset empty_gif
	fastcgi geo gzip limit_req limit_conn map memcached proxy referer
	rewrite scgi ssi split_clients upstream_ip_hash userid uwsgi"
NGINX_MODULES_OPT="addition auth_request dav degradation flv geoip gunzip
	gzip_static image_filter mp4 perl random_index realip secure_link
	slice stub_status sub xslt"
NGINX_MODULES_STREAM="access limit_conn upstream"
NGINX_MODULES_MAIL="imap pop3 smtp"
NGINX_MODULES_3RD="
	http_upload_progress
	http_headers_more
	http_cache_purge
	http_slowfs_cache
	http_fancyindex
	http_lua
	http_auth_pam
	http_upstream_check
	http_metrics
	http_naxsi
	http_dav_ext
	http_echo
	http_security
	http_push_stream
	http_sticky
	http_ajp
	http_mogilefs
	http_memc
	http_auth_ldap
	http_redis
	http_push
	http_upload
	http_ey_balancer
	http_form_input
	http_drizzle
	http_rds_json
	http_postgres
	http_coolkit
	http_auth_request
	http_set_misc
	http_srcache
	http_supervisord
	http_array_var
	http_xss
	http_iconv
	http_nchan
	http_upload_progress
	http_tcp_proxy
	http_pagespeed
	http_pinba
	http_zip
	http_tidehunter
	http_fluentd
	http_eval
	http_websockify
	http_poller
	http_bodytime"

IUSE="aio debug +http +http2 +http-cache ipv6 libatomic libressl luajit +pcre
	pcre-jit rtmp selinux ssl threads userland_GNU vim-syntax rrd perftools chunk"

for mod in $NGINX_MODULES_STD; do
	IUSE="${IUSE} +nginx_modules_http_${mod}"
done

for mod in $NGINX_MODULES_OPT; do
	IUSE="${IUSE} nginx_modules_http_${mod}"
done

for mod in $NGINX_MODULES_STREAM; do
	IUSE="${IUSE} nginx_modules_stream_${mod}"
done

for mod in $NGINX_MODULES_MAIL; do
	IUSE="${IUSE} nginx_modules_mail_${mod}"
done

for mod in $NGINX_MODULES_3RD; do
	IUSE="${IUSE} nginx_modules_${mod}"
done

# Add so we can warn users updating about config changes
# @TODO: jbergstroem: remove on next release series
IUSE="${IUSE} nginx_modules_http_spdy"

CDEPEND="
	pcre? ( >=dev-libs/libpcre-4.2 )
	pcre-jit? ( >=dev-libs/libpcre-8.20[jit] )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)
	http2? (
		!libressl? ( >=dev-libs/openssl-1.0.1c:0= )
		libressl? ( dev-libs/libressl:= )
	)
	http-cache? (
		userland_GNU? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:= )
		)
	)
	nginx_modules_http_geoip? ( dev-libs/geoip )
	nginx_modules_http_gunzip? ( sys-libs/zlib )
	nginx_modules_http_gzip? ( sys-libs/zlib )
	nginx_modules_http_gzip_static? ( sys-libs/zlib )
	nginx_modules_http_image_filter? ( media-libs/gd[jpeg,png] )
	nginx_modules_http_perl? ( >=dev-lang/perl-5.8 )
	nginx_modules_http_rewrite? ( >=dev-libs/libpcre-4.2 )
	nginx_modules_http_secure_link? (
		userland_GNU? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:= )
		)
	)
	nginx_modules_http_xslt? ( dev-libs/libxml2 dev-libs/libxslt )
	nginx_modules_http_lua? ( !luajit? ( dev-lang/lua:0= ) luajit? ( dev-lang/luajit:2= ) )
	nginx_modules_http_auth_pam? ( virtual/pam )
	nginx_modules_http_metrics? ( dev-libs/yajl )
	nginx_modules_http_dav_ext? ( dev-libs/expat )
	nginx_modules_http_security? ( >=dev-libs/libxml2-2.7.8 dev-libs/apr-util www-servers/apache )
	nginx_modules_http_auth_ldap? ( net-nds/openldap[ssl?] )
	nginx_modules_http_tidehunter? ( dev-libs/jansson )
    nginx_modules_http_drizzle? ( dev-db/drizzle )
	nginx_modules_http_fluentd? ( app-admin/fluentd )
	perftools? ( dev-util/google-perftools )
	rrd? ( >=net-analyzer/rrdtool-1.3.8 )"
RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-nginx )
	!www-servers/nginx:0"
DEPEND="${CDEPEND}
	arm? ( dev-libs/libatomic_ops )
	libatomic? ( dev-libs/libatomic_ops )"
PDEPEND="vim-syntax? ( app-vim/nginx-syntax )"

REQUIRED_USE="pcre-jit? ( pcre )
	nginx_modules_http_lua? ( nginx_modules_http_rewrite )
	nginx_modules_http_naxsi? ( pcre )
	nginx_modules_http_dav_ext? ( nginx_modules_http_dav )
	nginx_modules_http_metrics? ( nginx_modules_http_stub_status )
	nginx_modules_http_security? ( pcre )
	nginx_modules_http_push_stream? ( ssl )
	nginx_modules_http_rds_json? ( || ( nginx_modules_http_drizzle nginx_modules_http_postgres ) )"

pkg_setup() {
	NGINX_HOME="/var/lib/nginx"
	NGINX_HOME_TMP="${NGINX_HOME}/tmp"

	ebegin "Creating nginx user and group"
	enewgroup ${PN}
	enewuser ${PN} -1 -1 "${NGINX_HOME}" ${PN}
	eend $?

	if use libatomic; then
		ewarn "GCC 4.1+ features built-in atomic operations."
		ewarn "Using libatomic_ops is only needed if using"
		ewarn "a different compiler or a GCC prior to 4.1"
	fi

	if [[ -n $NGINX_ADD_MODULES ]]; then
		ewarn "You are building custom modules via \$NGINX_ADD_MODULES!"
		ewarn "This nginx installation is not supported!"
		ewarn "Make sure you can reproduce the bug without those modules"
		ewarn "_before_ reporting bugs."
	fi

	if use !http; then
		ewarn "To actually disable all http-functionality you also have to disable"
		ewarn "all nginx http modules."
	fi

	if use nginx_modules_http_ajp; then
		eerror "The AJP module currently doesn't build for nginx >1.8."
		eerror "It will be reintroduced with the 1.9 series when proven stable."
		eerror "Either disable it or stick with nginx 1.7.x."
		die "AJP module not supported"
	fi

	if use nginx_modules_http_mogilefs && use threads; then
		eerror "mogilefs won't compile with threads support."
		eerror "Please disable either flag and try again."
		die "Can't compile mogilefs with threads support"
	fi
}

src_unpack() {
	# prevent ruby-ng.eclass from messing with src_unpack
	default
#	use pam && unpack "ngx_http_auth_pam_module-${PAM_MODULE_PV}.tar.gz"
	use rrd && unpack "Mod_rrd_graph-0.2.0.tar.gz"
	use chunk && unpack "chunkin-nginx-module-${CHUNKIN_MODULE_PV}.tgz"
}

src_prepare() {
	eapply "${FILESDIR}/${PN}-1.4.1-fix-perl-install-path.patch"

	if use nginx_modules_http_upstream_check; then
		eapply -p0 "${FILESDIR}/check-1.9.2".patch
	fi

    if use nginx_modules_http_lua; then
		sed -i -e 's/-llua5.1/-llua/' "${HTTP_LUA_MODULE_WD}/config" || die
	fi

	find auto/ -type f -print0 | xargs -0 sed -i 's:\&\& make:\&\& \\$(MAKE):' || die
	# We have config protection, don't rename etc files
	sed -i 's:.default::' auto/install || die
	# remove useless files
	sed -i -e '/koi-/d' -e '/win-/d' auto/install || die

	# don't install to /etc/nginx/ if not in use
	local module
	for module in fastcgi scgi uwsgi ; do
		if ! use nginx_modules_http_${module}; then
			sed -i -e "/${module}/d" auto/install || die
		fi
	done
    #uu
    sed -i -e "s|\(NGX_MAX_ERROR_STR\)   2048|\1 4096|" src/core/ngx_log.h
	eapply -p0 "${FILESDIR}"/version.patch
	host=$(hostname 2>/dev/null)
	sed -i -e "s|%HOSTNAME%|$host|" src/http/ngx_http_special_response.c
	sed -i -e "s|%HOSTNAME%|$host|" src/http/ngx_http_header_filter_module.c
	if use nginx_modules_http_ey_balancer; then
		eapply -p0 "${FILESDIR}"/nginx-1.x-ey-balancer.patch
	fi
    #/uu
	eapply_user
}

src_configure() {
	# mod_security needs to generate nginx/modsecurity/config before including it
	if use nginx_modules_http_security; then
		cd "${HTTP_SECURITY_MODULE_WD}"
		if use luajit ; then
			sed -i \
				-e 's|^\(LUA_PKGNAMES\)=.*|\1="luajit"|' \
				configure || die
		fi
		./configure \
			--enable-standalone-module \
			$(use_enable pcre-jit) \
			$(use_with nginx_modules_http_lua lua) || die "configure failed for mod_security"
	fi

	cd "${S}"

	local myconf=() http_enabled= mail_enabled= stream_enabled=

	use aio       && myconf+=( --with-file-aio )
	use debug     && myconf+=( --with-debug )
	use http2     && myconf+=( --with-http_v2_module )
	use ipv6      && myconf+=( --with-ipv6 )
	use libatomic && myconf+=( --with-libatomic )
	use pcre      && myconf+=( --with-pcre )
	use pcre-jit  && myconf+=( --with-pcre-jit )
	use threads   && myconf+=( --with-threads )

	# HTTP modules
	for mod in $NGINX_MODULES_STD; do
		if use nginx_modules_http_${mod}; then
			http_enabled=1
		else
			myconf+=( --without-http_${mod}_module )
		fi
	done

	for mod in $NGINX_MODULES_OPT; do
		if use nginx_modules_http_${mod}; then
			http_enabled=1
			myconf+=( --with-http_${mod}_module )
		fi
	done

	if use nginx_modules_http_fastcgi; then
		myconf+=( --with-http_realip_module )
	fi

	# third-party modules
	if use nginx_modules_http_upload_progress; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_UPLOAD_PROGRESS_MODULE_WD} )
	fi

	if use nginx_modules_http_headers_more; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_HEADERS_MORE_MODULE_WD} )
	fi

	if use nginx_modules_http_cache_purge; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_CACHE_PURGE_MODULE_WD} )
	fi

	if use nginx_modules_http_slowfs_cache; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_SLOWFS_CACHE_MODULE_WD} )
	fi

	if use nginx_modules_http_fancyindex; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_FANCYINDEX_MODULE_WD} )
	fi

	if use nginx_modules_http_lua; then
		http_enabled=1
		if use luajit; then
			export LUAJIT_LIB=$(pkg-config --variable libdir luajit)
			export LUAJIT_INC=$(pkg-config --variable includedir luajit)
		else
			export LUA_LIB=$(pkg-config --variable libdir lua)
			export LUA_INC=$(pkg-config --variable includedir lua)
		fi
      myconf+=( --add-module=${DEVEL_KIT_MODULE_WD} )
      myconf+=( --add-module=${HTTP_LUA_MODULE_WD} )
	fi

	if use nginx_modules_http_auth_pam; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_AUTH_PAM_MODULE_WD} )
	fi

	if use nginx_modules_http_upstream_check; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_UPSTREAM_CHECK_MODULE_WD} )
	fi

	if use nginx_modules_http_metrics; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_METRICS_MODULE_WD} )
	fi

	if use nginx_modules_http_naxsi ; then
		http_enabled=1
		myconf+=(  --add-module=${HTTP_NAXSI_MODULE_WD} )
	fi

	if use rtmp ; then
		http_enabled=1
		myconf+=( --add-module=${RTMP_MODULE_WD} )
	fi

	if use nginx_modules_http_dav_ext ; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_DAV_EXT_MODULE_WD} )
	fi

	if use nginx_modules_http_echo ; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_ECHO_MODULE_WD} )
	fi

	if use nginx_modules_http_security ; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_SECURITY_MODULE_WD}/nginx/modsecurity )
	fi

	if use nginx_modules_http_push_stream ; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_PUSH_STREAM_MODULE_WD} )
	fi

	if use nginx_modules_http_sticky ; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_STICKY_MODULE_WD} )
	fi

	if use nginx_modules_http_mogilefs ; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_MOGILEFS_MODULE_WD} )
	fi

	if use nginx_modules_http_memc ; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_MEMC_MODULE_WD} )
	fi

	if use nginx_modules_http_auth_ldap; then
		http_enabled=1
		myconf+=( --add-module=${HTTP_LDAP_MODULE_WD} )
	fi

    if use nginx_modules_http_eval; then
        http_enabled=1
        myconf+=( --add-module=${HTTP_EVAL_MODULE_WD} )
    fi

    if use nginx_modules_http_websockify; then
        http_enabled=1
        myconf+=( --add-module=${HTTP_WEBSOCKIFY_MODULE_WD} )
    fi

    if use nginx_modules_http_poller; then
        http_enabled=1
        myconf+=( --add-module=${HTTP_POLLER_MODULE_WD} )
    fi

    if use nginx_modules_http_bodytime; then
        http_enabled=1
        myconf+=( --add-module=${HTTP_BODYTIME_MODULE_WD} )
    fi

    if use nginx_modules_http_ajp ; then
        http_enabled=1
        myconf+=( --add-module=${HTTP_AJP_MODULE_WD})
    fi

    if use nginx_modules_http_pinba; then
        http_enabled=1
        myconf+=( --add-module=${WORKDIR}/ngx_http_pinba_module-master )
    fi

    if use nginx_modules_http_zip; then
        http_enabled=1
        myconf+=( --add-module=${WORKDIR}/mod_zip-master )
    fi

    if use nginx_modules_http_fluentd; then
        http_enabled=1
        myconf+=( --add-module=${WORKDIR}/fluent-nginx-fluentd-module-${HTTP_FLUENTD_MODULE_SHA1} )
    fi

    if use nginx_modules_http_tcp_proxy; then
        epatch ${WORKDIR}/nginx_tcp_proxy_module-dc/tcp.patch
        http_enabled=1
        myconf+=( --add-module=${WORKDIR}/nginx_tcp_proxy_module-dc )
    fi

    if use nginx_modules_http_srcache; then
        http_enabled=1
        myconf+=( --add-module=${WORKDIR}/openresty-srcache-nginx-module-${HTTP_SRCACHE_MODULE_SHA1} )
    fi

    if use nginx_modules_http_drizzle; then
        http_enabled=1
        myconf+=( --add-module=${WORKDIR}/chaoslawful-drizzle-nginx-module-${HTTP_DRIZZLE_MODULE_SHA1} )
    fi

    if use nginx_modules_http_rds_json; then
        http_enabled=1
        myconf+=( --add-module=${WORKDIR}/openresty-rds-json-nginx-module-${HTTP_RDS_JSON_MODULE_SHA1} )
    fi

    if use nginx_modules_http_postgres; then
        http_enabled=1
        myconf+=( --add-module=${WORKDIR}/FRiCKLE-ngx_postgres-${HTTP_POSTGRES_MODULE_SHA1} )
    fi

    if use nginx_modules_http_coolkit; then
        http_enabled=1
        myconf+=( --add-module=${WORKDIR}/${HTTP_COOLKIT_MODULE_P} )
    fi

    if use nginx_modules_http_push; then
        http_enabled=1
        myconf+=( --add-module=${WORKDIR}/${HTTP_PUSH_MODULE_P} )
    fi

    if use nginx_modules_http_supervisord; then
        http_enabled=1
        myconf+=( --add-module=${WORKDIR}/${HTTP_SUPERVISORD_MODULE_P} )
    fi

    if use nginx_modules_http_xss; then
        http_enabled=1
        myconf+=( --add-module=${WORKDIR}/openresty-xss-nginx-module-${HTTP_XSS_MODULE_SHA1} )
    fi

    if use nginx_modules_http_array_var; then
        http_enabled=1
        myconf+=( --add-module=${WORKDIR}/openresty-array-var-nginx-module-${HTTP_ARRAY_VAR_MODULE_SHA1} )
    fi

    if use nginx_modules_http_form_input; then
        http_enabled=1
        myconf+=( --add-module=${WORKDIR}/calio-form-input-nginx-module-${HTTP_FORM_INPUT_MODULE_SHA1} )
    fi

    if use nginx_modules_http_iconv; then
        http_enabled=1
        myconf+=( --add-module=${WORKDIR}/calio-iconv-nginx-module-${HTTP_ICONV_MODULE_SHA1} )
    fi

    if use nginx_modules_http_nchan; then
        http_enabled=1
        myconf+=( --add-module=${WORKDIR}/slact-nchan-${HTTP_NCHAN_MODULE_SHA1} )
    fi

    if use nginx_modules_http_redis; then
        http_enabled=1
        myconf+=( --add-module=${WORKDIR}/openresty-redis2-nginx-module-${HTTP_REDIS_MODULE_SHA1} )
    fi

    if use nginx_modules_http_ey_balancer; then
        http_enabled=1
        myconf+=( --add-module=${WORKDIR}/msva-nginx-ey-balancer-${HTTP_EY_BALANCER_MODULE_SHA1} )
    fi

    if use nginx_modules_http_tidehunter ; then
        http_enabled=1
        myconf+=( --add-module=${HTTP_TIDEHUNTER_MODULE_WD} )
    fi



	if use http || use http-cache || use http2; then
		http_enabled=1
	fi

	if [ $http_enabled ]; then
		use http-cache || myconf+=( --without-http-cache )
		use ssl && myconf+=( --with-http_ssl_module )
	else
		myconf+=( --without-http --without-http-cache )
	fi

	use perftools && myconf+=( --with-google_perftools_module )
	use rrd && myconf+=( --add-module=${WORKDIR}/mod_rrd_graph-0.2.0 )
	use chunk && myconf+=( --add-module=${WORKDIR}/openresty-chunkin-nginx-module-${CHUNKIN_MODULE_SHA1} )

	# Stream modules
	for mod in $NGINX_MODULES_STREAM; do
		if use nginx_modules_stream_${mod}; then
			stream_enabled=1
		else
			# Treat stream upstream slightly differently
			if ! use nginx_modules_stream_upstream; then
				myconf+=( --without-stream_upstream_hash_module )
				myconf+=( --without-stream_upstream_least_conn_module )
				myconf+=( --without-stream_upstream_zone_module )
			else
				myconf+=( --without-stream_${stream}_module )
			fi
		fi
	done

	if [ $stream_enabled ]; then
		myconf+=( --with-stream )
		use ssl && myconf+=( --with-stream_ssl_module )
	fi

	# MAIL modules
	for mod in $NGINX_MODULES_MAIL; do
		if use nginx_modules_mail_${mod}; then
			mail_enabled=1
		else
			myconf+=( --without-mail_${mod}_module )
		fi
	done

	if [ $mail_enabled ]; then
		myconf+=( --with-mail )
		use ssl && myconf+=( --with-mail_ssl_module )
	fi

	# custom modules
	for mod in $NGINX_ADD_MODULES; do
		myconf+=(  --add-module=${mod} )
	done

	# https://bugs.gentoo.org/286772
	export LANG=C LC_ALL=C
	tc-export CC

    if ! use prefix; then
		myconf+=( --user=${PN}" "--group=${PN} )
    fi

	./configure \
		--prefix="${EPREFIX}"/usr \
		--conf-path="${EPREFIX}"/etc/${PN}/${PN}.conf \
		--error-log-path="${EPREFIX}"/var/log/${PN}/error_log \
		--pid-path="${EPREFIX}"/run/${PN}.pid \
		--lock-path="${EPREFIX}"/run/lock/${PN}.lock \
		--with-cc-opt="-I${EROOT}usr/include" \
		--with-ld-opt="-L${EROOT}usr/$(get_libdir)" \
		--http-log-path="${EPREFIX}"/var/log/${PN}/access_log \
		--http-client-body-temp-path="${EPREFIX}${NGINX_HOME_TMP}"/client \
		--http-proxy-temp-path="${EPREFIX}${NGINX_HOME_TMP}"/proxy \
		--http-fastcgi-temp-path="${EPREFIX}${NGINX_HOME_TMP}"/fastcgi \
		--http-scgi-temp-path="${EPREFIX}${NGINX_HOME_TMP}"/scgi \
		--http-uwsgi-temp-path="${EPREFIX}${NGINX_HOME_TMP}"/uwsgi \
		"${myconf[@]}" || die "configure failed"

	# A purely cosmetic change that makes nginx -V more readable. This can be
	# good if people outside the gentoo community would troubleshoot and
	# question the users setup.
	sed -i -e "s|${WORKDIR}|external_module|g" objs/ngx_auto_config.h || die
}

src_compile() {
	use nginx_modules_http_security && emake -C "${HTTP_SECURITY_MODULE_WD}"

	# https://bugs.gentoo.org/286772
	export LANG=C LC_ALL=C
	emake LINK="${CC} ${LDFLAGS}" OTHERLDFLAGS="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${D%/}" install

	cp "${FILESDIR}"/nginx.conf-r2 "${ED}"etc/nginx/nginx.conf || die

	newinitd "${FILESDIR}"/nginx.initd-r2 nginx

	systemd_newunit "${FILESDIR}"/nginx.service-r1 nginx.service

	doman man/nginx.8
	dodoc CHANGES* README

	# just keepdir. do not copy the default htdocs files (bug #449136)
	keepdir /var/www/localhost
	rm -rf "${D}"usr/html || die

	# set up a list of directories to keep
	local keepdir_list="${NGINX_HOME_TMP}"/client
	local module
	for module in proxy fastcgi scgi uwsgi; do
		use nginx_modules_http_${module} && keepdir_list+=" ${NGINX_HOME_TMP}/${module}"
	done

	keepdir /var/log/nginx ${keepdir_list}

	# this solves a problem with SELinux where nginx doesn't see the directories
	# as root and tries to create them as nginx
	fperms 0750 "${NGINX_HOME_TMP}"
	fowners ${PN}:0 "${NGINX_HOME_TMP}"

	fperms 0700 /var/log/nginx ${keepdir_list}
	fowners ${PN}:${PN} /var/log/nginx ${keepdir_list}

	# logrotate
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/nginx.logrotate-r1 nginx

	if use nginx_modules_http_perl; then
		cd "${S}"/objs/src/http/modules/perl/
		emake DESTDIR="${D}" INSTALLDIRS=vendor
		perl_delete_localpod
	fi

	if use nginx_modules_http_cache_purge; then
		docinto ${HTTP_CACHE_PURGE_MODULE_P}
		dodoc "${HTTP_CACHE_PURGE_MODULE_WD}"/{CHANGES,README.md,TODO.md}
	fi

	if use nginx_modules_http_slowfs_cache; then
		docinto ${HTTP_SLOWFS_CACHE_MODULE_P}
		dodoc "${HTTP_SLOWFS_CACHE_MODULE_WD}"/{CHANGES,README.md}
	fi

    if use nginx_modules_http_fancyindex; then
        docinto ${HTTP_FANCYINDEX_MODULE_P}
        dodoc "${HTTP_FANCYINDEX_MODULE_WD}"/README.rst
    fi

	if use nginx_modules_http_lua; then
		docinto ${HTTP_LUA_MODULE_P}
		dodoc "${HTTP_LUA_MODULE_WD}"/{Changes,README.markdown}
	fi

	if use nginx_modules_http_auth_pam; then
		docinto ${HTTP_AUTH_PAM_MODULE_P}
		dodoc "${HTTP_AUTH_PAM_MODULE_WD}"/{README.md,ChangeLog}
	fi

    if use nginx_modules_http_upstream_check; then
        docinto ${HTTP_UPSTREAM_CHECK_MODULE_P}
        dodoc "${HTTP_UPSTREAM_CHECK_MODULE_WD}"/{README,CHANGES}
    fi

	if use nginx_modules_http_naxsi; then
		insinto /etc/nginx
		doins "${HTTP_NAXSI_MODULE_WD}"/../naxsi_config/naxsi_core.rules
	fi

    if use rtmp; then
        docinto ${RTMP_MODULE_P}
        dodoc "${RTMP_MODULE_WD}"/{AUTHORS,README.md,stat.xsl}
    fi

    if use nginx_modules_http_dav_ext; then
        docinto ${HTTP_DAV_EXT_MODULE_P}
        dodoc "${HTTP_DAV_EXT_MODULE_WD}"/README
    fi

	if use nginx_modules_http_echo; then
		docinto ${HTTP_ECHO_MODULE_P}
		dodoc "${HTTP_ECHO_MODULE_WD}"/{README.markdown,doc/HttpEchoModule.wiki}
	fi

    if use nginx_modules_http_security; then
        docinto ${HTTP_SECURITY_MODULE_P}
        dodoc "${HTTP_SECURITY_MODULE_WD}"/{CHANGES,README.TXT,authors.txt}
    fi

	if use nginx_modules_http_push_stream; then
		docinto ${HTTP_PUSH_STREAM_MODULE_P}
		dodoc "${HTTP_PUSH_STREAM_MODULE_WD}"/{AUTHORS,CHANGELOG.textile,README.textile}
	fi

    if use nginx_modules_http_sticky; then
        docinto ${HTTP_STICKY_MODULE_P}
        dodoc "${HTTP_STICKY_MODULE_WD}"/{README.md,Changelog.txt,docs/sticky.pdf}
    fi

	if use nginx_modules_http_memc; then
        docinto ${HTTP_MEMC_MODULE_P}
        dodoc "${HTTP_MEMC_MODULE_WD}"/README.markdown
	fi

	if use nginx_modules_http_auth_ldap; then
        docinto ${HTTP_LDAP_MODULE_P}
        dodoc "${HTTP_LDAP_MODULE_WD}"/example.conf
	fi

    if use nginx_modules_http_ajp; then
        docinto ${HTTP_AJP_MODULE_P}
        dodoc "${HTTP_AJP_MODULE_WD}"/README
    fi

    if use nginx_modules_http_websockify; then
        docinto ${HTTP_WEBSOCKIFY_MODULE_P}
        dodoc "${HTTP_WEBSOCKIFY_MODULE_WD}"/README.md
    fi
    
	if use nginx_modules_http_poller; then
        docinto ${HTTP_POLLER_MODULE_P}
        dodoc "${HTTP_POLLER_MODULE_WD}"/README.md
    fi
	
    if use nginx_modules_http_bodytime; then
        docinto ${HTTP_BODYTIME_MODULE_P}
        dodoc "${HTTP_BODYTIME_MODULE_WD}"/{README.md,LICENSE}
    fi

    if use nginx_modules_http_push; then
        docinto "${HTTP_PUSH_MODULE_P}"
        dodoc "${WORKDIR}"/"${HTTP_PUSH_MODULE_P}"/{changelog.txt,protocol.txt,README}
    fi

    if use nginx_modules_http_upload; then
        docinto "${HTTP_UPLOAD_MODULE_P}"
        dodoc "${WORKDIR}"/"${HTTP_UPLOAD_MODULE_P}"/{Changelog,README}
    fi

    if use nginx_modules_http_upload_progress; then
        docinto "${HTTP_UPLOAD_PROGRESS_MODULE_P}"
        dodoc "${WORKDIR}"/"masterzen-nginx-upload-progress-module-${HTTP_UPLOAD_PROGRESS_MODULE_SHA1}"/README
    fi

    if use nginx_modules_http_ey_balancer; then
        docinto "${HTTP_EY_BALANCER_MODULE_P}"
        dodoc "${WORKDIR}"/"msva-nginx-ey-balancer-${HTTP_EY_BALANCER_MODULE_SHA1}"/README
    fi

    if use nginx_modules_http_lua; then
        docinto "${HTTP_LUA_MODULE_P}"
        dodoc "${WORKDIR}"/"lua-nginx-module-${HTTP_LUA_MODULE_PV}"/{Changes,README.markdown}
    fi

    if use nginx_modules_http_form_input; then
        docinto "${HTTP_FORM_INPUT_MODULE_P}"
        dodoc "${WORKDIR}"/"calio-form-input-nginx-module-${HTTP_FORM_INPUT_MODULE_SHA1}"/README
    fi

    if use nginx_modules_http_srcache; then
        docinto "${HTTP_SRCACHE_MODULE_P}"
        dodoc "${WORKDIR}"/"openresty-srcache-nginx-module-${HTTP_SRCACHE_MODULE_SHA1}"/README
    fi

    if use nginx_modules_http_drizzle; then
        docinto "${HTTP_DRIZZLE_MODULE_P}"
        dodoc "${WORKDIR}"/"chaoslawful-drizzle-nginx-module-${HTTP_DRIZZLE_MODULE_SHA1}"/README
    fi

    if use nginx_modules_http_rds_json; then
        docinto "${HTTP_RDS_JSON_MODULE_P}"
        dodoc "${WORKDIR}"/"openresty-rds-json-nginx-module-${HTTP_RDS_JSON_MODULE_SHA1}"/README
    fi

    if use nginx_modules_http_postgres; then
        docinto "${HTTP_POSTGRES_MODULE_P}"
        dodoc "${WORKDIR}"/"FRiCKLE-ngx_postgres-${HTTP_POSTGRES_MODULE_SHA1}"/README.md
    fi

    if use nginx_modules_http_coolkit; then
        docinto "${HTTP_COOLKIT_MODULE_P}"
        dodoc "${WORKDIR}"/"${HTTP_COOLKIT_MODULE_P}"/README
    fi

    if use nginx_modules_http_xss; then
        docinto "${HTTP_XSS_MODULE_P}"
        dodoc "${WORKDIR}"/"openresty-xss-nginx-module-${HTTP_XSS_MODULE_SHA1}"/README
    fi

    if use nginx_modules_http_array_var; then
        docinto "${HTTP_ARRAY_VAR_MODULE_P}"
        dodoc "${WORKDIR}"/"openresty-array-var-nginx-module-${HTTP_ARRAY_VAR_MODULE_SHA1}"/README
    fi

    if use nginx_modules_http_iconv; then
        docinto "${HTTP_ICONV_MODULE_P}"
        dodoc "${WORKDIR}"/"calio-iconv-nginx-module-${HTTP_ICONV_MODULE_SHA1}"/README
    fi

    if use nginx_modules_http_supervisord; then
        docinto "${HTTP_SUPERVISORD_MODULE_P}"
        dodoc "${WORKDIR}"/"${HTTP_SUPERVISORD_MODULE_P}"/README
    fi

    if use nginx_modules_http_metrics; then
        docinto ${HTTP_METRICS_MODULE_P}
        dodoc "${HTTP_METRICS_MODULE_WD}"/README.md
    fi

	use chunk   && newdoc "${WORKDIR}/openresty-chunkin-nginx-module-${CHUNKIN_MODULE_SHA1}"/README README.chunkin
	use nginx_modules_http_auth_pam && newdoc "${WORKDIR}"/ngx_http_auth_pam_module-${PAM_MODULE_PV}/README.md README.pam
}

pkg_postinst() {
   if use ssl; then
		if [ ! -f "${EROOT}"etc/ssl/${PN}/${PN}.key ]; then
            install_cert /etc/ssl/${PN}/${PN}
			use prefix || chown ${PN}:${PN} "${EROOT}"etc/ssl/${PN}/${PN}.{crt,csr,key,pem}
        fi
    fi

	if use nginx_modules_http_spdy; then
		ewarn "In nginx 1.9.5 the spdy module was superseded by http2."
		ewarn "Update your configs and package.use accordingly."
	fi

	if use nginx_modules_http_lua && use http2; then
		ewarn "Lua 3rd party module author warns against using ${P} with"
		ewarn "NGINX_MODULES_HTTP=\"lua http2\". For more info, see http://git.io/OldLsg"
	fi

    # This is the proper fix for bug #458726/#469094, resp. CVE-2013-0337 for
    # existing installations
    local fix_perms=0

    for rv in ${REPLACING_VERSIONS} ; do
        version_compare ${rv} 1.4.1-r2
        [[ $? -eq 1 ]] && fix_perms=1
    done

    if [[ $fix_perms -eq 1 ]] ; then
        ewarn "To fix a security bug (CVE-2013-0337, bug #458726) had the following"
        ewarn "directories the world-readable bit removed (if set):"
        ewarn "  ${EPREFIX}/var/log/nginx"
        ewarn "  ${EPREFIX}${NGINX_HOME_TMP}/{,client,proxy,fastcgi,scgi,uwsgi}"
        ewarn "Check if this is correct for your setup before restarting nginx!"
        ewarn "This is a one-time change and will not happen on subsequent updates."
        ewarn "Furthermore nginx' temp directories got moved to ${NGINX_HOME_TMP}"
		chmod -f o-rwx "${EPREFIX}"/var/log/nginx "${EPREFIX}${NGINX_HOME_TMP}"/{,client,proxy,fastcgi,scgi,uwsgi}
    fi

    # If the nginx user can't change into or read the dir, display a warning.
    # If su is not available we display the warning nevertheless since we can't check properly
    su -s /bin/sh -c 'cd /var/log/nginx/ && ls' nginx >&/dev/null
    if [ $? -ne 0 ] ; then
        ewarn "Please make sure that the nginx user or group has at least"
        ewarn "'rx' permissions on /var/log/nginx (default on a fresh install)"
        ewarn "Otherwise you end up with empty log files after a logrotate."
    fi
}
