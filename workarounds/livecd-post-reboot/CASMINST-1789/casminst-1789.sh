#!/bin/sh
# Sets kernel parameters TCP memory
# notifies every host of the setting.
# temporary/running system
pdsh -b -w $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u |  tr -t '\n' ',') 'sysctl -w net.ipv4.tcp_mem="3083247 4110996 6166494"'

# persist
pdsh -b -w $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u |  tr -t '\n' ',') 'echo net.ipv4.tcp_mem="3083247 4110996 6166494" > /etc/sysctl.d/999-tcp-mem.conf'
