# CASMINST-3341 Enabling Kdump

This enables kdump on the NCNs.  In additional to applying it as part of a fresh install, tt needs to be applied if you rebuild and NCN.

## Applying this fix

Run the script on m001:

```bash
/opt/cray/csm/workarounds/livecd-post-reboot/CASMINST-3341/CASMINST-3341.sh
```