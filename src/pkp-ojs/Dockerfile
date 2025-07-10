FROM alpine:3.22

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    TZ=America/Sao_Paulo

RUN set -euxo pipefail; \
  # Create group and user to run the application.
  addgroup --system --gid 1000 appgroup; \
  adduser --disabled-password --home /home/appuser --no-create-home --system --ingroup appgroup --uid 1000 appuser; \
  # Configure timezone
  apk add --no-cache tzdata; \
  cp /usr/share/zoneinfo/${TZ} /etc/localtime; \
  echo $TZ > /etc/timezone; \
  # Add the necessary libraries to perform filewatch
  apk add --no-cache inotify-tools; \
  # Add apache and libraries
  apk add --no-cache apache2 apache2-ssl apache2-utils; \
  # Add php and libraries
  apk add --no-cache php84 php84-apache2 php84-bcmath php84-bz2 php84-calendar php84-ctype php84-curl php84-dom php84-exif php84-fileinfo php84-ftp \
                     php84-gettext php84-iconv php84-intl php84-json php84-mbstring php84-opcache php84-openssl php84-pdo_pgsql php84-pgsql \
                     php84-phar php84-posix php84-session php84-shmop php84-simplexml php84-sockets php84-sysvmsg php84-sysvsem php84-sysvshm \
                     php84-tokenizer php84-xml php84-xmlreader php84-xmlwriter php84-zip php84-zlib; \
  ln -s /usr/bin/php84 /usr/bin/php; \
  # Add utility libraries
  apk add --no-cache ca-certificates; \
  # Create directory used by pkp-ojs.
  mkdir -m 750 -p /var/www/files; \
  chmod -R 750 /var/www/files; \
  chown -R appuser:appgroup /var/www/files /run/apache2; \
  # Remove garbage after installation.
  rm -rf /var/cache/apk/* /root/.cache/* /tmp/* /etc/apache2/conf.d/ssl.conf

USER appuser:appgroup

WORKDIR /var/www

VOLUME ["/var/www/files", "/var/www/html/public"]

EXPOSE 80 443

CMD ["run.sh"]

ADD  --chown=appuser:appgroup --chmod=551 target/pkp-ojs.tar.gz /var/www/html
COPY --chown=appuser:appgroup --chmod=551 src/pkp-ojs/assets/bin/run.sh /usr/local/bin/run.sh
COPY src/pkp-ojs/assets/httpd.conf /etc/apache2
COPY src/pkp-ojs/assets/httpd-ojs.conf /etc/apache2/conf.d
