FROM alpine:3.22

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    TZ=America/Sao_Paulo \
    # Sobrescreva WAIT_TO_START no PGA se precisar depurar o batch, Espera "x" segundos antes de tentar rodar o job.
    WAIT_TO_START=0 \
    # Sobrescreva WAIT_TO_END no PGA se precisar depurar o batch, Espera "x" segundos antes de encerrar a execução do job.
    WAIT_TO_END=0

RUN set -euxo pipefail; \
  # Cria o grupo e o usuário executor da aplicação.
  addgroup --system --gid 1000 appgroup; \
  adduser --disabled-password --home /home/appuser --no-create-home --system --ingroup appgroup --uid 1000 appuser; \
  # Configura timezone
  apk add --no-cache tzdata; \
  cp /usr/share/zoneinfo/${TZ} /etc/localtime; \
  echo $TZ > /etc/timezone; \
  # Adiciona as libs necessárias.
  apk add --no-cache postgresql17-client; \
  # Remove lixo após instalação.
  rm -rf /var/cache/apk/* /root/.cache/* /tmp/*

USER appuser:appgroup

VOLUME ["/var/www/files", "/var/www/html/public", "/data/backups"]

WORKDIR /data/backups

CMD ["run.sh"]

COPY --chown=appuser:appgroup --chmod=551 src/jobs/backup/assets/run.sh /usr/local/bin/run.sh
