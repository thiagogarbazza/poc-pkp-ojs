FROM alpine:3.16

COPY ojs/assets/exclude.list /tmp

RUN  apk add --no-cache shadow \
  && apk add --no-cache apache2 apache2-ssl apache2-utils \
  && apk add --no-cache php8 php8-apache2 php8-bcmath php8-bz2 php8-calendar php8-ctype php8-curl php8-dom php8-exif php8-fileinfo php8-ftp \
                        php8-gettext php8-iconv php8-intl php8-json php8-mbstring php8-opcache php8-openssl php8-pdo_pgsql php8-pgsql \
                        php8-phar php8-posix php8-session php8-shmop php8-simplexml php8-sockets php8-sysvmsg php8-sysvsem php8-sysvshm \
                        php8-tokenizer php8-xml php8-xmlreader php8-xmlwriter php8-zip php8-zlib \
  # Create user apache
  && usermod -u 1000 apache && groupmod -g 1000 apache \
  # The directory for file uploads.
  && mkdir -m 750 -p /var/www/files \
  && chmod -R 750 /var/www/files \
  && chown -R apache:apache /var/www/files \
  # Remove trash files
  && rm -rf $(cat /tmp/exclude.list)

ADD target/app.tar.gz /var/www/html
COPY ojs/assets/healthcheck.php /var/www/html
COPY ojs/assets/bin /usr/local/bin
COPY ojs/assets/httpd.conf /etc/apache2
COPY ojs/assets/httpd-ojs.conf /etc/apache2/conf.d

WORKDIR /var/www

VOLUME ["/var/www/files", "/var/www/html/public"]

EXPOSE 80 443

CMD ["ojs-start"]
