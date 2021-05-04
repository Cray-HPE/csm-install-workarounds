# CASMINST-1264 Workaround

The NMN and UAI Macvlan subnets have overlapping subnets with the same VLanID

1. Go to the directory where CSI generated its configs. This shouid be `/mnt/pitdata/prep/${SYSTEM_NAME}`
    > Ensure that the environment variable `SYSTEM_NAME` is set
    ```bash
    linux# cd /mnt/pitdata/prep/${SYSTEM_NAME}
    ```
2. Copy off the original SLS file
    ```bash
    linux# cp sls_input_file.json sls_input_file.json.original
    ```
3. Reformat the SLS file so it is readable
    ```bash
    linux# cat sls_input_file.json.original | jq . > sls_input_file.json
    ```
4. Make another copy to use for comparison latter
    ```bash
    linux# cp sls_input_file.json sls_input_file.json.original.pretty
    ```
5. Edit `sls_input_file.json`, changing the NMN `uai_macvlan` subnet to use `VlanID` 20 instead of `VlanID` 2.
    This value can be found under `.Networks.NMN.ExtraProperties.Subnets[].VlanID`. 
    Make sure to edit the subnet with the name `uai_macvlan`
    Change the `VlanID` from 2 to 20 in the following block:
    ```json
            "Name": "uai_macvlan",
            "VlanID": 2,
            "Gateway": "10.252.0.1",
            "DHCPStart": "10.252.2.10",
            "DHCPEnd": "10.252.3.254"
        }
    ]
    ```
    After the change, it should look like:
    ```json
            "Name": "uai_macvlan",
            "VlanID": 20,
            "Gateway": "10.252.0.1",
            "DHCPStart": "10.252.2.10",
            "DHCPEnd": "10.252.3.254"
        }
    ]
    ```
6. Compare the edited `sls_input_file.json` file with the readable version of the original SLS file:
    ```bash
    linux# diff sls_input_file.json.original.pretty sls_input_file.json
    1401c1401
    <             "VlanID": 2,
    ---
    >             "VlanID": 20,
    ```
7. Finally, verify that `sls_input_file.json` is valid json:
    ```bash
    linux# cat sls_input_file.json | jq
    ```
