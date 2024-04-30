#!/bin/bash
#set -eu pipefail

expose COMPOSE_PROJECT_NAME="poc-pkp-ojs"
SKIP_BUILD_APP=false
CLEAN_OLD_EXECUTION=""

while :; do
  case $1 in
    -sb|--skip-build) SKIP_BUILD_APP=true ;;
    -ce|--clean-old-execution) CLEAN_OLD_EXECUTION="--vlomues" ;;
    *) break
  esac
  shift
done

if [[ "$SKIP_BUILD_APP" == "false" ]] ; then
  bash .ci/build.sh
else
  echo "Build skiped"
fi

echo "Remove old docker images and clean old executions"
docker compose -f .dev/docker-compose.yml down --remove-orphans $CLEAN_OLD_EXECUTION
[[ -n "$(docker image ls -aqf=reference='poc-pkp-ojs*/*')" ]] && docker image rm -f $(docker image ls -aqf=reference="poc-pkp-ojs*/*")

echo "Start ojs"
docker compose -f .dev/docker-compose.yml up

# For enter job backup container
# docker exec -it poc-pkp-ojs-job-backup-1 ash

# For enter ojs container
# docker exec -it poc-pkp-ojs-ojs-1 ash

# For enter postgres container
# docker exec -it poc-pkp-ojs-postgres-1 ash
