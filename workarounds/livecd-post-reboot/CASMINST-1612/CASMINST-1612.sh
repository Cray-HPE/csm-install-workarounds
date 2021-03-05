#!/usr/bin/env bash

set -ex

mount -L BOOTRAID /tmp/mount
curl -o /tmp/mount/boot/initrd.img.xz http://rgw-vip.nmn/ncn-images/k8s-initrd.img.xz
curl -o /tmp/mount/boot/kernel http://rgw-vip.nmn/ncn-images/k8s-kernel
umount /tmp/mount