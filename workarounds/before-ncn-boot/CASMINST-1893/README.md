# CASMINST-1893

1. on your pit node edit /var/www/ephemeral/configs/data.json
2. update the value for "num_storage_nodes" to be the total amount of utility storage nodes installed
   1. This data can be found in the your /var/www/ephemeral/prep/ncn_metadata.csv file

## Example

This meta data is located in the ***Global*** section

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
