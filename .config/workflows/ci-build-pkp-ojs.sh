#!/bin/bash
set -euo pipefail

PKP_OJS_VERSION="3.4.0-9"
PKP_OJS_PLUGIN_ALLOWED_UPLOADS_VERSION="3.4.0.1"
PKP_OJS_PLUGIN_BOOTSTRAP_VERSION="3_4_0-3"

PKP_CACHE_DIR="$HOME/.cache/pkp/ojs"
mkdir -p $PKP_CACHE_DIR


echo "
┌─────────────────────────────────────────────────────────────────────────────┐
├───────── Download PKP-OJS release package                          ─────────┤
└─────────────────────────────────────────────────────────────────────────────┘
"
if [[ ! -f $PKP_CACHE_DIR/pkp-ojs-$PKP_OJS_VERSION.tar.gz ]]; then
  echo "Download PKP-OJS from official website version '$PKP_OJS_VERSION'"
  curl -fsSLo $PKP_CACHE_DIR/pkp-ojs-$PKP_OJS_VERSION.tar.gz https://pkp.sfu.ca/ojs/download/ojs-$PKP_OJS_VERSION.tar.gz
fi
echo "Extract PKP-OJS $PKP_OJS_VERSION into target/pkp-ojs"
tar -xzf $PKP_CACHE_DIR/pkp-ojs-$PKP_OJS_VERSION.tar.gz -C target
mv target/ojs-$PKP_OJS_VERSION target/pkp-ojs


echo "
┌─────────────────────────────────────────────────────────────────────────────┐
├───────── Install generic plugin: Allowed Uploads                   ─────────┤
└─────────────────────────────────────────────────────────────────────────────┘
"
if [[ ! -f $PKP_CACHE_DIR/pkp-ojs-plugin-generic-allowedUploads-$PKP_OJS_PLUGIN_ALLOWED_UPLOADS_VERSION.tar.gz ]]; then
  echo "Download generic plugin: Allowed Uploads from github version '$PKP_OJS_PLUGIN_ALLOWED_UPLOADS_VERSION'"
  curl -fsSLo $PKP_CACHE_DIR/pkp-ojs-plugin-generic-allowedUploads-$PKP_OJS_PLUGIN_ALLOWED_UPLOADS_VERSION.tar.gz https://github.com/ajnyga/allowedUploads/releases/download/$PKP_OJS_PLUGIN_ALLOWED_UPLOADS_VERSION/allowedUploads.tar.gz
fi
echo "Extract generic plugin: Allowed Uploads $PKP_OJS_PLUGIN_ALLOWED_UPLOADS_VERSION into target/pkp-ojs/plugins/generic"
tar -xzf $PKP_CACHE_DIR/pkp-ojs-plugin-generic-allowedUploads-$PKP_OJS_PLUGIN_ALLOWED_UPLOADS_VERSION.tar.gz -C target/pkp-ojs/plugins/generic
cp -ap target/pkp-ojs/plugins/generic/allowedUploads/locale/en target/pkp-ojs/plugins/generic/allowedUploads/locale/pt_BR


echo "
┌─────────────────────────────────────────────────────────────────────────────┐
├───────── Install themes plugin: Bootstrap 3 Base Theme             ─────────┤
└─────────────────────────────────────────────────────────────────────────────┘
"
if [[ ! -f $PKP_CACHE_DIR/pkp-ojs-plugin-theme-bootstrap-$PKP_OJS_PLUGIN_BOOTSTRAP_VERSION.tar.gz ]]; then
  echo "Download themes plugin: Bootstrap 3 Base Theme from github version '$PKP_OJS_PLUGIN_BOOTSTRAP_VERSION'"
  curl -fsSLo $PKP_CACHE_DIR/pkp-ojs-plugin-theme-bootstrap-$PKP_OJS_PLUGIN_BOOTSTRAP_VERSION.tar.gz https://github.com/pkp/bootstrap3/releases/download/v$PKP_OJS_PLUGIN_BOOTSTRAP_VERSION/bootstrap3-v$PKP_OJS_PLUGIN_BOOTSTRAP_VERSION.tar.gz
fi
echo "Extract themes plugin: Bootstrap 3 Base Theme $PKP_OJS_PLUGIN_BOOTSTRAP_VERSION into target/pkp-ojs/plugins/themes"
tar -xzf $PKP_CACHE_DIR/pkp-ojs-plugin-theme-bootstrap-$PKP_OJS_PLUGIN_BOOTSTRAP_VERSION.tar.gz -C target/pkp-ojs/plugins/themes


echo "
┌─────────────────────────────────────────────────────────────────────────────┐
├───────── Generate custom pages                                     ─────────┤
└─────────────────────────────────────────────────────────────────────────────┘
"

echo "Generate page: healthcheck"
echo "<?php
  declare(strict_types=1);

  echo 'OK';
?>" > target/pkp-ojs/healthcheck.php


echo "Generate page: build-info"
echo "<!DOCTYPE html>
<html>
<body>

  <br/>PKP-OJS = $PKP_OJS_VERSION
  <br/>PKP-OJS generic plugin: Allowed Uploads = $PKP_OJS_PLUGIN_ALLOWED_UPLOADS_VERSION
  <br/>PKP-OJS themes plugin: Bootstrap 3 Base Theme = $PKP_OJS_PLUGIN_BOOTSTRAP_VERSION

</body>
</html>" > target/pkp-ojs/build-info.html
