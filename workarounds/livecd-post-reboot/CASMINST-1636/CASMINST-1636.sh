#!/bin/bash
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] || [[ -z "$1" ]]; then
    echo "usuage is "
    echo "CASMINST-1636.sh ncn-[m/w/s]-##"
    exit 0
fi

host=$1
path="/etc/sysconfig/network"

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
    # check to make sure required variables are not null
    if [[ -z "$ip_dns" ]] || [[ -z "$ip_ifcfg" ]] || [[ -z "$subnet_ifcfg" ]];then
        echo "**************************************************"
        echo "Missing data and cannot move forward with script"
        echo "ip_dns is $ip_dns"
        echo "ip_ifcfg is $ip_ifcfg"
        echo "subnet_ifcfg is $subnet_ifcfg"
        exit 1
    fi

    if [[ "$ip_ifcfg" != "$ip_dns" ]]; then
        echo "ifcfg-$vlan needs an IP update"
        sed -i "/IPADDR/ d" "$path/ifcfg-$vlan"
        echo "IPADDR='$ip_dns/$subnet_ifcfg'" >> "$path/ifcfg-$vlan"
	        if [[ "$vlan_name" == "nmn" ]]; then
		        echo "ifcfg-vlan002 was updated and needs to be restarted"
		        echo "restarting may disconnect your connection, run following command:"
		        echo "/usr/sbin/wicked ifreload vlan002"
	        fi
    	        if [[ "$vlan_name" != "nmn" ]];then
	            /usr/sbin/wicked ifreload $vlan
	        fi
	else
	    echo "IP configured in ifcfg-$vlan matches dns"
    fi
    echo ""
done