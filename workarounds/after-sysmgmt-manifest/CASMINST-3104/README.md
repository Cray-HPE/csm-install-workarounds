# Update metadata for master and storage nodes

> NOTE: This WAR should only be run on CSM 0.9.6 installs (or later).  Skip this if installing CSM 0.9.5 or prior.

## Prerequisites

* The cray cli is used during the application of this hotfix, and therefore must be configured and operational.

This script will update runcmd's for master and storage emulating functionality
in the CASMREL-755 hotfix, which will modify a couple kubernetes manifests
on boot, as well as install the node_exporter on storage nodes.  The script will also
install the cray-node-exporter rpm on storage nodes, as well as reconfigure
manifests on master nodes.
