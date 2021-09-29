# Add Unbound to `data.json`

Run the script `casminst-980.sh` on the PIT prior to PXE booting nodes.

This adds unbound DNS as the first DNS server to NCNs. This allows it to take precedence once it is online, and in the meantime allow Kubernetes and Ceph to deploy with LiveCD DNS and /etc/hosts.

> NOTE: This WAR will restart basecamp.

After doing this, the NCNs will handle DNS handoff themselves. Editing of `/etc/resolv.conf` should not be required.
