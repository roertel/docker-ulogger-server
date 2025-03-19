FROM alpine:3

LABEL maintainer="Ryan Oertel (https://github.com/roertel)"
LABEL org.opencontainers.image.source=https://github.com/roertel/docker-ulogger-server
LABEL org.opencontainers.image.description="uLogger container image"
LABEL org.opencontainers.image.licenses=GPL3

ARG ulogger_tag=v1.2
ARG php_version=83

ENV LANG=en_US.utf-8

RUN apk add --no-cache \
  nginx \
  sqlite \
  php${php_version}-cgi \
  php${php_version}-ctype \
  php${php_version}-fpm \
  php${php_version}-json \
  php${php_version}-pdo_sqlite \
  php${php_version}-pdo_mysql \
  php${php_version}-pdo_pgsql \
  php${php_version}-pdo_odbc \
  php${php_version}-session \
  php${php_version}-simplexml \
  php${php_version}-xmlwriter

ADD --chown=nginx:nginx https://github.com/bfabiszewski/ulogger-server.git#$ulogger_tag /var/www/html/

RUN rm -rf \
  /var/www/html/.docker       \
  /var/www/html/.githooks     \
  /var/www/html/.github       \
  /var/www/html/.tests        \
  /var/www/html/Dockerfile    \
  /var/www/html/Changelog     \
  /var/www/html/README.md     \
  /var/www/html/composer.lock \
  /var/www/html/composer.json \
  /var/www/html/LICENSE       \
  /var/www/html/index.html

RUN sed -i "s/\$enabled = false;/\$enabled = getenv('ULOGGER_setup');/" /var/www/html/scripts/setup.php && \
  sed -i "/^[[:space:]]*DROP[[:space:]]/ s/^/--/" /var/www/html/scripts/ulogger.*

RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
  ln -sf /dev/stderr /var/log/nginx/error.log && \
  ln -sf /dev/stdout /var/log/php${php_version}/error.log && \
  ln -sf /dev/stderr /var/log/php${php_version}/error.log && \
  ln -sf /usr/sbin/php-fpm${php_version} /usr/sbin/php-fpm && \
  ln -sf /etc/php${php_version} /etc/php && \
  ln -sf /var/www/html/icons/favicon.ico /var/www/html && \
  mkdir -p /var/local/db /docker-entrypoint.d && \
  chown -R nginx:nginx /var/run/nginx /var/local/db

ADD --chown=nginx:nginx /nginx.conf /etc/nginx/http.d/default.conf
ADD --chown=nginx:nginx /php-fpm.conf /etc/php/php-fpm.d/www.conf
ADD --chown=nginx:nginx /config.php /var/www/html
ADD --chmod=0755 docker-entrypoint.sh /
ADD --chmod=0755 setup.sh /docker-entrypoint.d

WORKDIR /var/www/html

ENV ULOGGER_dbdsn sqlite:/var/local/db/ulogger.db

USER nginx

EXPOSE 8080

VOLUME ["/var/www/html/uploads", "/var/local/db"]

CMD ["/docker-entrypoint.sh"]
