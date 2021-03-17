#!/bin/sh

echo "Checking compatibility..."
if [[ $HOSTNAME =~ .*pit.* ]]; then
  echo "OK"
else
  echo "This workaround script should only be run on the PIT."
  exit 1
fi

grep disk-opts /var/www/boot/script.ipxe
sed -i 's/disk-opts /disk-opts metal.disk.conlib.size=40 metal.disk.k8slet.size=10 /g' /var/www/boot/script.ipxe
grep disk-opts /var/www/boot/script.ipxe
/root/bin/set-sqfs-links.sh
echo boot parameters adjusted for new containerd partition size
echo "Completed CASMINST-1747 metal.disk.conlib.size=40 metal.disk.k8slet.size=10"
