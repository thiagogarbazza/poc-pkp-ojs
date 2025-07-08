#!/bin/bash
set -euo pipefail

SKIP_BUILD_APP="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -sb|--skip-build)
      SKIP_BUILD_APP="true"
      shift
      ;;
    *)
      echo "Opção desconhecida: $1"
      exit 9
      ;;
  esac
done

if [[ "$SKIP_BUILD_APP" == "false" ]] ; then
  bash .config/workflows/ci-build.sh
  echo "Build application"
else
  echo "Build skiped"
fi

echo "Remove old docker images and clean old executions"
docker compose -f .config/dev/docker-compose.yml down --remove-orphans
[[ -n "$(docker image ls -aqf=reference='pkp/ojs*')" ]] && docker image rm -f $(docker image ls -aqf=reference="pkp/ojs*")

echo "Start pkp-ojs"
docker compose -f .config/dev/docker-compose.yml up --abort-on-container-failure --force-recreate --remove-orphans

# For enter job backup container
# docker exec -it poc-pkp-ojs-job-backup-1 ash

# For enter ojs container
# docker exec -it poc-pkp-ojs-ojs-1 ash

# For enter postgres container
# docker exec -it poc-pkp-ojs-postgres-1 ash
