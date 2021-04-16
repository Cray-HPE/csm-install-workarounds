#!/bin/sh

for ncn in $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u); do
    scp ./limit_to_hsn.sh "$ncn":/tmp/
done

pdsh -b -w $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u |  tr -t '\n' ',') /tmp/limit_to_hsn.sh

pdsh -b -w $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u |  tr -t '\n' ',') '/bin/rm /tmp/limit_to_hsn.sh'
