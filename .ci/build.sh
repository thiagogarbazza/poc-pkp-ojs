#!/bin/bash
set -euo pipefail

OJS_VERSION="3.4.0-5"

echo "Remove last build"
rm -rf target
mkdir -p target

echo "Download release package from PKP website. OJS version '$OJS_VERSION'"
curl -fsSLo target/ojs.tar.gz https://pkp.sfu.ca/ojs/download/ojs-$OJS_VERSION.tar.gz
tar -xzf target/ojs.tar.gz -C target
mv target/ojs-$OJS_VERSION target/app

echo "Install themes plugin: Bootstrap 3 Base Theme"
git clone --depth=1 https://github.com/pkp/bootstrap3.git target/app/plugins/themes/bootstrap3

echo "Install generic plugin: Allowed Uploads "
git clone --depth=1 https://github.com/ajnyga/allowedUploads.git target/app/plugins/generic/allowedUploads
cp -ap target/app/plugins/generic/allowedUploads/locale/en target/app/plugins/generic/allowedUploads/locale/pt_BR

echo "Install generic plugin: Backup"
git clone --depth=1 https://github.com/asmecher/backup.git target/app/plugins/generic/backup


echo "Generate healthcheck"
echo "<?php
  declare(strict_types=1);

  echo 'OK';
?>" > target/app/healthcheck.php


echo "Generate build-info"
echo "<!DOCTYPE html>
<html>
<body>

  OJS version=$OJS_VERSION

</body>
</html>" > target/app/build-info.html


echo "Remove trash files"
rm -rf target/app/config.TEMPLATE.inc.php \
       target/app/README.md \
       target/app/SECURITY.md \
       target/app/cypress.travis.env.json
find target/app \
  \(    -name  ".gitignore" \
     -o -name  ".gitmodules" \
     -o -name  ".keepme" \
     -o -name  ".travis.yml" \
     -o -iname "license" \
     -o -iname "license.md" \
     -o -iname "license.txt" \
     -o -iname "readme" \
     -o -iname "readme.md" \
     -o -iname "security.md" \
     -o -name  "test" \) \
  -exec rm -rf {} ';'

echo "RePackage"
tar -C target/app -czf target/app.tar.gz .
