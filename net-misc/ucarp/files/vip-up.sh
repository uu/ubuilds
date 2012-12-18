#!/bin/bash
 
# read in the configuration file
source /etc/conf.d/ucarp 
 
# bring up the virtual interface
$IFCONFIG $INTERFACE $VIRTUAL_ADDRESS netmask $VIRTUAL_NETMASK broadcast $VIRTUAL_BROADCAST
