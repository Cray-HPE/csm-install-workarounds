#!/bin/sh

LIMITSH="limit_to_hsn.sh"

if [ ! -f ./$LIMITSH ]; then
    echo "ERROR: $LIMITSH not found in the current directory. Be sure to run this from the NETETH-1275 directory."
    exit 1
fi

for ncn in $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u); do
    scp ./$LIMITSH "$ncn":/tmp/
done

pdsh -b -w $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u |  tr -t '\n' ',') /tmp/$LIMITSH

pdsh -b -w $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u |  tr -t '\n' ',') "/bin/rm /tmp/$LIMITSH"
