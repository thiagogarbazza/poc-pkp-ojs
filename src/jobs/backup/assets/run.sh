#!/bin/sh
set -euo pipefail

if [[ "${WAIT_TO_START:-0}" -gt 0 ]]; then
  echo "Waiting for ${WAIT_TO_START} seconds before starting..."
  sleep "${WAIT_TO_START}"
fi

BACKUP_DIR=/data/backups
OJS_FILE_DIR=/var/www/files
OJS_PUBLIC_DIR=/var/www/html/public
POSTGRES_DIR=/var/lib/postgresql/data

DAY_OF_MONTH=`date +%d`

if [ $DAY_OF_MONTH -eq 1 ]; then
  TYPE="monthly"
  EXPIRED_DAYS=91 # keep for 3 months
else
  TYPE="daily"
  EXPIRED_DAYS=7 # keep for 7 days
fi

BACKUP_FILE_NAME="$(date +"%Y-%m-%d")-$TYPE"

###########################
#### PRE-BACKUP CHECKS ####
###########################

[ -d $BACKUP_DIR ] || { echo "[backup] backup directory is not available: $BACKUP_DIR"; exit 1; }
[ -d $OJS_FILE_DIR ] || { echo "[backup] PKP - OJS 'files' directory is not available: $OJS_FILE_DIR"; exit 1; }
[ -d $OJS_PUBLIC_DIR ] || { echo "[backup] PKP - OJS 'public' directory is not available: $OJS_PUBLIC_DIR"; exit 1; }
[ -d $POSTGRES_DIR ] || { echo "[backup] Postgres storage directory is not available: $POSTGRES_DIR"; exit 1; }

[ -z "${POSTGRES_HOST:-''}" ] && { echo "[backup] Variable 'POSTGRES_HOST' is not set"; exit 1; }
[ -z "${POSTGRES_DB:-''}" ] && { echo "[backup] Variable 'POSTGRES_DB' is not set"; exit 1; }
[ -z "${POSTGRES_PASSWORD:-''}" ] && { echo "[backup] Variable 'POSTGRES_PASSWORD' is not set"; exit 1; }
[ -z "${POSTGRES_USER:-''}" ] && { echo "[backup] Variable 'POSTGRES_USER' is not set"; exit 1; }

###########################
#### START THE BACKUPS ####
###########################

echo "[backup] Deletando todos os diretórios de backup '$TYPE' expirados, criados a mais de $EXPIRED_DAYS dias."
find /data/backups -maxdepth 1 -mtime +$EXPIRED_DAYS -name "*$TYPE*" \
  -exec echo "Removendo o backup {}" \; \
  -exec rm -rf {} \;

echo "[backup] Limpando e criando diretório temporário para a criação do backup"
TMP_DIR=/tmp/backup-poc-pkp-ojs/$BACKUP_FILE_NAME
rm -rf $TMP_DIR
mkdir -p $TMP_DIR

echo "[backup] Criando arquivo de backup do $OJS_FILE_DIR"
tar -C $OJS_FILE_DIR -czf $TMP_DIR/ojs-files.tar.gz --exclude="*.bkp" --exclude="*.log" --exclude="*.mmdb" .

echo "[backup] Criando arquivo de backup do $OJS_PUBLIC_DIR"
tar -C $OJS_PUBLIC_DIR -czf $TMP_DIR/ojs-public.tar.gz --exclude="*.bkp" --exclude="*.log" --exclude="*.mmdb" .

echo "[backup] Criando arquivo de backup do banco de dados"
PGPASSWORD="$POSTGRES_PASSWORD" pg_dump --host="$POSTGRES_HOST" --port=5432 --username="$POSTGRES_USER" --dbname="$POSTGRES_DB" --no-owner --format="tar" > $TMP_DIR/database.bkp
tar -C $TMP_DIR -zcf $TMP_DIR/database.tar.gz database.bkp
rm -rf $TMP_DIR/database.bkp

echo "[backup] Criando arquivo de backup geral e movendo para o diretório $BACKUP_DIR/$BACKUP_FILE_NAME.tar.gz"
rm -rf $BACKUP_DIR/$BACKUP_FILE_NAME.tar.gz
tar -C $TMP_DIR -czf $BACKUP_DIR/$BACKUP_FILE_NAME.tar.gz .

echo "[backup] Limpando arquivos temporários"
rm -rf $TMP_DIR

if [[ "${WAIT_TO_END:-0}" -gt 0 ]]; then
  echo "Will wait for ${WAIT_TO_END} seconds before stopping..."
  sleep "${WAIT_TO_END}"
fi
