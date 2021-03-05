## CASMINST-1093 cloud-init failure/race-condition
If the nodes exhibit afflictions such as:
- no hostname (or a hostname of `ncn`)
- `mgmt0` or `mgmt1` does not indicate they exist in `bond0`, or has a mis-matching MTU of `1500` to the bond's members
- no route (`ip r` returns no `default` route)

### Procedure
1. First, restart the Basecamp service on the PIT and determine the PIT node's NMN (VLAN 2) IP address. In the output below is it `10.252.1.12`:
    ```bash
    pit# systemctl restart basecamp
    pit# ip addr show vlan002 | grep inet
    inet 10.252.1.12/17 brd 10.252.127.255 scope global vlan002
    inet6 fe80::1602:ecff:feda:b998/64 scope link
    ```

  This step only needs to be done once even if more than one node is impacted.
    
2. Use conman to connect to the afflicted node's console, and execute the steps below from the node's console:
    ```bash
    pit# conman -j ncn-w001-mgmt
    ```

3. Next, verify that valid data is returned for the afflicted node from Basecamp (the output should contain information 
  specific to the afflicted node like the hostname):

    Verify valid data is returned from Basecamp from the afflicted node, using the IP address found in step 1:
    ```bash
    ncn# curl http://10.252.1.12:8888/user-data
    ```

    Output similar to the following is expected:
    ```bash
    ncn# curl http://10.252.1.12:8888/user-data
    #cloud-config
    hostname: ncn-w001
    local_hostname: ncn-w001
    mac0:
      gateway: 10.252.0.1
      ip: ""
      mask: 10.252.2.0/23
    runcmd:
    - /srv/cray/scripts/metal/set-host-records.sh
    - /srv/cray/scripts/metal/set-dhcp-to-static.sh
    - /srv/cray/scripts/metal/set-dns-config.sh
    - /srv/cray/scripts/metal/set-ntp-config.sh
    - /srv/cray/scripts/metal/set-bmc-bbs.sh
    - /srv/cray/scripts/metal/install-bootloader.sh
    - /srv/cray/scripts/common/update_ca_certs.py
    - /srv/cray/scripts/common/kubernetes-cloudinit.sh
    ```

    
4. Finally, run the following script from the afflicted node **(but only in either of those circumstances)**.
    ```bash
    ncn# /srv/cray/scripts/metal/retry-ci.sh
    ```

5. Running `hostname` or logging out and back over ssh in should yield the proper hostname.