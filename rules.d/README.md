# Monitoring backpack

This repository contains rules and configurations to easily monitor a
home server.

## Modules

### apt

This module contains rules to monitor that packages installed from apt are
up-to-date. On Debian-based systems packages can signal that they require
a reboot. If such a condition is encouraged, an alert is generated as well.

This module relies on the `apt.sh` example script shipped with
`prometheus-node-exporter`.

### smart

This module monitors basic SMART health values of attached hard drives and
SSDs.

This module relies on the `smartmon.sh` example script shipped with
`prometheus-node-exporter`.

### uptime

This module generates alerts around the uptime of the system. This includes
basic status monitoring like node up/down, as well as generating an
informational alert when the node has rebooted. If the machine has not been
rebooted for a long time, an alert is generated as well.

### system

This module uses the regular node-exporter metrics to alert on the machine's
health.

### systemd

This module monitors the health of systemd on a system.

Thie module requires that the systemd collector in `prometheus-node-exporter`
is enabled.
