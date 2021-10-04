# Update basecamp metadata for master and storage nodes

> NOTE: This WAR should only be run on CSM 0.9.6 installs (or later).  Skip this if installing CSM 0.9.5 or prior.

Run the script `casminst-3104.sh` on the PIT prior to PXE booting nodes.

This script will update runcmd's for master and storage emulating functionality
in the CASMREL-755 hotfix, which will modify a couple kubernetes manifests
on boot, as well as install the node_exporter on storage nodes.

> NOTE: This WAR will restart basecamp.
