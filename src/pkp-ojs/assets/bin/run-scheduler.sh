#!/bin/sh
set -euo pipefail

echo "[pkp-ojs scheduler] running scheduler"
php /var/www/html/lib/pkp/tools/scheduler.php run
echo "[pkp-ojs scheduler] finished running scheduler"
