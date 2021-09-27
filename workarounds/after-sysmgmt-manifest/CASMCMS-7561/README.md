# Fixing the cfs inventory generation image

This fix is only needed for fresh installs of 0.9.4 and 0.9.5.  Running these commands on other versions may break CFS.

Users will need to change the version of the cfs-operator image used during CFS sessions for inventory generation.  This is done by editing the cray-cfs-operator-config configmap and updating the image version from 1.10.20 to 1.10.22.  After this, the cfs-operator is restarted.  This can be done with the following commands:

```bash
kubectl -n services get cm cray-cfs-operator-config -o yaml | sed "s/1.10.20/1.10.22/g" | kubectl apply -f -
kubectl -n services rollout restart deployment cray-cfs-operator
```
