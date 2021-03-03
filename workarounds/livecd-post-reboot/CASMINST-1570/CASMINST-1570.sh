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
nmn_gateway=$(echo "${nmn_hmn_networks}" | jq -r ". | select(.NetworkName==\"NMN\") | .Gateway")
[[ -n ${nmn_gateway} ]] || on_error "NMN gateway not found"
nmn_cabinet_subnets=$(echo "${cabinet_networks}" | jq -r ". | select(.NetworkName==\"NMN\" or .NetworkName==\"NMN_RVR\" or .NetworkName==\"NMN_MTN\") | .SubnetCIDR")
[[ -n ${nmn_cabinet_subnets} ]] || on_error "NMN cabinet subnets not found"

# HMN
hmn_gateway=$(echo "${nmn_hmn_networks}" | jq -r ". | select(.NetworkName==\"HMN\") | .Gateway")
[[ -n ${hmn_gateway} ]] || on_error "HMN gateway not found"
hmn_cabinet_subnets=$(echo "${cabinet_networks}" | jq -r ". | select(.NetworkName==\"HMN\" or .NetworkName==\"HMN_RVR\" or .NetworkName==\"HMN_MTN\") | .SubnetCIDR")
[[ -n ${hmn_cabinet_subnets} ]] || on_error "HMN cabinet subnets not found"


# Create the routing files first so we can fan it out to all the NCNs later.
local_nmn_route_file="./ifroute-vlan002"
local_hmn_route_file="./ifroute-vlan004"
rm -f $local_nmn_route_file
rm -f $local_hmn_route_file
touch $local_nmn_route_file
touch $local_hmn_route_file

echo "Writing to $local_nmn_route_file"
for rt in $nmn_cabinet_subnets; do
  echo "$rt $nmn_gateway - vlan002" >>$local_nmn_route_file
done
echo "Writing to $local_hmn_route_file"
for rt in $hmn_cabinet_subnets; do
  echo "$rt $hmn_gateway - vlan004" >>$local_hmn_route_file
done

ncns=$(curl -s -k -H "Authorization: Bearer ${TOKEN}" "https://api-gw-service-nmn.local/apis/sls/v1/search/hardware?extra_properties.Role=Management" | jq -r '.[] | ."ExtraProperties" | ."Aliases" | .[]')

for ncn in $ncns; do
  echo "Adding routes to $ncn."

  # Create backup of ifroute files
  ssh -o "StrictHostKeyChecking=no" "$ncn" "if [ -e /etc/sysconfig/network/ifroute-vlan002 ]; then cp /etc/sysconfig/network/ifroute-vlan002 /etc/sysconfig/network/orig-route-vlan002;fi"
  ssh -o "StrictHostKeyChecking=no" "$ncn" "if [ -e /etc/sysconfig/network/ifroute-vlan004 ]; then cp /etc/sysconfig/network/ifroute-vlan004 /etc/sysconfig/network/orig-route-vlan004;fi"

  for rt in $nmn_cabinet_subnets; do
    ssh -o "StrictHostKeyChecking=no" "$ncn" ip route add "$rt" via "$nmn_gateway"
  done
  for rt in $hmn_cabinet_subnets; do
    ssh -o "StrictHostKeyChecking=no" "$ncn" ip route add "$rt" via "$hmn_gateway"
  done

  scp $local_nmn_route_file "$ncn:/etc/sysconfig/network/ifroute-vlan002"
  scp $local_hmn_route_file "$ncn:/etc/sysconfig/network/ifroute-vlan004"

  # Keep the 10.92.100 route if it is there
  ssh -o "StrictHostKeyChecking=no" "$ncn" "grep -s 10.92.100 /etc/sysconfig/network/orig-route-vlan002 >> /etc/sysconfig/network/ifroute-vlan002" 

done
