# WORKAROUND: NCN BMCs receiving alternate IP address from DHCP

At the conclusion of the CSM install, there is an issue where the management NCN BMCs could have both a static IP and a DHCP assigned IP address. This affects our ability to power cycle management NCNs via CAPMC and apply firmware changes via FAS. The following temporary procedure corrects this until a permanent fix is in place.

This manifests as the NCN BMC is no longer reached by its xname such as `x3000c0s4b0`, and the NCN BMC alias has multiple IP addresses:
```
ncn-m001:~ # nslookup ncn-w001-mgmt
Server:		10.92.100.225
Address:	10.92.100.225#53

Name:	ncn-w001-mgmt
Address: 10.254.1.56
Name:	ncn-w001-mgmt
Address: 10.254.1.13
```

> The following commands expect the cray cli to already be initialized by the `cray init` command

1. Scale KEA down. This will prevent KEA from putting back any MAC addresses that are removed in the next steps.
    ```bash
    ncn-m001# kubectl scale -n services deployments/cray-dhcp-kea --replicas=0
    ```

2. Get an API Token
    ```bash
    ncn-m001# export TOKEN=$(curl -s -S -d grant_type=client_credentials \
                          -d client_id=admin-client \
                          -d client_secret=`kubectl get secrets admin-client-auth -o jsonpath='{.data.client-secret}' | base64 -d` \
                          https://api-gw-service-nmn.local/keycloak/realms/shasta/protocol/openid-connect/token | jq -r '.access_token')
    ```

3. Determine the BMC xnames for the management NCNs:
    ```bash
    ncn-m001# curl -s -k -H "Authorization: Bearer ${TOKEN}" \
        https://api-gw-service-nmn.local/apis/sls/v1/search/hardware?extra_properties.Role=Management \
        | jq '.[] | { BMCXName: .Parent, NodeAliases: .ExtraProperties.Aliases}' -c
    ```

    ```
    ncn-m001# curl -s -k -H "Authorization: Bearer ${TOKEN}" https://api-gw-service-nmn.local/apis/sls/v1/search/hardware?extra_properties.Role=Management \
        | jq '.[] | { BMCXName: .Parent, NodeAliases: .ExtraProperties.Aliases}' -c
    {"BMCXName":"x3000c0s6b0","NodeAliases":["ncn-w003"]}
    {"BMCXName":"x3000c0s7b0","NodeAliases":["ncn-s001"]}
    {"BMCXName":"x3000c0s5b0","NodeAliases":["ncn-w002"]}
    {"BMCXName":"x3000c0s1b0","NodeAliases":["ncn-m001"]}
    {"BMCXName":"x3000c0s2b0","NodeAliases":["ncn-m002"]}
    {"BMCXName":"x3000c0s3b0","NodeAliases":["ncn-m003"]}
    {"BMCXName":"x3000c0s4b0","NodeAliases":["ncn-w001"]}
    {"BMCXName":"x3000c0s8b0","NodeAliases":["ncn-s002"]}
    {"BMCXName":"x3000c0s9b0","NodeAliases":["ncn-s003"]}
    ```


4. For each BMC xname found in the step above query the HSM ethernet interfaces table. The BMC associated with ncn-m001 should be skipped, as it will not have not have been discovered by HSM. 
    
    Replace `x3000c0s4b0` with the xname of the NCN BMC you wish to query. __Note__ the BMC xname should end with `b0`, do __NOT__ use the node xname that ends with `n0`.
    ```bash
    ncn-m001# cray hsm inventory ethernetInterfaces list --component-id x3000c0s4b0 --format json | jq '.[] | {ID: .ID, Type: .Type, IPAddresses: .IPAddresses}' -c
    ```

    If __none__ of the MAC addresses associated with the BMC have an IP address associated to them, then that NCN BMC is not affected. The steps below do not need to be applied to that particular BMC.
    ```json
    ncn-m001# cray hsm inventory ethernetInterfaces list --component-id x3000c0s4b0 --format json | jq '.[] | {ID: .ID, Type: .Type, IPAddresses: .IPAddresses}' -c
    {"ID":"9440c9376761","Type":"NodeBMC","IPAddresses":[]}
    ```

    If __any__ of the MAC addresses associated with the BMC have an IP address associated to them, then that NCN BMC is affected and the steps below need to applied to it.
    ```json
    ncn-m001# cray hsm inventory ethernetInterfaces list --component-id x3000c0s4b0 --format json | jq '.[] | {ID: .ID, Type: .Type, IPAddresses: .IPAddresses}' -c
    {"ID":"9440c9376760","Type":"NodeBMC","IPAddresses":[{"IPAddress":"10.254.1.56"}]}
    {"ID":"9440c9376761","Type":"NodeBMC","IPAddresses":[]}
    ```

5. SSH to all the affected NCNs and run `ipmitool mc reset cold`. This will force the BMC to revert back to its statically assigned IP address, after it resets.

6. For each affected NCN BMCs delete their MAC address is associated with an IP address.
    > Replace `9440c9376760` with the normalized MAC address found in the command above
    ```
    ncn-m001# cray hsm inventory ethernetInterfaces delete 9440c9376760
    code = 0
    message = "deleted 1 entry"
    ```

7. Scale KEA back up to 1 replica.
    ```bash
    ncn-m001# kubectl scale -n services deployments/cray-dhcp-kea --replicas=1
    ```

8. Wait a few minutes for DNS to settle and only 1 IP address should be present for each of the affected BMC for both their xname hostname and alias. Verify this for all affected BMCs.
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

9. All of the affected BMCs should now be pingable by its xname hostname and NCN BMC alias. Verify this for all affected BMCs.
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