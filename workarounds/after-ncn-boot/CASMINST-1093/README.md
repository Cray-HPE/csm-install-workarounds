## CASMINST-1093 cloud-init failure/race-condition
If the nodes exhibit afflictions such as:
- no hostname (or a hostname of `ncn`)
- `mgmt0` or `mgmt1` does not indicate they exist in `bond0`, or has a mismatching MTU of `1500` to the bond's members
- no route (`ip r` returns no `default` route)

### Procedure
1. First, restart the Basecamp service on the PIT
    ```bash
    pit# systemctl restart basecamp
    ```

  This step usually only needs to be done once even if more than one node is impacted.

2. Use conman to connect to the afflicted node's console, and execute the steps below from the node's console:
    ```bash
    pit# conman -j ncn-w001-mgmt
    ```

3. Apply fix to the retry-ci.sh script on the afflicted node.
    ```bash
    ncn# sed -i 's/set-dhcp-to-static\.done/set-dhcp-to-static\.sh/g' /srv/cray/scripts/metal/retry-ci.sh 
    ```    

4. Finally, run the following script from the afflicted node **(but only in one of the above circumstances)**.
    ```bash
    ncn# /srv/cray/scripts/metal/retry-ci.sh
    ```

5. Running `hostname` or logging out and back over ssh in should yield the proper hostname.
