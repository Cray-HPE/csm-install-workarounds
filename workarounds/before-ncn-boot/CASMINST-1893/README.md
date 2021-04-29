# CASMINST-1893

1. On your pit node edit `/var/www/ephemeral/configs/data.json`.
2. Update the value for "num_storage_nodes" to be the total number of utility storage nodes installed, 
   if it differs from the actual number.
    - This data can be found in the `/var/www/ephemeral/prep/ncn_metadata.csv` file.

## Example

This metadata is located in the **Global** section

```json
      "ntp_peers": "ncn-m001 ncn-w002 ncn-s001 ncn-s003 ncn-w003 ncn-m002 ncn-m003 ncn-w001 ncn-s002",
      "num_storage_nodes": "3",     <-------- Update this!!
      "rgw-virtual-ip": "REDACTED",
      "site-domain": "dev.cray.com",
      "system-name": "redbull",
      "upstream_ntp_server": "time.nist.gov",
      "wipe-ceph-osds": "yes"
```

> **Note:** You may need to restart basecamp after making this change
```bash
pit# systemctl restart basecamp
```
