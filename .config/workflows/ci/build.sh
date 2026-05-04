#!/bin/bash
set -euo pipefail

echo "Clear old builds"
rm -rf target
mkdir -p target

.config/workflows/ci/build-pkp-ojs.sh
.config/workflows/ci/build-remove-trash-files.sh

echo "
┌─────────────────────────────────────────────────────────────────────────────┐
├───────── RePackage                                                 ─────────┤
└─────────────────────────────────────────────────────────────────────────────┘
"
tar -C target/pkp-ojs -czf target/pkp-ojs.tar.gz --group=1000 --owner=1000 .
