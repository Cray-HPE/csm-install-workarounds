# Setting up kdump

This script should only be run on k8s worker nodes, which have `/var/lib/kubelet` on a physical disk.

This script will set up a modified kdump initrd.  You also need to install `kernel-default-debuginfo-.x86_64`, where the version matches exactly to your kernel version.
