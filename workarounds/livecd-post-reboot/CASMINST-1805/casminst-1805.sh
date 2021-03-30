#!/bin/sh

pdsh -b -w $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u |  tr -t '\n' ',') '
rm /etc/cron.weekly/fstrim 2>/dev/null && echo done || echo removed already'
