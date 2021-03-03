# Copy Kernel/Initrd Into Place

After m001 is rebooted and has joined the cluster it is necessary to copy the kernel and initrd into place:

```text
ncn-m001# mount -L BOOTRAID /tmp/mount
ncn-m001# curl -o /tmp/mount/boot/initrd.img.xz http://rgw-vip.nmn/ncn-images/k8s-initrd.img.xz
ncn-m001# curl -o /tmp/mount/boot/kernel http://rgw-vip.nmn/ncn-images/k8s-kernel
ncn-m001# umount /tmp/mount
```