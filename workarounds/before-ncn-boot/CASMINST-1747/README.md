# Adjust k8s partition sizes

This workaround script, `casminst-1747.sh`, in the same directory as this README should be run on the PIT prior to PXE booting nodes.

This adjusts the partition sizes for k8s by editing some kernel parameters in /var/www/script.ipxe.

These changes are synced to each nodes boot folder on the PIT. This is all done on the PIT prior to PXE booting the NCNs.

If you want to verify the change is in place, you can run:

```bash
grep --color 'metal.disk' /var/www/ncn-*/script.ipxe
```

and verify these two values are set as below:

```
metal.disk.conlib.size=40
metal.disk.k8slet.size=10
```
