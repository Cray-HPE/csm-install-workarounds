# CASMINST-1915 WAR - Part 2
## Description
Verify changes (if any) made to `hmn_connections.json` and `application_node_config.json` have had the expected
results on the generated `sls_input_file.json`.

## Procedure
1. Verify the generated SLS file has the expected HMS SubRole for the application nodes in the system:
> Ensure that the environment variable `SYSTEM_NAME` is set.
```bash
pit# cat /mnt/pitdata/prep/${SYSTEM_NAME}/sls_input_file.json | jq -c '.Hardware[] | select(.ExtraProperties.Role == "Application") | { Xname: .Xname, Role: .ExtraProperties.Role, SubRole: .ExtraProperties.SubRole, Aliases: .ExtraProperties.Aliases }' 
```

The above command will output something like the following:
```json
{"Xname":"x3000c0s17b0n0","Role":"Application","SubRole":"UAN","Aliases":["uan01"]}
{"Xname":"x3000c0s18b0n0","Role":"Application","SubRole":"UAN","Aliases":["uan02"]}
{"Xname":"x3000c0s19b0n0","Role":"Application","SubRole":"UAN","Aliases":["uan03"]}
{"Xname":"x3000c0s21b0n0","Role":"Application","SubRole":"UAN","Aliases":["uan04"]}
{"Xname":"x3000c0s23b0n0","Role":"Application","SubRole":"UAN","Aliases":["uan05"]}
{"Xname":"x3000c0s25b0n0","Role":"Application","SubRole":"UAN","Aliases":["uan06"]}
{"Xname":"x3000c0s27b0n0","Role":"Application","SubRole":"LNETRouter","Aliases":["lnet01"]}
{"Xname":"x3000c0s28b0n0","Role":"Application","SubRole":"LNETRouter","Aliases":["lnet02"]}
{"Xname":"x3000c0s29b0n0","Role":"Application","SubRole":"UserDefined","Aliases":["slurm01"]}
```

> If you do not see an SubRole or aliases for an application node, additional configuration may be required in the 
> `application_node_config.yaml` file. See `308-APPLICATION-NODE-CONFIG`. After making needed adjustments to this file,
> you'll need to rerun `csi config init` with the required arguments. If you did not previously have an application 
> node config file it can be specified via the `--application-node-config-yaml` flag.