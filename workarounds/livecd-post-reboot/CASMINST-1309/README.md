# WORKAROUND: NCN BMCs receiving alternate IP address from DHCP

At the conclusion of the CSM install, there is an issue where the management NCN BMCs could have both a static IP address and a 
DHCP-assigned IP address. This affects the ability to power cycle management NCNs using CAPMC and apply firmware changes using
FAS. The following temporary procedure corrects this until a permanent fix is in place.

The symptoms of this problem are:
* The NCN BMC is no longer reached by its xname (such as `x3000c0s4b0`)
* The NCN BMC alias has multiple IP addresses

```
ncn-m001:~ # nslookup ncn-w001-mgmt
Server:		10.92.100.225
Address:	10.92.100.225#53

Name:	ncn-w001-mgmt
Address: 10.254.1.56
Name:	ncn-w001-mgmt
Address: 10.254.1.13
```

This procedure is always safe to run.

1. Get an API token
    ```bash
    ncn-m001# export TOKEN=$(curl -s -S -d grant_type=client_credentials \
                          -d client_id=admin-client \
                          -d client_secret=`kubectl get secrets admin-client-auth -o jsonpath='{.data.client-secret}' | base64 -d` \
                          https://api-gw-service-nmn.local/keycloak/realms/shasta/protocol/openid-connect/token | jq -r '.access_token')
    ```

2. Run the `CASMINST-1309.sh` script
    ```bash
    ncn-m001# /opt/cray/csm/workarounds/livecd-post-reboot/CASMINST-1309/CASMINST-1309.sh
    deployment.apps/cray-dhcp-kea restarted
    Sending cold reset to ncn-m002 BMC...
    Sent cold reset command to MC
    Sending cold reset to ncn-m003 BMC...
    Sent cold reset command to MC
    Sending cold reset to ncn-w001 BMC...
    Sent cold reset command to MC
    Sending cold reset to ncn-w002 BMC...
    Sent cold reset command to MC
    Sending cold reset to ncn-s002 BMC...
    Sent cold reset command to MC
    Sending cold reset to ncn-w003 BMC...
    Sent cold reset command to MC
    Sending cold reset to ncn-s001 BMC...
    Sent cold reset command to MC
    Sending cold reset to ncn-s003 BMC...
    Sent cold reset command to MC
    Deleting 9440c937f9b4 from EthernetInterfaces...
    code = 0
    message = "deleted 1 entry"
    
    Deleting 9440c9370484 from EthernetInterfaces...
    code = 0
    message = "deleted 1 entry"
    
    Deleting 9440c9376760 from EthernetInterfaces...
    code = 0
    message = "deleted 1 entry"
    
    Deleting 9440c9350306 from EthernetInterfaces...
    code = 0
    message = "deleted 1 entry"
    
    Deleting 9440c937875a from EthernetInterfaces...
    code = 0
    message = "deleted 1 entry"
    
    Deleting 9440c93777b8 from EthernetInterfaces...
    code = 0
    message = "deleted 1 entry"
    
    Deleting 9440c9370a2a from EthernetInterfaces...
    code = 0
    message = "deleted 1 entry"
    
    Deleting 9440c9377726 from EthernetInterfaces...
    code = 0
    message = "deleted 1 entry"
    ```

3. After waiting a few minutes for DNS to settle, there should be only one IP address present for each of the affected BMCs, for both their xname hostname and alias. Verify this for all affected BMCs.
    The NCN BMC xname hostname should only have 1 address:
    ```bash
    ncn-m001# nslookup x3000c0s4b0
    Server:		10.92.100.225
    Address:	10.92.100.225#53

    Name:	x3000c0s4b0.hmn
    Address: 10.254.1.13
    ```

    The NCN BMC alias should only have 1 address:
    ```bash
    ncn-m001# nslookup ncn-w001-mgmt
    Server:		10.92.100.225
    Address:	10.92.100.225#53

    Name:	ncn-w001-mgmt
    Address: 10.254.1.13
    ```

4. Each of the affected BMCs should now be pingable by its xname hostname and alias. Verify this for all affected BMCs.
    ```bash
    ncn-m001# ping x3000c0s4b0
    PING x3000c0s4b0.hmn (10.254.1.13) 56(84) bytes of data.
    64 bytes from ncn-w001-mgmt (10.254.1.13): icmp_seq=1 ttl=255 time=0.201 ms
    64 bytes from ncn-w001-mgmt (10.254.1.13): icmp_seq=2 ttl=255 time=0.221 ms
    ^C
    --- x3000c0s4b0.hmn ping statistics ---
    2 packets transmitted, 2 received, 0% packet loss, time 1000ms
    rtt min/avg/max/mdev = 0.201/0.211/0.221/0.010 ms
    ```

    ```
    ncn-m001# ping ncn-w001-mgmt
    PING ncn-w001-mgmt (10.254.1.13) 56(84) bytes of data.
    64 bytes from ncn-w001-mgmt (10.254.1.13): icmp_seq=1 ttl=255 time=0.265 ms
    64 bytes from ncn-w001-mgmt (10.254.1.13): icmp_seq=2 ttl=255 time=0.206 ms
    ^C
    --- ncn-w001-mgmt ping statistics ---
    2 packets transmitted, 2 received, 0% packet loss, time 1000ms
    rtt min/avg/max/mdev = 0.206/0.235/0.265/0.033 ms
    ```
