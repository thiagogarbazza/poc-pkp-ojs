#!/bin/sh
set -euo pipefail

setVariable() {
  echo "set variable ${1} with ${2} on config.inc.php"
  sed -i -e "s/^${1} =.*/${1} = ${2}/" /var/www/html/config.inc.php
}

setVariable installed $OJS_CLI_INSTALL
setVariable driver $OJS_DB_DRIVER
setVariable host $OJS_DB_HOST
setVariable username $OJS_DB_USER
setVariable password $OJS_DB_PASSWORD
setVariable name $OJS_DB_NAME

# Start the cron service in the background.
/usr/sbin/crond -f &
echo "[OJS Start] Started cron"

# Run the apache process in the foreground as in the php image
/usr/sbin/httpd -f /etc/apache2/httpd.conf -DFOREGROUND
echo "[OJS Start] Started apache..."
