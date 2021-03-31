## CASMINST-1906 -- csi pit validate --ceph fails on all storage nodes higher than ncn-s003
If the storage nodes higher than ncn-s003 (ncn-s004, s005, etc.) return failures when running csi pit validate --ceph 
against them, just ignore the errors. This is expected as they are not configured to handle these tests.
