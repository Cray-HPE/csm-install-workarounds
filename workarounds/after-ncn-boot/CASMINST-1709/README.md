## Start Goss Servers on the Non-Compute Nodes

Prior to running the Goss automated tests against the NCNs, the goss-servers service must be started on each NCN by logging in
to each one and executing the following command:

```bash
ncn# systemctl start goss-servers.service
```