# When Wiping and Rejoining A Previously Joined NCN

- When the node boots into its image.  The IPs will be incorrect and will need to manually update the ifcfg files
- You will need to do a dig.
    - Example for NCN-W002
    ```
    ncn-m001:/mnt/livecd # dig ncn-w002.nmn +short
    10.252.1.13
    ncn-m001:/mnt/livecd # dig ncn-w002.hmn +short
    10.254.1.22
    ncn-m001:/mnt/livecd # dig ncn-w002.can +short
    10.103.8.14
    ncn-m001:/mnt/livecd # dig ncn-w002.mtl +short
    10.1.1.11
    ncn-m001:/mnt/livecd # 
    ```
- Update the ifcfg files IPs from the dig output.  The standard mapping for VLAN ID to name is:
    ```
    ncn-m001:~ # ls /etc/sysconfig/network|grep ifcfg-vlan
    ifcfg-vlan002
    ifcfg-vlan004
    ifcfg-vlan007
    ncn-m001:~ # 
    ```
    VLAN ID to Name mapping

    | VLAN ID  | Name|
    |----------|-----|
    | 002      | NMN |
    | 004      | HMN |
    | 007      | CAN |
  
- Check each ifcfg-vlan00[2,4,7] to make sure the appropiate IP has been configured in the file.  If the IP is not correct, update the file and save.
    - **In most cases ifcfg-vlan002 should have the expected IP**
- After ifcfg-vlan000[2,4,7] IPs have been confirmed and set.  Restart networking with following command:
    ```
    wicked ifreload  vlan004 vlan007
    ```
