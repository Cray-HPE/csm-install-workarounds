# CASMINST-2105

Whenever an NCN is booted (either for the first time or as a result of a reboot) and the boot is from PXE it is likely 
that the IP addresses it gets leased during dracut will not match up with the ones in the static configuration. 
The end result is interfaces with two configured IP addresses. While this should not cause any issues it's best to only 
have the correct IP address assigned to all the interfaces.  

The `CASMINST-2105.sh` script should be run after every (re)boot of an NCN (or if many reboots are planned after all of 
those have been completed). It is idempotent and can be run at any time from any NCN, however it is likely most 
convenient to run from m001 as that is where it is most likely to be installed already.

```text
ncn-m001# /opt/cray/csm/workarounds/after-ncn-boot/CASMINST-2105.sh
```