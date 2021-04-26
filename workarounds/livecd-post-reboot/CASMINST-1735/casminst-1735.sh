#!/bin/sh

pdsh -b -w $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u |  tr -t '\n' ',') 'cp -pv /srv/cray/resources/metal/sshd_config /etc/ssh/ && echo "TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem" >> /etc/ssh/sshd_config && systemctl --signal HUP restart sshd'
echo HANGUP was sent to sshd on all NCNs to reload the new sshd_config
echo This is the end of CASMINST-1735