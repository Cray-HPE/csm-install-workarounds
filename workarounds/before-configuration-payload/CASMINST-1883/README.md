# CASMINST-1883 Workaround
The `load-container-image.sh` script provided in CSM 0.8.22 and CSM 0.9.0 releases has known issues when loading Docker images into Podman. This WAR provides an updated script that will properly load images into Podman.

## Directions
1. Rename the `load-container-image.sh` script from the CSM release.
    > Ensure that the environment variable `CSM_RELEASE` is exported
    > ```
    > linux# export CSM_RELEASE=csm-x.y.z
    > ```

    ```bash
    linux# \
    mv ~/${CSM_RELEASE}/hack/load-container-image.sh ~/${CSM_RELEASE}/hack/load-container-image.sh.original
    mv /mnt/pitdata/${CSM_RELEASE}/hack/load-container-image.sh /mnt/pitdata/${CSM_RELEASE}/hack/load-container-image.sh.original
    ```

2. Copy the updated `load-container-image.sh` script into place:
    ```bash
    linux# \
    cd /opt/cray/csm/workarounds/before-configuration-payload/CASMINST-1883
    cp load-container-image.sh ~/${CSM_RELEASE}/hack/load-container-image.sh
    cp load-container-image.sh /mnt/pitdata/${CSM_RELEASE}/hack/load-container-image.sh
    ```
