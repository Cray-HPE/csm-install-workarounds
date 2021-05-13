#!/usr/bin/env bash

set -e

echo Opening and refreshing fallback artifacts on the NCNs..
pdsh -b -w $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u |  tr -t '\n' ',') '
set -x
mount -L BOOTRAID /tmp/mount
if [[ $(hostname) =~ 'ncn-s' ]]; then
	curl -o /tmp/mount/boot/initrd.img.xz http://rgw-vip.nmn/ncn-images/ceph-initrd.img.xz
	curl -o /tmp/mount/boot/kernel http://rgw-vip.nmn/ncn-images/ceph-kernel
else
	curl -o /tmp/mount/boot/initrd.img.xz http://rgw-vip.nmn/ncn-images/k8s-initrd.img.xz
	curl -o /tmp/mount/boot/kernel http://rgw-vip.nmn/ncn-images/k8s-kernel
fi
umount /tmp/mount
'
echo done
