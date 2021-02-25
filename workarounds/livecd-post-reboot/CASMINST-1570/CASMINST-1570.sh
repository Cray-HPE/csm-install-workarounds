#!/usr/bin/env bash

TOKEN=$(curl -s -k -S -d grant_type=client_credentials -d client_id=admin-client -d client_secret=$(kubectl get secrets admin-client-auth -o jsonpath='{.data.client-secret}' | base64 -d) https://api-gw-service-nmn.local/keycloak/realms/shasta/protocol/openid-connect/token | jq -r '.access_token')
URL="https://api_gw_service.local/apis/sls/v1/networks"

function on_error() {
  echo "Error: $1.  Exiting"
  exit 1
}

# Collect network information from SLS
nmn_hmn_networks=$(curl -k -H "Authorization: Bearer ${TOKEN}" ${URL} 2>/dev/null | jq ".[] | {NetworkName: .Name, Subnets: .ExtraProperties.Subnets[]} | { NetworkName: .NetworkName, SubnetName: .Subnets.Name, SubnetCIDR: .Subnets.CIDR, Gateway: .Subnets.Gateway} | select(.SubnetName==\"network_hardware\") ")
[[ -n ${nmn_hmn_networks} ]] || on_error "Cannot retrieve HMN and NMN networks from SLS. Check SLS connectivity."
cabinet_networks=$(curl -k -H "Authorization: Bearer ${TOKEN}" ${URL} 2>/dev/null | jq ".[] | {NetworkName: .Name, Subnets: .ExtraProperties.Subnets[]} | { NetworkName: .NetworkName, SubnetName: .Subnets.Name, SubnetCIDR: .Subnets.CIDR} | select(.SubnetName | startswith(\"cabinet_\")) ")
[[ -n ${cabinet_networks} ]] || on_error "Cannot retrieve cabinet networks from SLS. Check SLS connectivity."

# NMN
gateway=$(echo "${nmn_hmn_networks}" | jq -r ". | select(.NetworkName==\"NMN\") | .Gateway")
[[ -n ${gateway} ]] || on_error "NMN gateway not found"
nmn_cabinet_subnets=$(echo "${cabinet_networks}" | jq -r ". | select(.NetworkName==\"NMN\" or .NetworkName==\"NMN_RVR\" or .NetworkName==\"NMN_MTN\") | .SubnetCIDR")
[[ -n ${nmn_cabinet_subnets} ]] || on_error "NMN cabinet subnets not found"

# HMN
gateway=$(echo "${nmn_hmn_networks}" | jq -r ". | select(.NetworkName==\"HMN\") | .Gateway")
[[ -n ${gateway} ]] || on_error "HMN gateway not found"
hmn_cabinet_subnets=$(echo "${cabinet_networks}" | jq -r ". | select(.NetworkName==\"HMN\" or .NetworkName==\"HMN_RVR\" or .NetworkName==\"HMN_MTN\") | .SubnetCIDR")
[[ -n ${hmn_cabinet_subnets} ]] || on_error "HMN cabinet subnets not found"

# Create the routing file first so we can fan it out to all the NCNs later.
local_route_file="./ifroute-bond0"
rm $local_route_file
touch $local_route_file
echo "$nmn_cabinet_subnets $gateway - bond0" >>$local_route_file
echo "$hmn_cabinet_subnets $gateway - bond0" >>$local_route_file

ncns=$(curl -s -k -H "Authorization: Bearer ${TOKEN}" "https://api-gw-service-nmn.local/apis/sls/v1/search/hardware?extra_properties.Role=Management" | jq -r '.[] | ."ExtraProperties" | ."Aliases" | .[]')

for ncn in $ncns; do
  echo "Adding routes to $ncn."

  ssh -o "StrictHostKeyChecking=no" "$ncn" ip route add "$nmn_cabinet_subnets" via "$gateway"
  ssh -o "StrictHostKeyChecking=no" "$ncn" ip route add "$hmn_cabinet_subnets" via "$gateway"
  scp $local_route_file "$ncn:/etc/sysconfig/network/ifroute-bond0"
done
