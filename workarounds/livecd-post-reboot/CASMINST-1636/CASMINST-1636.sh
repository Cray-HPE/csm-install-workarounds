#!/bin/bash
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    echo "usuage is "
    echo "CASMINST-1636.sh ncn-[m/w/s]-##"
fi

host=$1
#path="/etc/sysconfig/network"
path="./"
# list of vlans
vlan_id="vlan007 vlan004 vlan002"


for vlan in $vlan_id
do
    # match the vlan name
    case $vlan in
        vlan007)
            vlan_name="can"
            ;;
        vlan004)
            vlan_name="hmn"
            ;;
        vlan002)
            vlan_name="nmn"
            ;;
    esac
    ip_dns=$(dig +short "$host.$vlan_name")
    ip_ifcfg=$(cat $path/ifcfg-$vlan|grep IPADDR|cut -d '=' -f2|cut -d '/' -f1 |sed "s/['\"]//g")
    subnet_ifcfg=$(cat $path/ifcfg-$vlan|grep IPADDR|cut -d '=' -f2|cut -d '/' -f2 |sed "s/['\"]//g")
    echo "Information on:"
    echo "$vlan $vlan_name"
    echo "dns $ip_dns ifcfg $ip_ifcfg"
    if [[ "$ip_ifcfg" != "$ip_dns" ]]; then
        echo "$subnet_ifcfg needs an IP update"
        sed -i "/IPADDR/ d" "$path/ifcfg-$vlan"
        echo "IPADDR='$ip_dns/$subnet_ifcfg'" >> "$path/ifcfg-$vlan"
	        if [[ "$vlan" == 'nmn' ]]; then
		        echo "ifcfg-vlan002 was updated and needs to be restarted"
		        echo "restarting may disconnect your connection"
		        echo "wicked ifreload vlan002"
    	    else
	            echo "wicked ifreload $vlan"
	        fi
	else
	    echo "IP configured in ifcfg-$vlan matches dns"
    fi
done