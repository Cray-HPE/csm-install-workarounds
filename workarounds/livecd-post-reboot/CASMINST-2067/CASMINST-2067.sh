#!/bin/sh

echo 'Purging cloud-int udev' && pdsh -b -w $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u |  tr -t '\n' ',') 'rm -f /etc/udev/rules.d/85-persistent-net-cloud-init.rules;'

echo 'Moving ifnames into place' && pdsh -b -w $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u |  tr -t '\n' ',') '
ls -l /etc/udev/rules.d
ifname_rules=/etc/udev/rules.d/*ifname.rules
[ -f /etc/udev/rules.d/84-ifname.rules ] || mv $ifname_rules /etc/udev/rules.d/84-ifname.rules
ls -l /etc/udev/rules.d
'

echo 'Fixing mdadm.conf' &&  pdsh -b -w $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u |  tr -t '\n' ',') '
[ -f /etc/mdadm.conf ] && sed -i "s/homehost/hosthome/g" /etc/mdadm.conf || echo "no mdadm.conf to tweak on this image set"
'

echo 'Fixing cloud-init' && pdsh -b -w $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u |  tr -t '\n' ',') '
cat << EOF > /etc/cloud/cloud.cfg.d/00_casminst-2067.cfg
#cloud-config
network:
  config: none
EOF
echo
'

