# CASMINST-1915 WAR - Part 1
## Description
There is a known issue with the CSI tool when generating configuration files for the system where it may not respect the user
provided prefix to HSM Subrole mappings defined in the systems `application_node_config.yaml` file.

One example of this problem are when LNetRouter Application Nodes getting accidentally treated as UAN Application Nodes.

## Prerequisites
This WAR requires the following
* The `hmn_connections.json` file for the system in the `/mnt/pitdata/prep/` directory.
* The `application_node_config.yaml` file for the system if there is one.

## Procedure
1. Identify problematic entries from hmn_connections.json. The following command will find the the `Source` fields 
that would treated as UAN Application Nodes that have the `ln` source prefix. If any of the reported nodes are not
expected to become application nodes, proceed with the WAR. Otherwise if all of the nodes found are expected to become
UAN application nodes (or nothing has been found) the rest of this WAR can be skipped.
  ```bash
  pit# cat /mnt/pitdata/prep/hmn_connections.json | jq -r '.[].Source' | grep -i '^ln'
  ```

  For example the following `lnet` nodes would be treated at UAN application nodes, which is not desired.
  ```bash
  pit# cat /mnt/pitdata/prep/hmn_connections.json | jq -r '.[].Source' | grep -i '^ln'
  lnet02
  lnet01
  ```

2. Next modify `hmn_connections.json`. For each node that is not expected become an UAN Application Node, add the `war-` prefix to the value in its `Source` field.

  For example, the following is for `lnet01`:  
  ```json
      {
          "Source": "lnet01",
          "SourceRack": "x3000",
          "SourceLocation": "u27",
          "DestinationRack": "x3000",
          "DestinationLocation": "u32",
          "DestinationPort": "j41"
      }
  ```
    
  Now modify the `hmn_connections.json` to use a different source prefix. The prefix `war-` is being added to create a unique source prefix, that will not overlap with the `ln` prefix.
  ```json
      {
          "Source": "war-lnet01",
          "SourceRack": "x3000",
          "SourceLocation": "u27",
          "DestinationRack": "x3000",
          "DestinationLocation": "u32",
          "DestinationPort": "j41"
      }
  ```

3. Now update the `application_node_config.yaml` file to include the new prefix, and prefix to HSM subrole mapping:
  > If you do not have an application node config for your system you will need to create one now. Follow the 
  > `308-APPLICATION-NODE-CONFIG` procedure in the CSM install docs on guidance on how to construct the file. 
  > If you did not previously have an application node config file it can be specified via the 
  > `--application-node-config-yaml` flag.

  For example, if the `application_node_config.yaml` looks like the following:    
  ```yaml
  prefixes:   # Additional application node prefixes
    - uan
    - lnet    # Prefix to be updated in our example
    - slurm

  prefix_hsm_subroles:  # HSM Subroles
    uan: UAN
    lnet: LNETRouter    # Prefix to HSM subrole mapping to be updated in our example
    slurm: UserDefined
  
  aliases:   # Application Node alias
    x3000c0s17b0n0: ["uan01"]
    x3000c0s18b0n0: ["uan02"]
    x3000c0s19b0n0: ["uan03"]
    x3000c0s21b0n0: ["uan04"]
    x3000c0s23b0n0: ["uan05"]
    x3000c0s25b0n0: ["uan06"]
    x3000c0s27b0n0: ["lnet01"]
    x3000c0s28b0n0: ["lnet02"]
    x3000c0s29b0n0: ["slurm01"]
  ```

  Make the following adjustments to the `prefixes` and `prefix_hsm_subroles` fields to make use of the new source prefix for the lnet nodes.
  ```yaml
  prefixes:      # Additional application node prefixes
      - uan
      - war-lnet # Updated prefix
      - slurm
 
  prefix_hsm_subroles:     # HSM Subroles
      uan: UAN
      war-lnet: LNETRouter # Updated prefix subrole mapping
      slurm: UserDefined
  
  aliases:  # Application Node alias
      x3000c0s17b0n0: ["uan01"]
      x3000c0s18b0n0: ["uan02"]
      x3000c0s19b0n0: ["uan03"]
      x3000c0s21b0n0: ["uan04"]
      x3000c0s23b0n0: ["uan05"]
      x3000c0s25b0n0: ["uan06"]
      x3000c0s27b0n0: ["lnet01"]
      x3000c0s28b0n0: ["lnet02"]
      x3000c0s29b0n0: ["slurm01"]
  ```
