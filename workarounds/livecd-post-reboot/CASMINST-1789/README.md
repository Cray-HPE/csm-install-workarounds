# CASMINST-1789

Tune sysctl for better TCP memory.

This is necessary to prevent the error: `"TCP: out of memory -- consider tuning tcp_mem"`

## Directions

On ncn-m001, run the `casminst-1789.sh` script.

## Expected Output

```bash
# ./casminst-1789.sh
ncn-m001: net.ipv4.tcp_mem = 3083247 4110996 6166494
ncn-m002: net.ipv4.tcp_mem = 3083247 4110996 6166494
ncn-m003: net.ipv4.tcp_mem = 3083247 4110996 6166494
ncn-s001: net.ipv4.tcp_mem = 3083247 4110996 6166494
ncn-s002: net.ipv4.tcp_mem = 3083247 4110996 6166494
ncn-s003: net.ipv4.tcp_mem = 3083247 4110996 6166494
ncn-w001: net.ipv4.tcp_mem = 3083247 4110996 6166494
ncn-w002: net.ipv4.tcp_mem = 3083247 4110996 6166494
ncn-w003: net.ipv4.tcp_mem = 3083247 4110996 6166494
```
