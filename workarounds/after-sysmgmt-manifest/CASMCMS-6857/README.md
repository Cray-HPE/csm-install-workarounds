# Adding permissions to cray-cfs Kubernetes role

Users will need to add permission for the cray-cfs role in order for CFS (and more specifically, AEE) to read secrets out of the services namespace.

On a master or worker node with access to kubectl; modify
```kubectl get role cray-cfs -n services -o yaml
```

This is best done by adjusting cray-cfs role to include a more up-to-date set of permissions:
```
echo '''apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: cray-cfs
  namespace: services
rules:
- apiGroups: ["batch"]
  resources: ["jobs"]
  verbs: ["create", "delete", "get", "list", "patch", "update", "watch"]
- apiGroups: ["cms.cray.com"]
  resources: ["cfsessions"]
  verbs: ["create", "delete", "get", "list", "patch", "update", "watch"]
- apiGroups: [""]
  resources: ["services"]
  verbs: ["create", "delete", "get", "list"]
- apiGroups: [""]
  resources: ["configmaps", "secrets"]
  verbs: ["get"]
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["create", "delete", "get"]
- apiGroups: ["networking.istio.io"]
  resources: ["destinationrules"]
  verbs: ["create", "delete", "get"]
''' > /tmp/cray-cfs-roles.yaml && kubectl apply -f /tmp/cray-cfs-roles.yaml
```