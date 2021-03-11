#!/bin/sh
# Sets kernel parameters for ARP
# notifies every host of the setting.

pdsh -b -w $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u |  tr -t '\n' ',') \'
wall fixing sysctl; loading new kernel parameters && \
sysctl net.ipv4.neigh.default.gc_thresh1=2048 && \
sysctl net.ipv4.neigh.default.gc_thresh2=4096 && \
sysctl net.ipv4.neigh.default.gc_thresh3=8192 && \
sysctl net.ipv4.neigh.default.gc_interval=30 && \
sysctl net.ipv4.neigh.default.gc_stale_time=240'
