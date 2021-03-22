# Setting the upstream NTP server on m001 after handoff

This script will set the upstream time server on m001 after handoff, where it was previously hardcoded to ncn-m001.  This works fine for other NCNs, but not m001 itself.

This script can be run locally on m001, or from any other NCN that has ssh access to ncn-m001.

Expected output (local)

```
Running this workaround locally...
Existing value:
15:UPSTREAM_NTP_SERVER=$(craysys metadata get upstream_ntp_server || echo -n  )

New value:
15:UPSTREAM_NTP_SERVER=$(craysys metadata get upstream_ntp_server || echo -n  )

Setting the time with the new server...
CURRENT TIME SETTINGS
rtc: 2021-03-22 08:49:57.217637+00:00
sys: 2021-03-22 08:49:58.006675+0000
200 OK
200 OK
NEW TIME SETTINGS
rtc: 2021-03-22 08:50:28.530111+00:00
sys: 2021-03-22 08:50:29.013139+0000
```

Expected output (remote)

```
Running this workaround remotely...
Setting the time with the new server...
CURRENT TIME SETTINGS
rtc: 2021-03-22 08:52:43.545702+00:00
sys: 2021-03-22 08:52:44.024879+0000
200 OK
200 OK
NEW TIME SETTINGS
rtc: 2021-03-22 08:53:14.530110+00:00
sys: 2021-03-22 08:53:15.010373+0000
```
