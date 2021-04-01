#!/bin/bash

csidir=$1

if [ -z ${csidir} ]; then
   echo "ERROR:  Must specify the location of CSI config files"
   exit 1
fi

if [ ! -d ${csidir} ]; then
   echo "ERROR: ${csidir} directory not found"
   exit 1
fi

if [ ! -r ${csidir}/system_config.yaml ]; then
   echo "ERROR: ${csidir}/system_config.yaml not found or not readable"
   exit 1
fi

if [ ! -r ${csidir}/dnsmasq.d/CAN.conf ]; then
   echo "ERROR: ${csidir}/dnsmasq.d/CAN.conf not found or not readable"
   exit 1
fi

new_range_end=$(grep can-static-pool ${csidir}/system_config.yaml | awk '{print $2}' | cut -d'/' -f 1)
if [ -z ${new_range_end} ]; then
    echo "ERROR:  Could not determine new range end"
    exit 1
fi

old_range_end=$(grep dhcp-range ${csidir}/dnsmasq.d/CAN.conf | cut -d',' -f 3)
if [ -z ${old_range_end} ]; then
    echo "ERROR:  Could not determine old range end"
    exit 1
fi

echo "Replacing ${old_range_end} with ${new_range_end} in dhcp-range for CAN"

sed -i "/dhcp-range/s/${old_range_end}/${new_range_end}/g" ${csidir}/dnsmasq.d/CAN.conf

echo "Restarting dnsmasq..."
systemctl restart dnsmasq.service

exit 0
