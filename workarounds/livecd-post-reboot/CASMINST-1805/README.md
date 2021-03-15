# CASMINST-1806

This disables the fstrim crontab on all nodes, in an effort to bypass a
firmware crash condition.

# Steps

Run the script on ncn-m001:
```bash
./casminst-1806.sh
```

## Expected output:

When ran the first time:
```bash
ncn-s001: done
ncn-s002: done
ncn-s003: done
ncn-m001: done
ncn-w002: done
ncn-m002: done
ncn-m003: done
ncn-w001: done
ncn-w003: done
```

When already completed:
```bash
ncn-s001: removed already
ncn-s002: removed already
ncn-s003: removed already
ncn-m001: removed already
ncn-w002: removed already
ncn-m002: removed already
ncn-m003: removed already
ncn-w001: removed already
ncn-w003: removed already
```
