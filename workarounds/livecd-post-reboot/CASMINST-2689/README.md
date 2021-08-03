## CASMINST-2689 xml kernel/initrd

After a CSM 0.9.3 install, the kernel and initrd files copied into `/run/initramfs/live/LiveOS` directory are corrupted and contain XML rather than the correct contents. Then, when the CASMINST-1612 workaround is applied, these bad artifacts are copied to the `BOOTRAID`, which can cause the machines to be unable to boot from disk.

## Applying this fix

Run the script on m001 if it is no longer the PIT (post-handoff)

```bash
/opt/cray/csm/workarounds/livecd-post-reboot/CASMINST-2689/CASMINST-2689.sh
```

Copy the script to each node (adjusting the number of NCNs if needed):

```bash
for i in $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u | grep -v ncn-m001 |  tr -t '\n' ' ')
do
  ssh $i 'mkdir -pv /opt/cray/csm/workarounds/livecd-post-reboot/'
  pushd /opt/cray/csm/workarounds/livecd-post-reboot/ || exit 1
    scp -r ./CASMINST-2689/ $i:/opt/cray/csm/workarounds/livecd-post-reboot/
  popd || exit 1  
done
```

If not already done, login using `cray init` on the each of the nodes, replacing `OPTIONS` with the options specific to your environment.

```bash
for i in $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u | grep -v ncn-m001 |  tr -t '\n' ' ')
do
  ssh $i 'cray init OPTIONS'
done
```

Then, run the script:

```bash
pdsh -b -S -w $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u | grep -v ncn-m001 |  tr -t '\n' ',') '/opt/cray/csm/workarounds/livecd-post-reboot/CASMINST-2689/CASMINST-2689.sh'
```

## Output

Behavior with a missing boot artifact (kernel in this example):

```
ncn-m002:~ # mount -L BOOTRAID -T /etc/fstab.metal
ncn-m002:~ # ls -l /metal/boot/boot/
total 59576
drwxr-xr-x 4 root root     4096 May  4 16:09 grub2
-rwxr-xr-x 1 root root 52453152 Jul 20 16:52 initrd.img.xz
-rwxr-xr-x 1 root root  8544576 Jul 20 16:46 kernel
ncn-m002:~ # rm /metal/boot/boot/kernel
ncn-m002:~ # ./CASMINST-2689.sh
Examining /metal/boot/boot/kernel...kernel not found in BOOTRAID.
Getting kernel from s3 (http://rgw-vip.nmn/ncn-images/k8s-kernel)...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 8344k  100 8344k    0     0   262M      0 --:--:-- --:--:-- --:--:--  271M
Examining /metal/boot/boot/initrd.img.xz...initrd.img.xz is OK.
The new on-disk boot artifacts will not take effect until a restart of the machine.
```

Behavior with bad artifacts (XML error messages in boot artifact files).

```
ncn-m002:~ # mount -L BOOTRAID -T /etc/fstab.metal ; ls -l /metal/boot/boot/
ncn-m002:~ # ls -l /metal/boot/boot/
total 12
drwxr-xr-x 4 root root 4096 May  4 16:09 grub2
-rwxr-xr-x 1 root root  217 Jul 20 17:36 initrd.img.xz
-rwxr-xr-x 1 root root  217 Jul 20 17:36 kernel
ncn-m002:~ # ./CASMINST-2689.sh
Examining /metal/boot/boot/kernel...
/metal/boot/boot/kernel size is too small or not an expected file type (217:text/xml)
Getting kernel from s3 (http://rgw-vip.nmn/ncn-images/k8s-kernel)...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 8344k  100 8344k    0     0   291M      0 --:--:-- --:--:-- --:--:--  291M
Examining /metal/boot/boot/initrd.img.xz...
/metal/boot/boot/initrd.img.xz size is too small or not an expected file type (217:text/xml)
Getting initrd.img.xz from s3 (http://rgw-vip.nmn/ncn-images/k8s-initrd.img.xz)...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 50.0M  100 50.0M    0     0   537M      0 --:--:-- --:--:-- --:--:--  537M
The new on-disk boot artifacts will not take effect until a restart of the machine.
ncn-m002:~ # mount -L BOOTRAID -T /etc/fstab.metal ; ls -l /metal/boot/boot/
total 59576
drwxr-xr-x 4 root root     4096 May  4 16:09 grub2
-rwxr-xr-x 1 root root 52453152 Jul 20 17:36 initrd.img.xz
-rwxr-xr-x 1 root root  8544576 Jul 20 17:36 kernel
```

Output when artifacts are nominal:

```
redbull-ncn-m001-pit:~ # for i in ncn-m00{2..3} ncn-{w,s}00{1..3}; do ssh $i '~/CASMINST-2689.sh' ; done
Examining /metal/recovery/boot/kernel...kernel is OK.
Examining /metal/recovery/boot/initrd.img.xz...initrd.img.xz is OK.
Examining /metal/recovery/boot/kernel...kernel is OK.
Examining /metal/recovery/boot/initrd.img.xz...initrd.img.xz is OK.
Examining /metal/recovery/boot/kernel...kernel is OK.
Examining /metal/recovery/boot/initrd.img.xz...initrd.img.xz is OK.
Examining /metal/recovery/boot/kernel...kernel is OK.
Examining /metal/recovery/boot/initrd.img.xz...initrd.img.xz is OK.
Examining /metal/recovery/boot/kernel...kernel is OK.
Examining /metal/recovery/boot/initrd.img.xz...initrd.img.xz is OK.
Examining /metal/recovery/boot/kernel...kernel is OK.
Examining /metal/recovery/boot/initrd.img.xz...initrd.img.xz is OK.
Examining /metal/recovery/boot/kernel...kernel is OK.
Examining /metal/recovery/boot/initrd.img.xz...initrd.img.xz is OK.
Examining /metal/recovery/boot/kernel...kernel is OK.
Examining /metal/recovery/boot/initrd.img.xz...initrd.img.xz is OK.
```
