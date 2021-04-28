# CASMINST-2105

Whenever an NCN is rebooted, and the boot is from PXE it's likely that the IP addresses it gets leased during dracut will not match up with the ones in the static configuration. 

The `CASMINST-2105.sh` script should be run after every reboot of an NCN (or if many reboots are planned after all of those have been completed). It is idempotent and can be run at any time from any NCN, however it's likely most convenient to run from m001 as that's where it's most likely to be installed already.

```text
ncn-m001# /opt/cray/csm/workarounds/after-ncn-reboot/CASMINST-2105.sh
```