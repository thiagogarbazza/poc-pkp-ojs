FROM alpine:3.23.3

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
  apk add --no-cache php85 \
                     php85-apache2 php85-bcmath php85-bz2 php85-calendar \
                     php85-ctype php85-curl php85-dom php85-exif php85-fileinfo \
                     php85-ftp php85-gettext php85-gd php85-iconv php85-intl \
                     php85-json php85-mbstring php85-openssl php85-pdo_pgsql \
                     php85-pgsql php85-phar php85-posix php85-session \
                     php85-shmop php85-simplexml php85-sockets php85-sysvmsg \
                     php85-sysvsem php85-sysvshm php85-tokenizer \
                     php85-xml php85-xmlreader php85-xmlwriter php85-xsl \
                     php85-zip php85-zlib \
                     ; \
  ln -s /usr/bin/php85 /usr/bin/php; \
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

EXPOSE 80

CMD ["run.sh"]

COPY --chown=root:root        --chmod=444 src/pkp-ojs/assets/apache.conf          /etc/apache2
COPY --chown=root:root        --chmod=444 src/pkp-ojs/assets/apache-app.conf      /etc/apache2/conf.d
COPY --chown=root:root        --chmod=444 src/pkp-ojs/assets/apache-security.conf /etc/apache2/conf.d
COPY --chown=root:root        --chmod=444 src/pkp-ojs/assets/php.app.ini          /usr/local/etc/php/conf.d

COPY --chown=appuser:appgroup --chmod=551 src/pkp-ojs/assets/bin/run.sh /usr/local/bin/run.sh
ADD  --chown=appuser:appgroup --chmod=551 target/pkp-ojs.tar.gz         /var/www/html
