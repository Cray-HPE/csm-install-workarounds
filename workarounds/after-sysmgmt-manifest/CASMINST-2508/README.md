# WORKAROUND: Apply pod priorities for critical CSM services

At the conclusion of the CSM install, this workaround will create and apply a pod priority class
to services critical to CSM.  This will give these services a higher priority than others to
ensure they get scheduled by Kubernetes in the event that resources limited on smaller deployments.

1. Run the `CASMINST-2508.sh` script:
    ```bash
    ./CASMINST-2508.sh
    Creating csm-high-priority-service pod priority class
    priorityclass.scheduling.k8s.io/csm-high-priority-service configured

    Patching cray-postgres-operator deployment in services namespace
    deployment.apps/cray-postgres-operator patched

    Patching cray-postgres-operator-postgres-operator-ui deployment in services namespace
    deployment.apps/cray-postgres-operator-postgres-operator-ui patched

    Patching istio-operator deployment in istio-operator namespace
    deployment.apps/istio-operator patched

    Patching istio-ingressgateway deployment in istio-system namespace
    deployment.apps/istio-ingressgateway patched
    .
    .
    .
    ```
