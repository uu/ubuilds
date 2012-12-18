#!/bin/bash
# read in the configuration file
source /etc/conf.d/ucarp
 
#
# bring down the virtual interface
$IFCONFIG $INTERFACE down
