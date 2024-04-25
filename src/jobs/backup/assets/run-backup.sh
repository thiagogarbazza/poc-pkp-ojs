#!/bin/sh
set -eu pipefail

BACKUP_DIR=/data/backups
OJS_FILE_DIR=/var/www/files
OJS_PUBLIC_DIR=/var/www/html/public

DAY_OF_MONTH=`date +%d`

if [ $DAY_OF_MONTH -eq 1 ]; then
  TYPE="mensal"
  EXPIRED_DAYS=91 # manter por 3 meses
else
  TYPE="diario"
  EXPIRED_DAYS=7 # manter por 7 dias
fi

BACKUP_FILE_NAME="$(date +"%Y-%m-%d")-$TYPE"

###########################
#### PRE-BACKUP CHECKS ####
###########################

[ -d $BACKUP_DIR ] || { echo "[backup] Diretório de armazenamento dos backups não está disponível: $BACKUP_DIR"; exit 1; }
[ -d $OJS_FILE_DIR ] || { echo "[backup] Diretório 'files' do PKP - OJS não está disponível: $OJS_FILE_DIR"; exit 1; }
[ -d $OJS_PUBLIC_DIR ] || { echo "[backup] Diretório 'public' do PKP - OJS não está disponível: $OJS_PUBLIC_DIR"; exit 1; }

# Make sure we're running as the required backup user
# if [ "$BACKUP_USER" != "" -a "$(id -un)" != "$BACKUP_USER" ] ; then
#   echo "[PGBACKUP]This script must be run as $BACKUP_USER. Exiting." 1>&2
#   exit 1
# fi

###########################
#### START THE BACKUPS ####
###########################

echo "[backup] Deletando todos os diretórios de backup '$TYPE' expirados, criados a mais de $EXPIRED_DAYS dias."
find /data/backups -maxdepth 1 -mtime +$EXPIRED_DAYS -name "*-$TYPE" \
  -exec echo "Removendo os backups {}" \; \
  -exec rm -rf {} \;

TMP_DIR=/tmp/backup-poc-pkp-ojs/$BACKUP_FILE_NAME
mkdir -p $TMP_DIR

echo "[backup] Criando arquivo de backup do $OJS_FILE_DIR"
tar -C $OJS_FILE_DIR -cvzf $TMP_DIR/ojs-files.tar.gz --exclude="*.log" --exclude="*.mmdb" .

echo "[backup] Criando arquivo de backup do $OJS_PUBLIC_DIR"
tar -C $OJS_PUBLIC_DIR -cvzf $TMP_DIR/ojs-public.tar.gz --exclude="*.log" --exclude="*.mmdb" .

echo "[backup] Criando arquivo de backup do banco de dados"
#pg_dump --host="postgres" --port=5432 --username="postgreSQL" --dbname="ojs" --format="tar" > $TMP_DIR/database.bkp

echo "[backup] Criando arquivo de backup geral e movendo para o diretório $BACKUP_DIR/$BACKUP_FILE_NAME.tar.gz"
rm -rf $BACKUP_DIR/$BACKUP_FILE_NAME.tar.gz
tar -C $TMP_DIR -cvzf $BACKUP_DIR/$BACKUP_FILE_NAME.tar.gz .

echo "[backup] Limpando arquivos temporários"
rm -rf $TMP_DIR
