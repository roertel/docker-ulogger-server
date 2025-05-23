FROM alpine:3

LABEL maintainer="Ryan Oertel (https://github.com/roertel)"
LABEL org.opencontainers.image.source=https://github.com/roertel/docker-ulogger-server
LABEL org.opencontainers.image.description="uLogger container image"
LABEL org.opencontainers.image.licenses=GPL3

ARG ulogger_tag=v1.2
ARG php_version=83

ENV LANG=en_US.utf-8

RUN apk add --no-cache \
  patch \
  nginx \
  sqlite \
  composer \
  php${php_version} \
  php${php_version}-ctype \
  php${php_version}-fpm \
  php${php_version}-json \
  php${php_version}-pdo_sqlite \
  php${php_version}-pdo_mysql \
  php${php_version}-pdo_pgsql \
  php${php_version}-pdo_odbc \
  php${php_version}-session \
  php${php_version}-simplexml \
  php${php_version}-xmlwriter \
  php${php_version}-dom \
  php${php_version}-xml \
  php${php_version}-tokenizer

WORKDIR /var/www/html

ADD --chown=nginx:nginx https://github.com/bfabiszewski/ulogger-server.git#$ulogger_tag .

RUN composer --with-all-dependencies --no-interaction --no-cache --no-progress update

RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
ln -sf /dev/stderr /var/log/nginx/error.log && \
ln -sf /dev/stdout /var/log/php${php_version}/error.log && \
ln -sf /dev/stderr /var/log/php${php_version}/error.log && \
ln -sf /usr/sbin/php-fpm${php_version} /usr/sbin/php-fpm && \
ln -sf /var/www/html/icons/favicon.ico /var/www/html && \
mv /etc/php${php_version} /etc/php && \
ln -sf /etc/php /etc/php${php_version} && \
mkdir -p /var/local/db && \
chown -R nginx:nginx /var/run/nginx /var/local/db

ADD --chown=nginx:nginx /container-files /

RUN patch -p1 < external-auth.patch

RUN rm -rf      \
  .docker       \
  .githooks     \
  .github       \
  .tests        \
  Dockerfile    \
  Changelog     \
  README.md     \
  composer.lock \
  composer.json \
  LICENSE       \
  index.html    \
  external-auth.patch

RUN chmod 0755 /docker-entrypoint.sh /docker-entrypoint.d/*

ENV ULOGGER_dbdsn sqlite:/var/local/db/ulogger.db

USER nginx

EXPOSE 8080

VOLUME ["/var/www/html/uploads", "/var/local/db"]

CMD ["/docker-entrypoint.sh"]
