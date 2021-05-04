# CASMINST-1905 Workaround

The dhcp-range in dnsmasq.d/CAN.conf can be calculated wrong in some circumstances.
To make sure this configuration is correct, run the casminst-1905.sh script in this directory from the system where you
are performing the csi configuration steps.
You will need to specify the directory where the CSI generated config files are located after running `csi config init`.

If you are installing using the USB stick (003-CSM-USB-LIVECD.md), use /mnt/pitdata/prep/${SYSTEM_NAME}

If you are installing using the RemoteISO (004-CSM-REMOTE-LIVECD.md), use /var/www/ephemeral/prep/${SYSTEM_NAME}

```bash
linux# export SYSTEM_NAME=eniac
linux# ./casminst-1905.sh /var/www/ephemeral/prep/${SYSTEM_NAME}
```

Expected output:
```bash
linux# export SYSTEM_NAME=eniac
linux# ./casminst-1905.sh /var/www/ephemeral/prep/${SYSTEM_NAME}
Replacing 10.102.3.214 with 10.102.3.112 in dhcp-range for CAN
Replaced range end in dnsmasq.d/CAN.conf
Replaced range end in networks/CAN.yaml
Replaced range end in sls_input_file.json
```
