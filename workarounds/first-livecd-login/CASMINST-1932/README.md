# CASMINST-1932

Before starting services, the metal-basecamp image needs to be tagged so that
basecamp systemd can start.

```bash
pit# podman tag a9ca210ea52b dtr.dev.cray.com/cray/metal-basecamp:1.1.0-1de4aa6
```
