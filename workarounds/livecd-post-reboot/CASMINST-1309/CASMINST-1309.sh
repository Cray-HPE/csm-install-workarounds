#!/bin/bash

# Restart Kea so it doesn't just push the stale entry back in after we delete it.
kubectl -n services rollout restart deployment cray-dhcp-kea

ncns=$(curl -s -k -H "Authorization: Bearer ${TOKEN}" "https://api-gw-service-nmn.local/apis/sls/v1/search/hardware?extra_properties.Role=Management" | jq -r '.[] | ."ExtraProperties" | ."Aliases" | .[]')

# Just reset all the NCN BMCs
for ncn in $ncns; do
  if [ "$ncn" = "ncn-m001" ]; then
    continue
  fi
  echo "Sending cold reset to $ncn BMC..."
  ssh -o "StrictHostKeyChecking=no" "$ncn" ipmitool mc reset cold
done

bmcs=$(curl -s -k -H "Authorization: Bearer ${TOKEN}" https://api-gw-service-nmn.local/apis/sls/v1/search/hardware?extra_properties.Role=Management | jq -r '.[] | .Parent')

# Now delete all the BMC entries in EthernetInterfaces with an IP present.
for bmc in $bmcs; do
  bad_ips=$(cray hsm inventory ethernetInterfaces list --component-id $bmc --format json | jq -r '.[] | ."IPAddresses" | .[] | ."IPAddress"')
  for ip in $bad_ips; do
    id=$(cray hsm inventory ethernetInterfaces list --ip-address $ip --format=json | jq -r '.[] | ."ID"')
    echo "Deleting $id from EthernetInterfaces"...
    cray hsm inventory ethernetInterfaces delete $id
  done
done
