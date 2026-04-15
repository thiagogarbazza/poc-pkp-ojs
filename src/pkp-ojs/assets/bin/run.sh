#!/bin/sh
set -euo pipefail

# Run the apache process in the foreground as in the php image
echo "[pkp-ojs starting] starting supercronic"
/usr/bin/supercronic /etc/crontab &
echo "[pkp-ojs starting] started supercronic"

echo "[pkp-ojs starting] starting apache in foreground"
/usr/sbin/httpd -f /etc/apache2/apache.conf -D FOREGROUND
echo "[pkp-ojs starting] started apache in foreground"
