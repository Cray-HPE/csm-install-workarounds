#!/bin/sh
# NOTE: This assumes ens1 and ens2; if interfaces differ use those names
# sed -i 's/ens1/enp17/g' casminst-1725.sh
# sed -i 's/ens2/enp18/g' casminst-1725.sh

pdsh -b -w $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u |  tr -t '\n' ',') '
ip l s ens1 down
ip l s ens2 down
ip l s ens1 name hsn0
ip l s ens2 name hsn1
ip l s hsn0 up
ip l s hsn1 up
rules=/etc/udev/rules.d/*ifname.rules
mv $rules /etc/udev/rules.d/98-ifname.rules || echo already moved
'
echo Completed CASMINST-1725