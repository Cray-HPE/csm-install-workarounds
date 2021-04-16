#!/bin/bash
#
# Work-ARound patch for NETETH-1275. Please run this script to address the problem

file_to_patch=/opt/cray/cray-network-config/default/bin/shasta-network-lldp.sh

sed -i \
    -e 's:^for dev in $(ls /sys/class/net) ; do$:for dev in $(ls /sys/class/net | grep hsn) ; do:g' \
    $file_to_patch

affected_lines=$(egrep '^for dev in \$\(ls /sys/class/net | grep hsn\) ; do$' $file_to_patch | wc -l)
if [[ $affected_lines -eq 2 ]] ; then
    echo patch applied successfully
else
    echo patch was not applied successfully
    exit 1
fi

exit 0
