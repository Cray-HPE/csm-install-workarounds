# CASMINST-1725

Fix HSN udev rules on nodes afflicted with non-BIOSDEVNAME nodes.

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

## Directions

On ncn-m001, run the `casminst-1725.sh` script.

When the script is re-ran it will have a few errors, but it will show that the file was already copied.
