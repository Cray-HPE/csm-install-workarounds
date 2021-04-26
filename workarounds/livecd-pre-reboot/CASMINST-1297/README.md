# CASMINST-1297 Workaround

Before the PIT is rebooted to become m001 two steps need to be taken.

1. **Before** running `csi handoff bss-metadata` as instructed in 007-CSM-INSTALL-REBOOT:
    * Take a copy of `data.json`:
        ```bash
        pit# cp /var/www/ephemeral/configs/data.json ./data-bss.json 
        ```
   * Edit that file and make the following change:
        * In the "Global" section update: 
           ```text
            "dns-server": "10.92.100.225 10.252.1.12",`
            ```
    
           To (only the IP of Unbound, remove others if they are there):
           ```text
            "dns-server": "10.92.100.225",
            ```
   * Ensure when you do the handoff step you give the path to this patched file and not the one in the configs directory.
2. Before the PIT is rebooted into m001, the KEA pod in the services namespace needs restarted (**note** run these commands on the PIT or m002):
    > This is to help prevent issues with m001 PXE booting

    Restart the KEA pod with zero downtime:
    ```
    ncn-m002:~ # kubectl -n services rollout restart deployment cray-dhcp-kea
    deployment.apps/cray-dhcp-kea restarted
    ```

    Before rebooting wait for a successful rollout of the KEA pod:
    ```
    ncn-m002:~ # kubectl -n services rollout status deployment cray-dhcp-kea
    Waiting for deployment "cray-dhcp-kea" rollout to finish: 1 old replicas are pending termination...
    Waiting for deployment "cray-dhcp-kea" rollout to finish: 1 old replicas are pending termination...
    deployment "cray-dhcp-kea" successfully rolled out
    ```

    Check that newly rolled out KEA pod is healthy:
    ```
    ncn-m002:~ # kubectl get pods -n services | grep kea
    cray-dhcp-kea-6dfc9856b8-5b6nz                                 3/3     Running     0          111s
    ```

