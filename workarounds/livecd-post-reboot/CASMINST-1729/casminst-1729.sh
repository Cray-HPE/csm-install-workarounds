#!/bin/sh
# Sets kernel parameters for ARP
# notifies every host of the setting.

# temporary/running system
pdsh -b -w $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u |  tr -t '\n' ',') '
sysctl net.ipv4.neigh.default.gc_thresh1=2048 && \
sysctl net.ipv4.neigh.default.gc_thresh2=4096 && \
sysctl net.ipv4.neigh.default.gc_thresh3=8192 && \
sysctl net.ipv4.neigh.default.gc_interval=30 && \
sysctl net.ipv4.neigh.default.gc_stale_time=240'

# persistence

pdsh -b -w $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u |  tr -t '\n' ',') '
echo "net.ipv4.neigh.default.gc_thresh1=2048" > /etc/sysctl.d/999-ipv4-neigh.conf && \
echo "net.ipv4.neigh.default.gc_thresh2=4096" >> /etc/sysctl.d/999-ipv4-neigh.conf && \
echo "net.ipv4.neigh.default.gc_thresh3=8192" >> /etc/sysctl.d/999-ipv4-neigh.conf && \
echo "net.ipv4.neigh.default.gc_interval=30" >> /etc/sysctl.d/999-ipv4-neigh.conf && \
echo "net.ipv4.neigh.default.gc_stale_time=240" >> /etc/sysctl.d/999-ipv4-neigh.conf'
