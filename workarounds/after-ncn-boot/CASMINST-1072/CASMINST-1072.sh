#! /bin/bash
# This is a workaround for CASMINST-1072.  It sets up a modified kdump initrd
set -euo pipefail

echo "Checking compatibility..."
if [[ $HOSTNAME =~ ^ncn-w.* ]]; then
  echo "OK"
else
  echo "This workaround script should only be run on k8s worker nodes."
  exit 1
fi

# Exclude mellanox drivers, which cause OOM errors
echo "Setting kdump kernel parameters..."
sed -i 's/^\(KDUMP_COMMANDLINE_APPEND\)=.*$/\1=\"irqpoll nr_cpus=1 selinux=0 reset_devices cgroup_disable=memory mce=off numa=off udev.children-max=2 acpi_no_memhotplug rd.neednet=1 rd.shell panic=10 nohpet nokaslr metal.debug=0 transparent_hugepage=never rd.driver.blacklist=mlx5_core,mlx5_ib\"/' /etc/sysconfig/kdump

# Restart to apply the change above
echo "Restarting kdump..."
systemctl restart kdump

echo "Making dirs for this script..."
mkdir -pv /tmp/ktmp
mkdir -pv /var/lib/kubelet/crash

echo "pushd..."
pushd /tmp/ktmp || exit 1
  echo "Unpacking initrd..."
  # Get the kernel version
  version_full=$(rpm -qa | grep kernel-default | grep -v devel | cut -f3- -d'-')
  version_base=${version_full%%-*}
  version_suse=${version_full##*-}
  version_suse=${version_suse%.*.*}
  version="$version_base-$version_suse-default"
  kdump_initrd_name="/boot/initrd-$version-kdump"

  # Unpack the existing kdump initrd
  /usr/lib/dracut/skipcpio ${kdump_initrd_name} | xzcat | cpio -id

  # Replace the ROOTDIR value here to skip the overlay and go straight to a disk
  # this is the local lib/ not /lib!
  echo "Modifying dump script to save to local disk..."
  sed -i '/^\ \ \ \ # save the dump.*/a \ \ \ \ ROOTDIR=/var/lib/kubelet/crash' ./lib/kdump/save_dump.sh

  # Remove the original and create the new kdump initrd with our modified script
  echo "Generating new kdump initrd..."
  rm -f ${kdump_initrd_name}
  find . | cpio -oac | xz -C crc32 -z -c > ${kdump_initrd_name}

echo "...popd"
popd || exit 1

# Restart to make sure our modified kdump initrd will be used
echo "Restarting kdump..."
systemctl restart kdump

echo "--------------"
echo "    Please install kernel-default-debuginfo-$version -- this is required for a full dump"
echo "--------------"
