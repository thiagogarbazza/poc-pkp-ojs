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
  bash .config/workflows/ci/build.sh
  echo "Build application"
else
  echo "Build skiped"
fi

echo "Remove old docker images and clean old executions"
docker compose --project-name poc-pkp --file .config/dev/docker-compose.yml down --remove-orphans
[[ -n "$(docker image ls -aqf=reference='pocs/pkp*')" ]] && docker image rm -f $(docker image ls -aqf=reference="pocs/pkp*")

echo "Start pkp-ojs"
docker compose --project-name poc-pkp --file .config/dev/docker-compose.yml up --abort-on-container-failure --force-recreate --remove-orphans

# For enter job backup container
# docker exec -it poc-pkp-app-job-backup-1 ash

# For enter ojs container
# docker exec -it poc-pkp-app-pkp-ojs-1 ash

# For enter postgres container
# docker exec -it poc-pkp-postgres-1 ash

# For enter smtp container
# docker exec -it poc-pkp-smtp-1 ash
