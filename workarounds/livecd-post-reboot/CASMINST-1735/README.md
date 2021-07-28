# CASMINST-1735

This fixes SAT tools by shimming the NCN's own `sshd_config` into place.

## Directions

Run `casminst-1735.sh` on m001.

## Expected Output

```
'/srv/cray/resources/metal/sshd_config' -> '/etc/ssh/sshd_config'
'/srv/cray/resources/metal/sshd_config' -> '/etc/ssh/sshd_config'
'/srv/cray/resources/metal/sshd_config' -> '/etc/ssh/sshd_config'
'/srv/cray/resources/metal/sshd_config' -> '/etc/ssh/sshd_config'
'/srv/cray/resources/metal/sshd_config' -> '/etc/ssh/sshd_config'
'/srv/cray/resources/metal/sshd_config' -> '/etc/ssh/sshd_config'
'/srv/cray/resources/metal/sshd_config' -> '/etc/ssh/sshd_config'
'/srv/cray/resources/metal/sshd_config' -> '/etc/ssh/sshd_config'
'/srv/cray/resources/metal/sshd_config' -> '/etc/ssh/sshd_config'
HANGUP was sent to sshd on all NCNs to reload the new sshd_config
This is the end of CASMINST-1735
```
