#!/bin/bash

scriptdir=`dirname "$BASH_SOURCE"`

> ~/.ssh/known_hosts

# Distribute and run script to patch kube-system manifests to master nodes
masters=$(kubectl get node --selector='node-role.kubernetes.io/master' -o name | sed -e 's,^node/,,' | paste -sd,)
export PDSH_SSH_ARGS_APPEND="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
export IFS=","
for master in $masters; do
  ssh-keyscan -H "$master" 2> /dev/null >> ~/.ssh/known_hosts
  scp ${scriptdir}/patch-manifests.sh $master:/tmp
  pdsh -w $master "/tmp/patch-manifests.sh"
  # Give K8S a chance to spin up pods for this node
  sleep 10
done
unset IFS

# Ensuring cloud-init is healthy
cloud-init query -a > /dev/null 2>&1
rc=$?
if [[ "$rc" -ne 0 ]]; then
  # Attempt to repair cached data
  cloud-init init > /dev/null 2>&1
fi

# Distribute and configure node-exporter to storage nodes
num_storage_nodes=$(craysys metadata get num-storage-nodes)
for node_num in $(seq $num_storage_nodes); do
  storage_node=$(printf "ncn-s%03d" "$node_num")
  ssh-keyscan -H "$storage_node" 2> /dev/null >> ~/.ssh/known_hosts
  status=$(pdsh -N -w $storage_node "systemctl is-active node_exporter")
  if [ "$status" == "active" ]; then
    pdsh -w $storage_node "systemctl stop node_exporter; zypper rm -y golang-github-prometheus-node_exporter"
  fi
  pdsh -w $storage_node "zypper --no-gpg-checks in -y https://packages.local/repository/csm-sle-15sp2/x86_64/cray-node-exporter-1.2.2.1-1.x86_64.rpm"
done

function update_bss_masters() {
  masters=$(kubectl get node --selector='node-role.kubernetes.io/master' -o name | sed -e 's,^node/,,')
  for master in $masters; do
    xName=$(ssh -q -o StrictHostKeyChecking=no $master 'cat /etc/cray/xname')
    cray bss bootparameters list --name $xName --format=json | jq '.[]' > /tmp/$xName
    if ! grep -q kube-controller-manager /tmp/$xName; then
      jq -r ".[\"cloud-init\"][\"user-data\"].runcmd |= .+ ([\"sed -i 's/--bind-address=127.0.0.1/--bind-address=0.0.0.0/' /etc/kubernetes/manifests/kube-controller-manager.yaml\", \"sed -i 's/--port=0/d' /etc/kubernetes/manifests/kube-scheduler.yaml\", \"sed -i 's/--bind-address=127.0.0.1/--bind-address=0.0.0.0/' /etc/kubernetes/manifests/kube-scheduler.yaml\"])" /tmp/$xName > /tmp/$xName.modified
      echo "putting config"
      curl -i -s -k -H "Content-Type: application/json" -H "Authorization: Bearer ${TOKEN}" "https://api_gw_service.local/apis/bss/boot/v1/bootparameters" -X PUT -d @/tmp/$xName.modified
    fi
  done
}

function update_bss_storage() {
  num_storage_nodes=$(craysys metadata get num-storage-nodes)
  for node_num in $(seq $num_storage_nodes); do
    storage_node=$(printf "ncn-s%03d" "$node_num")
    xName=$(ssh -q -o StrictHostKeyChecking=no $storage_node 'cat /etc/cray/xname')
    cray bss bootparameters list --name $xName --format=json | jq '.[]' > /tmp/$xName
    if ! grep -q "cray-node-exporter-1.2.2.1-1.x86_64.rpm" /tmp/$xName; then
      jq -r 'del(.["cloud-init"]["user-data"].runcmd[] | select(. == "/srv/cray/scripts/common/storage-ceph-cloudinit.sh"))' /tmp/$xName > /tmp/$xName.modified
      jq -r '.["cloud-init"]["user-data"].runcmd |= .+ (["zypper --no-gpg-checks in -y https://packages.local/repository/csm-sle-15sp2/x86_64/cray-node-exporter-1.2.2.1-1.x86_64.rpm"])' /tmp/$xName.modified  > /tmp/$xName.modified.tmp
      mv /tmp/$xName.modified.tmp /tmp/$xName.modified
      echo "putting config"
      curl -i -s -k -H "Content-Type: application/json" -H "Authorization: Bearer ${TOKEN}" "https://api_gw_service.local/apis/bss/boot/v1/bootparameters" -X PUT -d @/tmp/$xName.modified
    fi
  done
}

TOKEN=`curl -k -s -S -d grant_type=client_credentials -d client_id=admin-client -d client_secret=\`kubectl get secrets admin-client-auth -o jsonpath='{.data.client-secret}' | base64 -d\` https://api-gw-service-nmn.local/keycloak/realms/shasta/protocol/openid-connect/token | jq -r '.access_token'`

update_bss_storage
update_bss_masters

echo "Done!"

