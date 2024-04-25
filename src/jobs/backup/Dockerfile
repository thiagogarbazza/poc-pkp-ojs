FROM alpine:3.16

COPY src/jobs/backup/assets/run-backup.sh /usr/local/bin/run-backup

VOLUME ["/var/www/files", "/var/www/html/public", "/data/postgres", "/data/backups"]

WORKDIR /data/backups

CMD ["run-backup"]
