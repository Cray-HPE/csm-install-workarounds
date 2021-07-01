# Copy Kernel/Initrd Into Place

After an NCN is rebooted and has joined the cluster it is necessary to copy the kernel and initrd into place 
by running the `CASMINST-1612.sh` script on m001.

The WAR was applied successfully if the final line of output is:
```
Done. WAR successfully applied.
```