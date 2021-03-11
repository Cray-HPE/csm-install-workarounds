# CASMINST-1725 (child of CASMINST-1706)

HSN interfaces are seen with illegal/non-BIOSDEVNAME interface aliases:

### Test for Bug Existence

```bash
# Bad
ncn# dmesg | grep rename
[   40.680128] qede 0000:c6:00.0 mgmt0: renamed from eth0
[   40.864451] qede 0000:c6:00.1 mgmt1: renamed from eth1
[   42.719999] mlx5_core 0000:03:00.0 hsn1: renamed from eth1
[   48.858873] mlx5_core 0000:86:00.0 hsn0: renamed from eth0
[  143.878423] mlx5_core 0000:86:00.0 ens1: renamed from hsn0  <--- hsn being overriden
[  143.966865] mlx5_core 0000:03:00.0 ens2: renamed from hsn1  <--- hsn being overriden

# Good
ncn# dmesg | grep rename
[   40.680128] qede 0000:c6:00.0 mgmt0: renamed from eth0
[   40.864451] qede 0000:c6:00.1 mgmt1: renamed from eth1
[   42.719999] mlx5_core 0000:03:00.0 hsn1: renamed from eth1
[   48.858873] mlx5_core 0000:86:00.0 hsn0: renamed from eth0  <-- no tampering with hsn
```

- `ens1` or `ens2`
- `enp`

### Cause

udev rules are overridden by `82-net-setup-link.rules`, that takes precedence to our `80-ifname.rules`.

### Workaround Steps

1. Down the interface(s):
    ```bash
    ncn# ip l s ens1 down
    ncn# ip l s ens2 down
    ```
2. Rename the interface: 
    ```bash
    ncn# ip l s ens1 name hsn0
    ncn# ip l s ens2 name hsn1
    ```
3. Up the interface(s):
   ```bash
   ncn# ip l s hsn0 up
   ncn# ip l s hsn1 up
   ```
4. Set persistence, so the names stick on the next reboot:
   ```bash
   ncn# rules=/etc/udev/rules.d/*ifname.rules
   ncn# mv $rules /etc/udev/rules.d/98-ifname.rules
   ```

Done.