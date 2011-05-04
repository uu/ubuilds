<?php
/* 
 * Centreon is developped with GPL Licence 2.0 : 
 * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt 
 * Developped by : Julien Mathis - Romain Le Merlus  
 *  
 * The Software is provided to you AS IS and WITH ALL FAULTS. 
 * Centreon makes no representation and gives no warranty whatsoever, 
 * whether express or implied, and without limitation, with regard to the quality, 
 * any particular or intended purpose of the Software found on the Centreon web site. 
 * In no event will Centreon be liable for any direct, indirect, punitive, special, 
 * incidental or consequential damages however they may arise and even if Centreon has 
 * been previously advised of the possibility of such damages. 
 *  
 * For information : contact@centreon.com 
 */

$conf_centreon['centreon_dir'] = "/usr/share/centreon/";
$conf_centreon['centreon_etc'] = "/etc/centreon/";
$conf_centreon['centreon_dir_www'] = "/usr/share/centreon/www/";
$conf_centreon['centreon_dir_rrd'] = "/usr/share/centreon/rrd/";
$conf_centreon['nagios'] = "/usr/share/nagios/";
$conf_centreon['nagios_conf'] = "/etc/nagios/";
$conf_centreon['nagios_plugins'] = "/usr/lib/nagios/plugins/";
$conf_centreon['nagios_binary'] = "/usr/sbin/nagios";
$conf_centreon['nagiostats_binary'] = "/usr/sbin/nagiostats";
$conf_centreon['nagios_init_script'] = "/etc/init.d/nagios";
$conf_centreon['rrdtool_dir'] = "/usr/bin/rrdtool";
$conf_centreon['apache_user'] = "apache";
$conf_centreon['apache_group'] = "apache";
$conf_centreon['nagios_user'] = "nagios";
$conf_centreon['nagios_group'] = "nagios";
$conf_centreon['mail'] = "/usr/bin/mail";
$conf_centreon['pear_dir'] = "/usr/share/php";

$conf_centreon['log_file'] = "/var/nagios/nagios.log";
$conf_centreon['cfg_file'] = "/etc/nagios/objects/commands.cfg";
$conf_centreon['cfg_file'] = "/etc/nagios/objects/contacts.cfg";
$conf_centreon['cfg_file'] = "/etc/nagios/objects/timeperiods.cfg";
$conf_centreon['cfg_file'] = "/etc/nagios/objects/templates.cfg";
$conf_centreon['cfg_file'] = "/etc/nagios/objects/localhost.cfg";
$conf_centreon['object_cache_file'] = "/var/nagios/objects.cache";
$conf_centreon['precached_object_file'] = "/var/nagios/objects.precache";
$conf_centreon['resource_file'] = "/etc/nagios/resource.cfg";
$conf_centreon['status_file'] = "/var/nagios/status.dat";
$conf_centreon['command_file'] = "/var/nagios/rw/nagios.cmd";
$conf_centreon['lock_file'] = "/var/nagios/nagios.lock";
$conf_centreon['temp_file'] = "/var/nagios/nagios.tmp";
$conf_centreon['max_check_result_file_age'] = "3600";
$conf_centreon['state_retention_file'] = "/var/nagios/retention.dat";
$conf_centreon['p1_file'] = "/usr/sbin/p1.pl";
$conf_centreon['debug_file'] = "/var/nagios/nagios.debug";
$conf_centreon['max_debug_file_size'] = "1000000";
$conf_centreon['temp_path'] = "/tmp";
$conf_centreon['log_archive_path'] = "/var/nagios/archives";
$conf_centreon['check_result_path'] = "/var/nagios/spool/checkresults";
$conf_centreon['physical_html_path'] = "/usr/share/nagios/htdocs";
?>
