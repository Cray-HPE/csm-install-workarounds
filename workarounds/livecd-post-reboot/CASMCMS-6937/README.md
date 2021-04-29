# CASMCMS-6937 Workaround to fix broken Barebones Image recipe

This workaround fixes the Barebones Image recipe. This procedure can be carried out on any
master or worker node that has the workarounds installed in /opt/cray/csm/workarounds

Follow the directions in the System Administration Guide section 10.2 Upload and Register an Image Recipe.
Where a step in that procedure needs extra guidance, it is listed below. If the step does not need extra
guidance, it is not listed below. The entire procedure in 10.2 should be followed regardless of whether
the step is listed below or not.

* Step #1: The recipe name is 'cray-shasta-csm-sles15sp1-barebones.x86_64-shasta-1.4'.

* Step #3: After creating the image-recipe directory, save its full path in the IMAGE_RECIPE_DIR variable.
    ```bash
    ncn# export IMAGE_RECIPE_DIR=/root/image-recipe
    ```

* Step #4: Edit the following recipe files -- config.xml and images.sh

    You can do this using automatically using patch files provided in the workaround directory, or you can follow
    the manual procedure. Both are outlined at the end of this document.

* Step 6: You may name the file whatever you want. Suggested name for the ARTIFACT_FILE variable: 'cray-shasta-csm-sles15sp1-barebones.x86_64-shasta-1.4-fixed.tgz'

* Step 8: You may name the recipe whatever you want. Suggested argument for the --name parameter: 'cray-shasta-csm-sles15sp1-barebones.x86_64-shasta-1.4-fixed'

* Finish the remaining steps normally.

* If desired, you may now optionally remove the original IMS barebones recipe using the `cray ims recipes delete` CLI command.

## Automatic Patch Procedure

### Patch config.xml

```bash
ncn# patch ${IMAGE_RECIPE_DIR}/config.xml < /opt/cray/csm/workarounds/livecd-post-reboot/CASMCMS-6937/config.xml.patch
```

If your IMAGE_RECIPE_DIRECTORY was /root/image-recipe, then expected output is:
```
patching file /root/image-recipe/config.xml
```

### Patch images.sh

```bash
ncn# patch ${IMAGE_RECIPE_DIR}/images.sh < /opt/cray/csm/workarounds/livecd-post-reboot/CASMCMS-6937/images.sh.patch
```

If your IMAGE_RECIPE_DIRECTORY was /root/image-recipe, then expected output is:
```
patching file /root/image-recipe/images.sh
```

## Manual Edit Procedure

You will be manually editing config.xml and images.sh in $IMAGE_RECIPE_DIR

### Edit config.xml

1. Remove the following lines:

```
    <!--
    Repositories are added dynamically based on if the build is being done in the
    pipeline (CJE) or on the Shasta system (Shasta)
    -->

        <!-- SUSE SLE15sp1 packages, Nexus repo -->
        <repository type="rpm-md" alias="mirror-sle-15sp1-all-products" priority="4" imageinclude="true">
            <source path="https://packages.local/repository/mirror-sle-15sp1-all-products/"/>
        </repository>

        <!-- SUSE SLE15sp1 packages, Nexus repo -->
        <repository type="rpm-md" alias="mirror-sle-15sp1-all-updates" priority="4" imageinclude="true">
            <source path="https://packages.local/repository/mirror-sle-15sp1-all-updates/"/>
        </repository>

        <!-- Cray CSM SLES15sp1 CN, Nexus repo -->
        <repository type="rpm-md" alias="csm-sle-15sp1-compute" priority="3" imageinclude="true">
            <source path="https://packages.local/repository/csm-sle-15sp1-compute/"/>
        </repository>

        <!-- Cray COS SLES15sp1 CN, Nexus repo -->
        <repository type="rpm-md" alias="cos-1.4.0-sle-15sp1-compute" priority="3" imageinclude="true">
            <source path="https://packages.local/repository/cos-1.4-sle-15sp1-compute/"/>
        </repository>
```

Replace the removed lines with these lines:
```
    <!--
    Repositories are added dynamically based on if the build is being done in the
    pipeline (CJE) or on the Shasta system (Shasta)
    -->

        <!-- SUSE SLE15sp1 packages, Nexus repo -->
        <repository type="rpm-md" alias="SUSE-SLE-Module-Basesystem-15-SP1-x86_64-Pool" priority="4" imageinclude="true">
            <source path="https://packages.local/repository/SUSE-SLE-Module-Basesystem-15-SP1-x86_64-Pool/"/>
        </repository>

        <!-- SUSE SLE15sp1 packages, Nexus repo -->
        <repository type="rpm-md" alias="SUSE-SLE-Module-Basesystem-15-SP1-x86_64-Updates" priority="4" imageinclude="true">
            <source path="https://packages.local/repository/SUSE-SLE-Module-Basesystem-15-SP1-x86_64-Updates/"/>
        </repository>

        <!-- SUSE SLE15sp1 packages, Nexus repo -->
        <repository type="rpm-md" alias="SUSE-SLE-Product-SLES-15-SP1-x86_64-Pool" priority="4" imageinclude="true">
            <source path="https://packages.local/repository/SUSE-SLE-Product-SLES-15-SP1-x86_64-Pool/"/>
        </repository>

        <!-- SUSE SLE15sp1 packages, Nexus repo -->
        <repository type="rpm-md" alias="SUSE-SLE-Product-SLES-15-SP1-x86_64-Updates" priority="4" imageinclude="true">
            <source path="https://packages.local/repository/SUSE-SLE-Product-SLES-15-SP1-x86_64-Updates/"/>
        </repository>            
```

2. Find the following line:
```
    <packages type="image">
```

3. Searching downward from that line, remove the following lines when you find them:

```
        <package name="cray-squashfs-dracut"/>
        <package name="cray-system-files"/>
```

4. Remove these lines as well:
```
        <!-- dracut dependencies -->
        <package name="nfs-utils"/>
        <package name="rpcbind"/>
        <package name="cray-tokens-dracut"/>
    </packages>
    <packages type="iso">
        <package name="branding-SLE"/>
        <package name="dracut-kiwi-live"/>
    </packages>
    <packages type="oem">
        <package name="branding-SLE"/>
        <package name="dracut-kiwi-oem-repart"/>
        <package name="dracut-kiwi-oem-dump"/>
```

### Edit images.sh

Change this line:
```
 --add 'network nfs crayfs' \
```

To this:
 ```
 --add 'network' \
```
