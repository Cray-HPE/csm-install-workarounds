# CASMINST-1403

CSI generates a spurious route to the NMN supernet for the `spec.wlm.macvlansetup.routes` list:
```
spec:
  ...
  wlm:
    ...
    macvlansetup:
      nmn_subnet: 10.252.2.0/23
      nmn_supernet: 10.252.0.0/17
      nmn_supernet_gateway: 10.252.0.1
      nmn_vlan: vlan002
      nmn_dhcp_start: 10.252.2.10
      nmn_dhcp_end: 10.252.3.254
      routes:
      - dst: 10.92.100.0/24
        gw: 10.252.0.1
      - dst: 10.106.0.0/17
        gw: 10.252.0.1
      - dst: 10.252.0.0/17
        gw: 10.252.0.1
    ...
 ```
Notice that in this example, the value for `nmn_supernet` is listed as a destination in the `routes` list:  
```
      - dst: 10.252.0.0/17
        gw: 10.252.0.1
```
That entry must be removed before merging the CSI generated `customizations.yaml` with the base `customizations.yaml` to obtain a good network attachment (macvlan) setup for UAIs and workload management.

The corrected `macvlansetup` (based on the above example) looks like this:
```
spec:
  ...
  wlm:
    ...
    macvlansetup:
      nmn_subnet: 10.252.2.0/23
      nmn_supernet: 10.252.0.0/17
      nmn_supernet_gateway: 10.252.0.1
      nmn_vlan: vlan002
      nmn_dhcp_start: 10.252.2.10
      nmn_dhcp_end: 10.252.3.254
      routes:
      - dst: 10.92.100.0/24
        gw: 10.252.0.1
      - dst: 10.106.0.0/17
        gw: 10.252.0.1
    ...
 ```
 
1. Go to the directory where CSI generated its configs. This will be under `"/mnt/pitdata/prep/${SYSTEM_NAME}"`
    > Ensure that the environment variable `SYSTEM_NAME` is set
    ```bash
    linux# cd /mnt/pitdata/prep/${SYSTEM_NAME}
    ```
2. Copy off the original `customizations.yaml` file
    ```bash
    linux# cp customizations.yaml customizations.yaml.pre-CASMINST-1403
    ```
3. Edit `customizations.yaml` to make the previously-described change.
4. Compare the edited `customizations.yaml` file with the original:
    ```bash
    linux# diff customizations.yaml customizations.yaml.pre-CASMINST-1403
    46a47,48
    >     - dst: 10.252.0.0/17
    >       gw: 10.252.0.1
    ```
