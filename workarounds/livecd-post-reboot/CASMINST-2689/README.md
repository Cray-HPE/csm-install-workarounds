## CASMINST-2689 xml kernel/initrd

After a CSM 0.9.3 install, the kernel and initrd files copied into `/run/initramfs/live/LiveOS` directory are corrupted and contain XML rather than the correct contents. Then, when the CASMINST-1612 workaround is applied, these bad artifacts are copied to the `BOOTRAID`, which can cause the machines to be unable to boot from disk.

## Applying this fix

Initialize `cray init` and then run the script on m001 if it is no longer the PIT (post-handoff):

```bash
cray init
/opt/cray/csm/workarounds/livecd-post-reboot/CASMINST-2689/CASMINST-2689.sh
```

## Output

Showing nominal behavior when artifacts are good, when a file is missing, and when a file is actually XML.

```
ncn-m001:~ # /opt/cray/csm/workarounds/livecd-post-reboot/CASMINST-2689/CASMINST-2689.sh
==> ncn-s002...
CASMINST-2689-lib.sh  100% 3015     3.6MB/s   00:00
Examining kernel...kernel is OK.
Examining initrd...initrd.img.xz is OK.
...
...
...
==> ncn-m002...
CASMINST-2689-lib.sh  100% 3354     4.1MB/s   00:00
Examining kernel...
/metal/boot/boot/kernel size is too small or not an expected file type (218:text/xml)
Getting kernel from s3 (s3://ncn-images/k8s-kernel)...
The new on-disk boot artifacts will not take effect until a restart of the machine.
Examining initrd...initrd.img.xz not found in BOOTRAID.
Getting initrd.img.xz from s3 (s3://ncn-images/k8s-initrd.img.xz)...
The new on-disk boot artifacts will not take effect until a restart of the machine.
```
