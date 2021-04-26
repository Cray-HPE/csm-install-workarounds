# NETETH-1275

This WAR modifies the `shasta-network-lldp.sh` script so that it only operates
on HSN devices.

## Directions

Run `NETETH-1275.sh` on m001. You must run the script from the NETETH-1275 directory.

## Expected Output

```bash
ncn-m001 # cd /opt/cray/csm/workarounds/livecd-post-reboot/NETETH-1275
ncn-m001 # ./NETETH-1275.sh
limit_to_hsn.sh                                  100%  556   738.1KB/s   00:00
limit_to_hsn.sh                                  100%  556   519.8KB/s   00:00
limit_to_hsn.sh                                  100%  556   656.1KB/s   00:00
limit_to_hsn.sh                                  100%  556   509.6KB/s   00:00
limit_to_hsn.sh                                  100%  556   428.0KB/s   00:00
limit_to_hsn.sh                                  100%  556   560.8KB/s   00:00
limit_to_hsn.sh                                  100%  556     1.1MB/s   00:00
limit_to_hsn.sh                                  100%  556     1.1MB/s   00:00
limit_to_hsn.sh                                  100%  556   365.9KB/s   00:00
ncn-s001: patch applied successfully
ncn-s003: patch applied successfully
ncn-s002: patch applied successfully
ncn-m003: patch applied successfully
ncn-m002: patch applied successfully
ncn-w003: patch applied successfully
ncn-m001: patch applied successfully
ncn-w001: patch applied successfully
ncn-w002: patch applied successfully
ncn-m001 #
```

