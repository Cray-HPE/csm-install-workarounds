## Start Goss Servers on the Non-Compute Nodes

Goss is used for automated validation tests used throughout installation.

Prior to running the Goss automated tests against the NCNs, the goss-servers service must be started on each NCN.
The best way to do this depends on which stage you are in during the installation.


## after-ncn-boot 

Run the following command **from ncn-m002**.   ncn-m002 will have the SSH keys installed for all masters, workers, and storage except for the PIT.

```bash
ncn-m002# for i in $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u | grep -v m001);do ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ${i} "systemctl start goss-servers";done 
```

Run this command to check the status.  Make sure they all return "running".

```bash
ncn-m002# for i in $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u | grep -v m001);do ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ${i} "systemctl status goss-servers | grep Active";done 
```


## livecd-post-reboot 

You can run the following command on m001 after it has been booted into its NCN image.

```bash
ncn-m001# pdsh -b -w $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u |  tr -t '\n' ',') 'systemctl start goss-servers' 
```

Run this command to check the status.  Make sure they all return "running".

```bash
ncn-m001# pdsh -b -w $(grep -oP 'ncn-\w\d+' /etc/hosts | sort -u |  tr -t '\n' ',') 'systemctl status goss-servers | grep Active'
```

