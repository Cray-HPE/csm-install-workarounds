#!/usr/bin/env bash

set -e

echo Opening and refreshing fallback artifacts on the NCNs..
pdsh -b -w $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u |  tr -t '\n' ',') '
set -x
mkdir -pv /tmp/mount
mount -L BOOTRAID /tmp/mount/
[ -d /tmp/mount/boot ] || echo >&2 BOOTRAID is missing grub and more && exit 1
cp -pv /run/initramfs/live/LiveOS/initrd.img.xz /tmp/mount/boot
cp -pv /run/initramfs/live/LiveOS/kernel /tmp/mount/boot/
umount /tmp/mount
'
echo done
