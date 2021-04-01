# CASMINST-1905 Workaround

The dhcp-range in dnsmasq.d/CAN.conf can be calculated wrong in some circumstances.
To make sure this configuration is correct, run the casminst-1905.sh script in this directory from the PIT server.
You will need to specify the directory where the CSI generated config files are located after running `csi config init`.
For example:   /var/www/ephemeral/prep/${SYSTEM_NAME}

The script will restart dnsmasq to pick up the changed dhcp-range.

```bash
pit# export SYSTEM_NAME=eniac
pit# ./casminst-1905.sh /var/www/ephemeral/prep/${SYSTEM_NAME}
```

Expected output:
```bash
pit# export SYSTEM_NAME=eniac
pit # ./casminst-1905.sh /var/www/ephemeral/prep/${SYSTEM_NAME}
Replacing 10.103.11.214 with 10.103.11.112 in dhcp-range for CAN
Restarting dnsmasq...
```
