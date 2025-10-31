#!/bin/sh
set -euo pipefail

# Run the apache process in the foreground as in the php image
echo "[pkp-ojs starting] satarting apache in foreground"
/usr/sbin/httpd -f /etc/apache2/apache.conf -D FOREGROUND
echo "[pkp-ojs starting] satarted apache in foreground"
