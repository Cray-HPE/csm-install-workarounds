#!/bin/bash

# Restart Kea so it does not just push the stale entry back in after we delete it.
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
  bad_ips=$(curl -s -k -H "Authorization: Bearer ${TOKEN}" "https://api-gw-service-nmn.local/apis/smd/hsm/v2/Inventory/EthernetInterfaces?ComponentID=$bmc" | jq -r '.[] | ."IPAddresses" | .[] | ."IPAddress"')
  for ip in $bad_ips; do
    id=$(curl -s -k -H "Authorization: Bearer ${TOKEN}" "https://api-gw-service-nmn.local/apis/smd/hsm/v2/Inventory/EthernetInterfaces?IPAddress=$ip" | jq -r '.[] | ."ID"')

    # Make sure ID is not blank.
    if [ -z "$id" ]
    then
      echo "$id blank when trying to find an owner for IP $ip!"
    else
      echo "Deleting $id from EthernetInterfaces"...
      curl -X DELETE -s -k -H "Authorization: Bearer ${TOKEN}" "https://api-gw-service-nmn.local/apis/smd/hsm/v2/Inventory/EthernetInterfaces/$id" | jq
    fi
  done
done
