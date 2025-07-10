FROM alpine:3.22

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    TZ=America/Sao_Paulo \
    # Override WAIT_TO_START if you need to debug job. Waits "x" seconds before attempting to run the job.
    WAIT_TO_START=0 \
    # Override WAIT_TO_END if you need to debug job. Waits "x" seconds before ending the job execution.
    WAIT_TO_END=0

RUN set -euxo pipefail; \
  # Create group and user to run the application.
  addgroup --system --gid 1000 appgroup; \
  adduser --disabled-password --home /home/appuser --no-create-home --system --ingroup appgroup --uid 1000 appuser; \
  # Configure timezone
  apk add --no-cache tzdata; \
  cp /usr/share/zoneinfo/${TZ} /etc/localtime; \
  echo $TZ > /etc/timezone; \
  # Add postgresql and libraries
  apk add --no-cache postgresql17-client; \
  # Remove garbage after installation.
  rm -rf /var/cache/apk/* /root/.cache/* /tmp/*

USER appuser:appgroup

VOLUME ["/var/www/files", "/var/www/html/public", "/data/backups"]

WORKDIR /data/backups

CMD ["run.sh"]

COPY --chown=appuser:appgroup --chmod=551 src/jobs/backup/assets/run.sh /usr/local/bin/run.sh
