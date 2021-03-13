# CASMINST-1729

Tune sysctl for better ARP cache.

This is necessary for interaction with computes, like mountain.

## Directions

On ncn-m001, run the `casminst-1729.sh` script.

## Expected Output

```bash
# ./casminst-1729.sh
ncn-s002: net.ipv4.neigh.default.gc_thresh1 = 2048
ncn-s002: net.ipv4.neigh.default.gc_thresh2 = 4096
ncn-s002: net.ipv4.neigh.default.gc_thresh3 = 8192
ncn-s002: net.ipv4.neigh.default.gc_interval = 30
ncn-s003: net.ipv4.neigh.default.gc_thresh1 = 2048
ncn-s002: net.ipv4.neigh.default.gc_stale_time = 240
ncn-s003: net.ipv4.neigh.default.gc_thresh2 = 4096
ncn-s003: net.ipv4.neigh.default.gc_thresh3 = 8192
ncn-s003: net.ipv4.neigh.default.gc_interval = 30
ncn-s001: net.ipv4.neigh.default.gc_thresh1 = 2048
ncn-s003: net.ipv4.neigh.default.gc_stale_time = 240
ncn-s001: net.ipv4.neigh.default.gc_thresh2 = 4096
ncn-s001: net.ipv4.neigh.default.gc_thresh3 = 8192
ncn-s001: net.ipv4.neigh.default.gc_interval = 30
ncn-s001: net.ipv4.neigh.default.gc_stale_time = 240
ncn-m001: net.ipv4.neigh.default.gc_thresh1 = 2048
ncn-m001: net.ipv4.neigh.default.gc_thresh2 = 4096
ncn-m001: net.ipv4.neigh.default.gc_thresh3 = 8192
ncn-m001: net.ipv4.neigh.default.gc_interval = 30
ncn-m001: net.ipv4.neigh.default.gc_stale_time = 240
ncn-w002: net.ipv4.neigh.default.gc_thresh1 = 2048
ncn-w002: net.ipv4.neigh.default.gc_thresh2 = 4096
ncn-w002: net.ipv4.neigh.default.gc_thresh3 = 8192
ncn-w002: net.ipv4.neigh.default.gc_interval = 30
ncn-w002: net.ipv4.neigh.default.gc_stale_time = 240
ncn-m002: net.ipv4.neigh.default.gc_thresh1 = 2048
ncn-m003: net.ipv4.neigh.default.gc_thresh1 = 2048
ncn-m002: net.ipv4.neigh.default.gc_thresh2 = 4096
ncn-m002: net.ipv4.neigh.default.gc_thresh3 = 8192
ncn-m003: net.ipv4.neigh.default.gc_thresh2 = 4096
ncn-m002: net.ipv4.neigh.default.gc_interval = 30
ncn-m003: net.ipv4.neigh.default.gc_thresh3 = 8192
ncn-m003: net.ipv4.neigh.default.gc_interval = 30
ncn-m002: net.ipv4.neigh.default.gc_stale_time = 240
ncn-m003: net.ipv4.neigh.default.gc_stale_time = 240
ncn-w001: net.ipv4.neigh.default.gc_thresh1 = 2048
ncn-w001: net.ipv4.neigh.default.gc_thresh2 = 4096
ncn-w001: net.ipv4.neigh.default.gc_thresh3 = 8192
ncn-w001: net.ipv4.neigh.default.gc_interval = 30
ncn-w001: net.ipv4.neigh.default.gc_stale_time = 240
ncn-w003: net.ipv4.neigh.default.gc_thresh1 = 2048
ncn-w003: net.ipv4.neigh.default.gc_thresh2 = 4096
ncn-w003: net.ipv4.neigh.default.gc_thresh3 = 8192
ncn-w003: net.ipv4.neigh.default.gc_interval = 30
ncn-w003: net.ipv4.neigh.default.gc_stale_time = 240
```
