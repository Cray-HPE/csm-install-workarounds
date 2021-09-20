#!/bin/sh

set -euo pipefail

echo "Checking compatibility..."
if [[ $HOSTNAME =~ .*pit.* ]]; then
  echo "OK"
else
  echo "This workaround script should only be run on the PIT."
  exit 1
fi

data_json_orig_file=/var/www/ephemeral/configs/data.json
data_json_tmp_file=/tmp/data.tmp.json
data_json_modified_file=/tmp/data.modified.json
data_json_backup_file=/tmp/data.backup.json

cp $data_json_orig_file $data_json_modified_file
cp $data_json_orig_file $data_json_backup_file
have_changes=0

keys=$(jq 'keys' $data_json_modified_file | sed 's/"//g' | sed 's/,//' | grep '^ ')
for key in $keys; do
  this_host=$(jq -r ".[\"$key\"][\"user-data\"].local_hostname" $data_json_modified_file)
  current_runcmd=$(jq -r ".[\"$key\"][\"user-data\"].runcmd" $data_json_modified_file)
  if [[ "$this_host" == *"ncn-s0"* ]] ; then
     if echo "$current_runcmd" | grep -q cray-node-exporter; then
        echo "Already updated $key: $this_host"
	continue
     fi
     echo "Updating $key: $this_host"
     jq -r ".[\"$key\"][\"user-data\"].runcmd |= .+ ([\"zypper --no-gpg-checks in -y https://packages.local/repository/csm-sle-15sp2/cray-node-exporter-1.2.2.1-1.x86_64.rpm\"])" $data_json_modified_file > $data_json_tmp_file
     if [ "$?" -eq 0 ]; then
       mv $data_json_tmp_file $data_json_modified_file
       have_changes=1
     fi
  elif [[ "$this_host" == *"ncn-m0"* ]] ; then
     if echo "$current_runcmd" | grep -q kube-scheduler.yaml; then
        echo "Already updated $key: $this_host"
	continue
     fi
     echo "Updating $key: $this_host"
     jq -r ".[\"$key\"][\"user-data\"].runcmd |= .+ ([\"sed -i 's/--bind-address=127.0.0.1/--bind-address=0.0.0.0/' /etc/kubernetes/manifests/kube-controller-manager.yaml\", \"sed -i 's/--port=0/d' /etc/kubernetes/manifests/kube-scheduler.yaml\", \"sed -i 's/--bind-address=127.0.0.1/--bind-address=0.0.0.0/' /etc/kubernetes/manifests/kube-scheduler.yaml\"])" $data_json_modified_file > $data_json_tmp_file
     if [ "$?" -eq 0 ]; then
       have_changes=1
       mv $data_json_tmp_file $data_json_modified_file
     fi
  fi
done

if [ $have_changes -eq 1 ]; then
   echo "Copying new file into place ($data_json_orig_file)"
   mv $data_json_modified_file $data_json_orig_file
   echo "Restarting basecamp"
   systemctl restart basecamp
else
   echo "No changes necessary -- DONE"
fi
