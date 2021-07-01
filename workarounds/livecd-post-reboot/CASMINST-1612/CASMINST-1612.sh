#!/usr/bin/env bash

echo Opening and refreshing fallback artifacts on the NCNs..
pdsh -b -S -w $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u |  tr -t '\n' ',') '
set -x
RC=1
if ! mkdir -pv /tmp/mount ; then
    echo >&2 "ERROR: mkdir command failed"
    exit 1
elif ! mount -vL BOOTRAID /tmp/mount/ ; then
    echo >&2 "ERROR: mount command failed"
    exit 1
elif [ ! -d /tmp/mount/boot ]; then
    echo >&2 "ERROR: BOOTRAID is missing grub and more"
elif ! cp -pv /run/initramfs/live/LiveOS/initrd* /tmp/mount/boot/initrd.img.xz ; then
    # We assume there should only be one initrd file in the LiveOS directory. If there
    # are multiple, the copy will fail, which is what we want.
    echo >&2 "ERROR: cp command failed"
elif ! cp -pv /run/initramfs/live/LiveOS/kernel /tmp/mount/boot/ ; then
    echo >&2 "ERROR: cp command failed"
else
    # Both copies succeeded
    RC=0
fi
umount -v /tmp/mount || echo >&2 "WARNING: umount command failed"
exit $RC
' && echo -e "\nDone. WAR successfully applied." && exit 0

echo -e >&2 "\nERROR: Unable to apply WAR on one or more NCNs"
exit 1
