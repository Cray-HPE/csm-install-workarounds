# CASMINST-2067

This relocates the `ifnames.rules` file to a new priority, while removing and
disabling cloud-init's own udev rules.

## Usage

Run `CASMINST-2067.sh` from any directory on ncn-m001, or any NCN with
passwordless SSH configured.

Expected output looks similar to the following
```
Purging cloud-int udev
Moving ifnames into place
ncn-s003: total 49
ncn-s003: -rw-r--r-- 1 root root  142 Feb 17 16:44 11-dm.rules
ncn-s003: -rw-r--r-- 1 root root  680 Mar  8 00:14 59-persistent-storage-dm.rules
ncn-s003: -rw-r--r-- 1 root root  853 Mar  8 00:14 59-persistent-storage-md.rules
ncn-s003: -rw-r--r-- 1 root root  297 Mar  8 00:14 59-persistent-storage.rules
ncn-s003: -rw-r--r-- 1 root root 1030 Mar  8 00:14 61-persistent-storage.rules
ncn-s003: -rw-r--r-- 1 root root  775 Feb 17 16:44 64-lvm.rules
ncn-s003: -rw-r--r-- 1 root root 1475 Feb 17 16:44 65-md-incremental-imsm.rules
ncn-s003: -rw-r--r-- 1 root root  267 Apr 27 19:34 70-luks.rules
ncn-s003: -rw-r--r-- 1 root root  628 Sep  8  2020 70-persistent-ipoib.rules
ncn-s003: -rw-r--r-- 1 root root  443 Mar  3 20:10 70-persistent-net.rules
ncn-s003: -rw-r--r-- 1 root root  557 Sep 14  2020 82-net-setup-link.rules
ncn-s003: -rw-r--r-- 1 root root 1062 Sep 14  2020 90-ib.rules
ncn-s003: -rw-r--r-- 1 root root 1911 Apr 27 19:34 90-net.rules
ncn-s003: -rw-r--r-- 1 root root  228 Apr 27 19:34 98-ifname.rules
ncn-s003: -rw-r--r-- 1 root root  279 Apr 27 19:34 99-live-squash.rules
ncn-s003: -rw-r--r-- 1 root root  174 Dec 10 21:52 99-lustre.rules
ncn-s001: total 49
ncn-s001: -rw-r--r-- 1 root root  142 Feb 17 16:44 11-dm.rules
ncn-s001: -rw-r--r-- 1 root root  680 Mar  8 00:14 59-persistent-storage-dm.rules
ncn-s002: total 49
ncn-s001: -rw-r--r-- 1 root root  853 Mar  8 00:14 59-persistent-storage-md.rules
ncn-s001: -rw-r--r-- 1 root root  297 Mar  8 00:14 59-persistent-storage.rules
ncn-s002: -rw-r--r-- 1 root root  142 Feb 17 16:44 11-dm.rules
ncn-s001: -rw-r--r-- 1 root root 1030 Mar  8 00:14 61-persistent-storage.rules
ncn-s001: -rw-r--r-- 1 root root  775 Feb 17 16:44 64-lvm.rules
ncn-s001: -rw-r--r-- 1 root root 1475 Feb 17 16:44 65-md-incremental-imsm.rules
ncn-s001: -rw-r--r-- 1 root root  267 Apr 27 19:34 70-luks.rules
ncn-s001: -rw-r--r-- 1 root root  628 Sep  8  2020 70-persistent-ipoib.rules
ncn-s001: -rw-r--r-- 1 root root  443 Mar  3 20:10 70-persistent-net.rules
ncn-s001: -rw-r--r-- 1 root root  557 Sep 14  2020 82-net-setup-link.rules
ncn-s001: -rw-r--r-- 1 root root 1062 Sep 14  2020 90-ib.rules
ncn-s001: -rw-r--r-- 1 root root 1911 Apr 27 19:34 90-net.rules
ncn-s001: -rw-r--r-- 1 root root  228 Apr 27 19:34 98-ifname.rules
ncn-s001: -rw-r--r-- 1 root root  279 Apr 27 19:34 99-live-squash.rules
ncn-s002: -rw-r--r-- 1 root root  680 Mar  8 00:14 59-persistent-storage-dm.rules
ncn-s001: -rw-r--r-- 1 root root  174 Dec 10 21:52 99-lustre.rules
ncn-s002: -rw-r--r-- 1 root root  853 Mar  8 00:14 59-persistent-storage-md.rules
ncn-s002: -rw-r--r-- 1 root root  297 Mar  8 00:14 59-persistent-storage.rules
ncn-s002: -rw-r--r-- 1 root root 1030 Mar  8 00:14 61-persistent-storage.rules
ncn-s002: -rw-r--r-- 1 root root  775 Feb 17 16:44 64-lvm.rules
ncn-s002: -rw-r--r-- 1 root root 1475 Feb 17 16:44 65-md-incremental-imsm.rules
ncn-s002: -rw-r--r-- 1 root root  267 Apr 27 19:34 70-luks.rules
ncn-s002: -rw-r--r-- 1 root root  628 Sep  8  2020 70-persistent-ipoib.rules
ncn-s002: -rw-r--r-- 1 root root  443 Mar  3 20:10 70-persistent-net.rules
ncn-s002: -rw-r--r-- 1 root root  557 Sep 14  2020 82-net-setup-link.rules
ncn-s002: -rw-r--r-- 1 root root 1062 Sep 14  2020 90-ib.rules
ncn-s002: -rw-r--r-- 1 root root 1911 Apr 27 19:34 90-net.rules
ncn-s002: -rw-r--r-- 1 root root  228 Apr 27 19:34 98-ifname.rules
ncn-s002: -rw-r--r-- 1 root root  279 Apr 27 19:34 99-live-squash.rules
ncn-s002: -rw-r--r-- 1 root root  174 Dec 10 21:52 99-lustre.rules
ncn-s003: total 49
ncn-s003: -rw-r--r-- 1 root root  142 Feb 17 16:44 11-dm.rules
ncn-s003: -rw-r--r-- 1 root root  680 Mar  8 00:14 59-persistent-storage-dm.rules
ncn-s003: -rw-r--r-- 1 root root  853 Mar  8 00:14 59-persistent-storage-md.rules
ncn-s003: -rw-r--r-- 1 root root  297 Mar  8 00:14 59-persistent-storage.rules
ncn-s003: -rw-r--r-- 1 root root 1030 Mar  8 00:14 61-persistent-storage.rules
ncn-s003: -rw-r--r-- 1 root root  775 Feb 17 16:44 64-lvm.rules
ncn-s003: -rw-r--r-- 1 root root 1475 Feb 17 16:44 65-md-incremental-imsm.rules
ncn-s003: -rw-r--r-- 1 root root  267 Apr 27 19:34 70-luks.rules
ncn-s003: -rw-r--r-- 1 root root  628 Sep  8  2020 70-persistent-ipoib.rules
ncn-s003: -rw-r--r-- 1 root root  443 Mar  3 20:10 70-persistent-net.rules
ncn-s003: -rw-r--r-- 1 root root  557 Sep 14  2020 82-net-setup-link.rules
ncn-s003: -rw-r--r-- 1 root root  228 Apr 27 19:34 84-ifname.rules
ncn-s003: -rw-r--r-- 1 root root 1062 Sep 14  2020 90-ib.rules
ncn-s003: -rw-r--r-- 1 root root 1911 Apr 27 19:34 90-net.rules
ncn-s003: -rw-r--r-- 1 root root  279 Apr 27 19:34 99-live-squash.rules
ncn-s003: -rw-r--r-- 1 root root  174 Dec 10 21:52 99-lustre.rules
ncn-s001: total 49
ncn-s001: -rw-r--r-- 1 root root  142 Feb 17 16:44 11-dm.rules
ncn-s001: -rw-r--r-- 1 root root  680 Mar  8 00:14 59-persistent-storage-dm.rules
ncn-s001: -rw-r--r-- 1 root root  853 Mar  8 00:14 59-persistent-storage-md.rules
ncn-s001: -rw-r--r-- 1 root root  297 Mar  8 00:14 59-persistent-storage.rules
ncn-s001: -rw-r--r-- 1 root root 1030 Mar  8 00:14 61-persistent-storage.rules
ncn-s001: -rw-r--r-- 1 root root  775 Feb 17 16:44 64-lvm.rules
ncn-s001: -rw-r--r-- 1 root root 1475 Feb 17 16:44 65-md-incremental-imsm.rules
ncn-s001: -rw-r--r-- 1 root root  267 Apr 27 19:34 70-luks.rules
ncn-s001: -rw-r--r-- 1 root root  628 Sep  8  2020 70-persistent-ipoib.rules
ncn-s001: -rw-r--r-- 1 root root  443 Mar  3 20:10 70-persistent-net.rules
ncn-s001: -rw-r--r-- 1 root root  557 Sep 14  2020 82-net-setup-link.rules
ncn-s001: -rw-r--r-- 1 root root  228 Apr 27 19:34 84-ifname.rules
ncn-s001: -rw-r--r-- 1 root root 1062 Sep 14  2020 90-ib.rules
ncn-s001: -rw-r--r-- 1 root root 1911 Apr 27 19:34 90-net.rules
ncn-s001: -rw-r--r-- 1 root root  279 Apr 27 19:34 99-live-squash.rules
ncn-s001: -rw-r--r-- 1 root root  174 Dec 10 21:52 99-lustre.rules
ncn-s002: total 49
ncn-s002: -rw-r--r-- 1 root root  142 Feb 17 16:44 11-dm.rules
ncn-s002: -rw-r--r-- 1 root root  680 Mar  8 00:14 59-persistent-storage-dm.rules
ncn-s002: -rw-r--r-- 1 root root  853 Mar  8 00:14 59-persistent-storage-md.rules
ncn-s002: -rw-r--r-- 1 root root  297 Mar  8 00:14 59-persistent-storage.rules
ncn-s002: -rw-r--r-- 1 root root 1030 Mar  8 00:14 61-persistent-storage.rules
ncn-s002: -rw-r--r-- 1 root root  775 Feb 17 16:44 64-lvm.rules
ncn-s002: -rw-r--r-- 1 root root 1475 Feb 17 16:44 65-md-incremental-imsm.rules
ncn-s002: -rw-r--r-- 1 root root  267 Apr 27 19:34 70-luks.rules
ncn-s002: -rw-r--r-- 1 root root  628 Sep  8  2020 70-persistent-ipoib.rules
ncn-s002: -rw-r--r-- 1 root root  443 Mar  3 20:10 70-persistent-net.rules
ncn-s002: -rw-r--r-- 1 root root  557 Sep 14  2020 82-net-setup-link.rules
ncn-s002: -rw-r--r-- 1 root root  228 Apr 27 19:34 84-ifname.rules
ncn-s002: -rw-r--r-- 1 root root 1062 Sep 14  2020 90-ib.rules
ncn-s002: -rw-r--r-- 1 root root 1911 Apr 27 19:34 90-net.rules
ncn-s002: -rw-r--r-- 1 root root  279 Apr 27 19:34 99-live-squash.rules
ncn-s002: -rw-r--r-- 1 root root  174 Dec 10 21:52 99-lustre.rules
ncn-m001: total 49
ncn-m001: -rw-r--r-- 1 root root  142 Feb 17 16:44 11-dm.rules
ncn-m001: -rw-r--r-- 1 root root  680 Mar  8 00:18 59-persistent-storage-dm.rules
ncn-m001: -rw-r--r-- 1 root root  853 Mar  8 00:18 59-persistent-storage-md.rules
ncn-m001: -rw-r--r-- 1 root root  297 Mar  8 00:18 59-persistent-storage.rules
ncn-m001: -rw-r--r-- 1 root root 1030 Mar  8 00:18 61-persistent-storage.rules
ncn-m001: -rw-r--r-- 1 root root  775 Feb 17 16:44 64-lvm.rules
ncn-m001: -rw-r--r-- 1 root root 1475 Feb 17 16:44 65-md-incremental-imsm.rules
ncn-m001: -rw-r--r-- 1 root root  267 Apr 27 22:39 70-luks.rules
ncn-m001: -rw-r--r-- 1 root root  628 Sep  8  2020 70-persistent-ipoib.rules
ncn-m001: -rw-r--r-- 1 root root  443 Mar  3 20:10 70-persistent-net.rules
ncn-m001: -rw-r--r-- 1 root root  557 Sep 14  2020 82-net-setup-link.rules
ncn-m001: -rw-r--r-- 1 root root 1062 Sep 14  2020 90-ib.rules
ncn-m001: -rw-r--r-- 1 root root 1911 Apr 27 22:39 90-net.rules
ncn-m001: -rw-r--r-- 1 root root  228 Apr 27 22:39 98-ifname.rules
ncn-m001: -rw-r--r-- 1 root root  279 Apr 27 22:39 99-live-squash.rules
ncn-m001: -rw-r--r-- 1 root root  174 Dec 10 21:52 99-lustre.rules
ncn-m002: total 49
ncn-m002: -rw-r--r-- 1 root root  142 Feb 17 16:44 11-dm.rules
ncn-m002: -rw-r--r-- 1 root root  680 Mar  8 00:18 59-persistent-storage-dm.rules
ncn-m002: -rw-r--r-- 1 root root  853 Mar  8 00:18 59-persistent-storage-md.rules
ncn-m002: -rw-r--r-- 1 root root  297 Mar  8 00:18 59-persistent-storage.rules
ncn-m002: -rw-r--r-- 1 root root 1030 Mar  8 00:18 61-persistent-storage.rules
ncn-m002: -rw-r--r-- 1 root root  775 Feb 17 16:44 64-lvm.rules
ncn-m002: -rw-r--r-- 1 root root 1475 Feb 17 16:44 65-md-incremental-imsm.rules
ncn-m002: -rw-r--r-- 1 root root  267 Apr 27 19:39 70-luks.rules
ncn-m002: -rw-r--r-- 1 root root  628 Sep  8  2020 70-persistent-ipoib.rules
ncn-m002: -rw-r--r-- 1 root root  443 Mar  3 20:10 70-persistent-net.rules
ncn-m002: -rw-r--r-- 1 root root  557 Sep 14  2020 82-net-setup-link.rules
ncn-m002: -rw-r--r-- 1 root root 1062 Sep 14  2020 90-ib.rules
ncn-m002: -rw-r--r-- 1 root root 1911 Apr 27 19:39 90-net.rules
ncn-m001: total 49
ncn-m002: -rw-r--r-- 1 root root  228 Apr 27 19:39 98-ifname.rules
ncn-m001: -rw-r--r-- 1 root root  142 Feb 17 16:44 11-dm.rules
ncn-m002: -rw-r--r-- 1 root root  279 Apr 27 19:39 99-live-squash.rules
ncn-m001: -rw-r--r-- 1 root root  680 Mar  8 00:18 59-persistent-storage-dm.rules
ncn-m002: -rw-r--r-- 1 root root  174 Dec 10 21:52 99-lustre.rules
ncn-m001: -rw-r--r-- 1 root root  853 Mar  8 00:18 59-persistent-storage-md.rules
ncn-m001: -rw-r--r-- 1 root root  297 Mar  8 00:18 59-persistent-storage.rules
ncn-m001: -rw-r--r-- 1 root root 1030 Mar  8 00:18 61-persistent-storage.rules
ncn-m001: -rw-r--r-- 1 root root  775 Feb 17 16:44 64-lvm.rules
ncn-m001: -rw-r--r-- 1 root root 1475 Feb 17 16:44 65-md-incremental-imsm.rules
ncn-m001: -rw-r--r-- 1 root root  267 Apr 27 22:39 70-luks.rules
ncn-m001: -rw-r--r-- 1 root root  628 Sep  8  2020 70-persistent-ipoib.rules
ncn-m001: -rw-r--r-- 1 root root  443 Mar  3 20:10 70-persistent-net.rules
ncn-m001: -rw-r--r-- 1 root root  557 Sep 14  2020 82-net-setup-link.rules
ncn-m001: -rw-r--r-- 1 root root  228 Apr 27 22:39 84-ifname.rules
ncn-m001: -rw-r--r-- 1 root root 1062 Sep 14  2020 90-ib.rules
ncn-m001: -rw-r--r-- 1 root root 1911 Apr 27 22:39 90-net.rules
ncn-m001: -rw-r--r-- 1 root root  279 Apr 27 22:39 99-live-squash.rules
ncn-m001: -rw-r--r-- 1 root root  174 Dec 10 21:52 99-lustre.rules
ncn-m002: total 49
ncn-m002: -rw-r--r-- 1 root root  142 Feb 17 16:44 11-dm.rules
ncn-m002: -rw-r--r-- 1 root root  680 Mar  8 00:18 59-persistent-storage-dm.rules
ncn-m002: -rw-r--r-- 1 root root  853 Mar  8 00:18 59-persistent-storage-md.rules
ncn-m002: -rw-r--r-- 1 root root  297 Mar  8 00:18 59-persistent-storage.rules
ncn-m002: -rw-r--r-- 1 root root 1030 Mar  8 00:18 61-persistent-storage.rules
ncn-m002: -rw-r--r-- 1 root root  775 Feb 17 16:44 64-lvm.rules
ncn-m002: -rw-r--r-- 1 root root 1475 Feb 17 16:44 65-md-incremental-imsm.rules
ncn-m002: -rw-r--r-- 1 root root  267 Apr 27 19:39 70-luks.rules
ncn-m002: -rw-r--r-- 1 root root  628 Sep  8  2020 70-persistent-ipoib.rules
ncn-m002: -rw-r--r-- 1 root root  443 Mar  3 20:10 70-persistent-net.rules
ncn-m002: -rw-r--r-- 1 root root  557 Sep 14  2020 82-net-setup-link.rules
ncn-m002: -rw-r--r-- 1 root root  228 Apr 27 19:39 84-ifname.rules
ncn-m002: -rw-r--r-- 1 root root 1062 Sep 14  2020 90-ib.rules
ncn-m002: -rw-r--r-- 1 root root 1911 Apr 27 19:39 90-net.rules
ncn-m002: -rw-r--r-- 1 root root  279 Apr 27 19:39 99-live-squash.rules
ncn-m002: -rw-r--r-- 1 root root  174 Dec 10 21:52 99-lustre.rules
ncn-w003: total 49
ncn-w003: -rw-r--r-- 1 root root  142 Feb 17 16:44 11-dm.rules
ncn-w003: -rw-r--r-- 1 root root  680 Mar  8 00:18 59-persistent-storage-dm.rules
ncn-w003: -rw-r--r-- 1 root root  853 Mar  8 00:18 59-persistent-storage-md.rules
ncn-w003: -rw-r--r-- 1 root root  297 Mar  8 00:18 59-persistent-storage.rules
ncn-w003: -rw-r--r-- 1 root root 1030 Mar  8 00:18 61-persistent-storage.rules
ncn-w003: -rw-r--r-- 1 root root  775 Feb 17 16:44 64-lvm.rules
ncn-w003: -rw-r--r-- 1 root root 1475 Feb 17 16:44 65-md-incremental-imsm.rules
ncn-w003: -rw-r--r-- 1 root root  267 Apr 27 19:40 70-luks.rules
ncn-w003: -rw-r--r-- 1 root root  628 Sep  8  2020 70-persistent-ipoib.rules
ncn-w003: -rw-r--r-- 1 root root  443 Mar  3 20:10 70-persistent-net.rules
ncn-w003: -rw-r--r-- 1 root root  557 Sep 14  2020 82-net-setup-link.rules
ncn-w003: -rw-r--r-- 1 root root 1062 Sep 14  2020 90-ib.rules
ncn-w003: -rw-r--r-- 1 root root 2135 Apr 27 19:40 90-net.rules
ncn-w003: -rw-r--r-- 1 root root  341 Apr 27 19:40 98-ifname.rules
ncn-w003: -rw-r--r-- 1 root root  279 Apr 27 19:40 99-live-squash.rules
ncn-w003: -rw-r--r-- 1 root root  174 Dec 10 21:52 99-lustre.rules
ncn-m003: total 49
ncn-m003: -rw-r--r-- 1 root root  142 Feb 17 16:44 11-dm.rules
ncn-m003: -rw-r--r-- 1 root root  680 Mar  8 00:18 59-persistent-storage-dm.rules
ncn-m003: -rw-r--r-- 1 root root  853 Mar  8 00:18 59-persistent-storage-md.rules
ncn-m003: -rw-r--r-- 1 root root  297 Mar  8 00:18 59-persistent-storage.rules
ncn-m003: -rw-r--r-- 1 root root 1030 Mar  8 00:18 61-persistent-storage.rules
ncn-m003: -rw-r--r-- 1 root root  775 Feb 17 16:44 64-lvm.rules
ncn-m003: -rw-r--r-- 1 root root 1475 Feb 17 16:44 65-md-incremental-imsm.rules
ncn-m003: -rw-r--r-- 1 root root  267 Apr 27 19:39 70-luks.rules
ncn-m003: -rw-r--r-- 1 root root  628 Sep  8  2020 70-persistent-ipoib.rules
ncn-m003: -rw-r--r-- 1 root root  443 Mar  3 20:10 70-persistent-net.rules
ncn-m003: -rw-r--r-- 1 root root  557 Sep 14  2020 82-net-setup-link.rules
ncn-m003: -rw-r--r-- 1 root root 1062 Sep 14  2020 90-ib.rules
ncn-m003: -rw-r--r-- 1 root root 1911 Apr 27 19:39 90-net.rules
ncn-m003: -rw-r--r-- 1 root root  228 Apr 27 19:39 98-ifname.rules
ncn-m003: -rw-r--r-- 1 root root  279 Apr 27 19:39 99-live-squash.rules
ncn-m003: -rw-r--r-- 1 root root  174 Dec 10 21:52 99-lustre.rules
ncn-w001: total 49
ncn-w001: -rw-r--r-- 1 root root  142 Feb 17 16:44 11-dm.rules
ncn-w001: -rw-r--r-- 1 root root  680 Mar  8 00:18 59-persistent-storage-dm.rules
ncn-w003: total 49
ncn-w001: -rw-r--r-- 1 root root  853 Mar  8 00:18 59-persistent-storage-md.rules
ncn-w001: -rw-r--r-- 1 root root  297 Mar  8 00:18 59-persistent-storage.rules
ncn-w003: -rw-r--r-- 1 root root  142 Feb 17 16:44 11-dm.rules
ncn-w001: -rw-r--r-- 1 root root 1030 Mar  8 00:18 61-persistent-storage.rules
ncn-w001: -rw-r--r-- 1 root root  775 Feb 17 16:44 64-lvm.rules
ncn-w001: -rw-r--r-- 1 root root 1475 Feb 17 16:44 65-md-incremental-imsm.rules
ncn-w001: -rw-r--r-- 1 root root  267 Apr 27 19:40 70-luks.rules
ncn-w001: -rw-r--r-- 1 root root  628 Sep  8  2020 70-persistent-ipoib.rules
ncn-w001: -rw-r--r-- 1 root root  443 Mar  3 20:10 70-persistent-net.rules
ncn-w001: -rw-r--r-- 1 root root  557 Sep 14  2020 82-net-setup-link.rules
ncn-w001: -rw-r--r-- 1 root root 1062 Sep 14  2020 90-ib.rules
ncn-w001: -rw-r--r-- 1 root root 2135 Apr 27 19:40 90-net.rules
ncn-w001: -rw-r--r-- 1 root root  341 Apr 27 19:40 98-ifname.rules
ncn-w003: -rw-r--r-- 1 root root  680 Mar  8 00:18 59-persistent-storage-dm.rules
ncn-w003: -rw-r--r-- 1 root root  853 Mar  8 00:18 59-persistent-storage-md.rules
ncn-w003: -rw-r--r-- 1 root root  297 Mar  8 00:18 59-persistent-storage.rules
ncn-w003: -rw-r--r-- 1 root root 1030 Mar  8 00:18 61-persistent-storage.rules
ncn-w003: -rw-r--r-- 1 root root  775 Feb 17 16:44 64-lvm.rules
ncn-w003: -rw-r--r-- 1 root root 1475 Feb 17 16:44 65-md-incremental-imsm.rules
ncn-w003: -rw-r--r-- 1 root root  267 Apr 27 19:40 70-luks.rules
ncn-w001: -rw-r--r-- 1 root root  279 Apr 27 19:40 99-live-squash.rules
ncn-w001: -rw-r--r-- 1 root root  174 Dec 10 21:52 99-lustre.rules
ncn-w003: -rw-r--r-- 1 root root  628 Sep  8  2020 70-persistent-ipoib.rules
ncn-w003: -rw-r--r-- 1 root root  443 Mar  3 20:10 70-persistent-net.rules
ncn-w003: -rw-r--r-- 1 root root  557 Sep 14  2020 82-net-setup-link.rules
ncn-w003: -rw-r--r-- 1 root root  341 Apr 27 19:40 84-ifname.rules
ncn-w003: -rw-r--r-- 1 root root 1062 Sep 14  2020 90-ib.rules
ncn-w003: -rw-r--r-- 1 root root 2135 Apr 27 19:40 90-net.rules
ncn-w003: -rw-r--r-- 1 root root  279 Apr 27 19:40 99-live-squash.rules
ncn-w003: -rw-r--r-- 1 root root  174 Dec 10 21:52 99-lustre.rules
ncn-m003: total 49
ncn-m003: -rw-r--r-- 1 root root  142 Feb 17 16:44 11-dm.rules
ncn-m003: -rw-r--r-- 1 root root  680 Mar  8 00:18 59-persistent-storage-dm.rules
ncn-m003: -rw-r--r-- 1 root root  853 Mar  8 00:18 59-persistent-storage-md.rules
ncn-m003: -rw-r--r-- 1 root root  297 Mar  8 00:18 59-persistent-storage.rules
ncn-m003: -rw-r--r-- 1 root root 1030 Mar  8 00:18 61-persistent-storage.rules
ncn-m003: -rw-r--r-- 1 root root  775 Feb 17 16:44 64-lvm.rules
ncn-m003: -rw-r--r-- 1 root root 1475 Feb 17 16:44 65-md-incremental-imsm.rules
ncn-m003: -rw-r--r-- 1 root root  267 Apr 27 19:39 70-luks.rules
ncn-m003: -rw-r--r-- 1 root root  628 Sep  8  2020 70-persistent-ipoib.rules
ncn-m003: -rw-r--r-- 1 root root  443 Mar  3 20:10 70-persistent-net.rules
ncn-m003: -rw-r--r-- 1 root root  557 Sep 14  2020 82-net-setup-link.rules
ncn-m003: -rw-r--r-- 1 root root  228 Apr 27 19:39 84-ifname.rules
ncn-m003: -rw-r--r-- 1 root root 1062 Sep 14  2020 90-ib.rules
ncn-m003: -rw-r--r-- 1 root root 1911 Apr 27 19:39 90-net.rules
ncn-m003: -rw-r--r-- 1 root root  279 Apr 27 19:39 99-live-squash.rules
ncn-m003: -rw-r--r-- 1 root root  174 Dec 10 21:52 99-lustre.rules
ncn-w001: total 49
ncn-w001: -rw-r--r-- 1 root root  142 Feb 17 16:44 11-dm.rules
ncn-w001: -rw-r--r-- 1 root root  680 Mar  8 00:18 59-persistent-storage-dm.rules
ncn-w001: -rw-r--r-- 1 root root  853 Mar  8 00:18 59-persistent-storage-md.rules
ncn-w001: -rw-r--r-- 1 root root  297 Mar  8 00:18 59-persistent-storage.rules
ncn-w001: -rw-r--r-- 1 root root 1030 Mar  8 00:18 61-persistent-storage.rules
ncn-w001: -rw-r--r-- 1 root root  775 Feb 17 16:44 64-lvm.rules
ncn-w001: -rw-r--r-- 1 root root 1475 Feb 17 16:44 65-md-incremental-imsm.rules
ncn-w001: -rw-r--r-- 1 root root  267 Apr 27 19:40 70-luks.rules
ncn-w001: -rw-r--r-- 1 root root  628 Sep  8  2020 70-persistent-ipoib.rules
ncn-w001: -rw-r--r-- 1 root root  443 Mar  3 20:10 70-persistent-net.rules
ncn-w001: -rw-r--r-- 1 root root  557 Sep 14  2020 82-net-setup-link.rules
ncn-w001: -rw-r--r-- 1 root root  341 Apr 27 19:40 84-ifname.rules
ncn-w001: -rw-r--r-- 1 root root 1062 Sep 14  2020 90-ib.rules
ncn-w001: -rw-r--r-- 1 root root 2135 Apr 27 19:40 90-net.rules
ncn-w001: -rw-r--r-- 1 root root  279 Apr 27 19:40 99-live-squash.rules
ncn-w001: -rw-r--r-- 1 root root  174 Dec 10 21:52 99-lustre.rules
ncn-w002: total 49
ncn-w002: -rw-r--r-- 1 root root  142 Feb 17 16:44 11-dm.rules
ncn-w002: -rw-r--r-- 1 root root  680 Mar  8 00:18 59-persistent-storage-dm.rules
ncn-w002: -rw-r--r-- 1 root root  853 Mar  8 00:18 59-persistent-storage-md.rules
ncn-w002: -rw-r--r-- 1 root root  297 Mar  8 00:18 59-persistent-storage.rules
ncn-w002: -rw-r--r-- 1 root root 1030 Mar  8 00:18 61-persistent-storage.rules
ncn-w002: -rw-r--r-- 1 root root  775 Feb 17 16:44 64-lvm.rules
ncn-w002: -rw-r--r-- 1 root root 1475 Feb 17 16:44 65-md-incremental-imsm.rules
ncn-w002: -rw-r--r-- 1 root root  267 Apr 27 19:40 70-luks.rules
ncn-w002: -rw-r--r-- 1 root root  628 Sep  8  2020 70-persistent-ipoib.rules
ncn-w002: -rw-r--r-- 1 root root  443 Mar  3 20:10 70-persistent-net.rules
ncn-w002: -rw-r--r-- 1 root root  557 Sep 14  2020 82-net-setup-link.rules
ncn-w002: -rw-r--r-- 1 root root 1062 Sep 14  2020 90-ib.rules
ncn-w002: -rw-r--r-- 1 root root 2135 Apr 27 19:40 90-net.rules
ncn-w002: -rw-r--r-- 1 root root  341 Apr 27 19:40 98-ifname.rules
ncn-w002: -rw-r--r-- 1 root root  279 Apr 27 19:40 99-live-squash.rules
ncn-w002: -rw-r--r-- 1 root root  174 Dec 10 21:52 99-lustre.rules
ncn-w002: total 49
ncn-w002: -rw-r--r-- 1 root root  142 Feb 17 16:44 11-dm.rules
ncn-w002: -rw-r--r-- 1 root root  680 Mar  8 00:18 59-persistent-storage-dm.rules
ncn-w002: -rw-r--r-- 1 root root  853 Mar  8 00:18 59-persistent-storage-md.rules
ncn-w002: -rw-r--r-- 1 root root  297 Mar  8 00:18 59-persistent-storage.rules
ncn-w002: -rw-r--r-- 1 root root 1030 Mar  8 00:18 61-persistent-storage.rules
ncn-w002: -rw-r--r-- 1 root root  775 Feb 17 16:44 64-lvm.rules
ncn-w002: -rw-r--r-- 1 root root 1475 Feb 17 16:44 65-md-incremental-imsm.rules
ncn-w002: -rw-r--r-- 1 root root  267 Apr 27 19:40 70-luks.rules
ncn-w002: -rw-r--r-- 1 root root  628 Sep  8  2020 70-persistent-ipoib.rules
ncn-w002: -rw-r--r-- 1 root root  443 Mar  3 20:10 70-persistent-net.rules
ncn-w002: -rw-r--r-- 1 root root  557 Sep 14  2020 82-net-setup-link.rules
ncn-w002: -rw-r--r-- 1 root root  341 Apr 27 19:40 84-ifname.rules
ncn-w002: -rw-r--r-- 1 root root 1062 Sep 14  2020 90-ib.rules
ncn-w002: -rw-r--r-- 1 root root 2135 Apr 27 19:40 90-net.rules
ncn-w002: -rw-r--r-- 1 root root  279 Apr 27 19:40 99-live-squash.rules
ncn-w002: -rw-r--r-- 1 root root  174 Dec 10 21:52 99-lustre.rules
Fixing mdadm.conf
ncn-s001: no mdadm.conf to tweak on this image set
ncn-s002: no mdadm.conf to tweak on this image set
ncn-s003: no mdadm.conf to tweak on this image set
ncn-m002: no mdadm.conf to tweak on this image set
ncn-m001: no mdadm.conf to tweak on this image set
ncn-m003: no mdadm.conf to tweak on this image set
ncn-w002: no mdadm.conf to tweak on this image set
ncn-w001: no mdadm.conf to tweak on this image set
ncn-w003: no mdadm.conf to tweak on this image set
Fixing cloud-init
ncn-s003:
ncn-s001:
ncn-s002:
ncn-m001:
ncn-m003:
ncn-m002:
ncn-w002:
ncn-w001:
ncn-w003:
```
