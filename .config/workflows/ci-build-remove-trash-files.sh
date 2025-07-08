#!/bin/bash
set -euo pipefail

# ^.*(.css|.dtd|.gif|.html|.ico|.jpg|.js|.json|.less|.php|.png|.svg|.xml)$
echo "
┌─────────────────────────────────────────────────────────────────────────────┐
├───────── Remove trash files                                        ─────────┤
└─────────────────────────────────────────────────────────────────────────────┘
"

find target/pkp-ojs \
  \(   -iname "*.sh" \
    -o -iname "*.bat" \
    -o -iname ".babelrc" \
    -o -iname ".diff" \
    -o -iname ".dockerignore" \
    -o -iname ".editorconfig" \
    -o -iname ".env.travis" \
    -o -iname ".eslintignore" \
    -o -iname ".eslintrc.js" \
    -o -type d -iname ".git" \
    -o -iname ".gitattributes" \
    -o -type d -iname ".github" \
    -o -iname ".gitignore" \
    -o -iname ".gitmodules" \
    -o -iname ".jshintrc" \
    -o -iname ".keepme" \
    -o -iname ".keepme" \
    -o -iname ".openshift" \
    -o -iname ".postcssrc.js" \
    -o -iname ".scrutinizer.yml" \
    -o -iname ".travis.yml" \
    -o -iname "authors" \
    -o -iname "babel.config.js" \
    -o -iname "backers.md" \
    -o -iname "bower.json" \
    -o -iname "changelog" \
    -o -iname "changelog.md" \
    -o -iname "changelog.txt" \
    -o -iname "changelog_*" \
    -o -iname "changelog-*" \
    -o -iname "changes" \
    -o -iname "changes.md" \
    -o -iname "code_of_conduct.md" \
    -o -iname "component.json" \
    -o -iname "compose.yml" \
    -o -iname "composer.json" \
    -o -iname "composer.lock" \
    -o -iname "config.TEMPLATE.inc.php" \
    -o -iname "contributing" \
    -o -iname "contributing.md" \
    -o -iname "credits" \
    -o -iname "cypress.travis.env.json" \
    -o -iname "dockerfile" \
    -o -iname "docker-compose.yml" \
    -o -type d -iname "docs" \
    -o -iname "deprecations.md" \
    -o -iname "info.md" \
    -o -iname "license" \
    -o -iname "license.md" \
    -o -iname "license.txt" \
    -o -iname "makefile" \
    -o -iname "maintainers.md" \
    -o -iname "node_modules" \
    -o -iname "notice" \
    -o -iname "notice.txt" \
    -o -iname "package.json" \
    -o -iname "patches.txt" \
    -o -iname "readme" \
    -o -iname "readme.md" \
    -o -iname "readme.auth.txt" \
    -o -iname "security.md" \
    -o -type d -iname "test" \
    -o -name  "upgrading.md" \
    -o -name  "upgrade.md" \
    -o -name  "upgrade-*.md" \
    -o -name  "version" \
    -o -name  "vue.config.js" \
    -o -name  "webpack.config.js" \
  \) >> target/pkp-ojs-removed-files
rm -rf $(cat target/pkp-ojs-removed-files)
echo "See more details of removed files, access the file target/pkp-ojs-removed-files"
