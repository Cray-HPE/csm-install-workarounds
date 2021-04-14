# CASMINST-1297 Workaround

Before the PIT is rebooted to become m001 up to three steps need to be taken.

1. Before the PIT is rebooted into m001, the KEA pod in the services namespace needs restarted (**note** these commands be ran on the PIT or m002):
    > This is to help prevent issues with m001 PXE booting

    Determine the KEA pod name:
    ```
    ncn-w001:~ # kubectl -n services get pods | grep kea
    cray-dhcp-kea-6fc795c9f9-pdrq8                                 3/3     Running     0          15h
    ```

    Delete the currently running pod:
    ```
    ncn-w001:~ # kubectl -n services delete pod cray-dhcp-kea-6fc795c9f9-pdrq8
    pod "cray-dhcp-kea-6fc795c9f9-pdrq8" deleted
    ```

    Before rebooting wait for the KEA pod to become healthy:
    ```
    ncn-m001:~ # kubectl -n services get pods | grep kea
    cray-dhcp-kea-6fc795c9f9-6pd86                                 3/3     Running       0          78s
    ```
