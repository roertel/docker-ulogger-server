FROM nginx:stable

LABEL maintainer="Ryan Oertel (https://github.com/roertel)"

ADD https://github.com/bfabiszewski/ulogger-server/archive/refs/tags/v1.2.zip /usr/share/nginx/html

RUN rm -rf /usr/share/nginx/html/.docker \
  /usr/share/nginx/html/.githooks \
  /usr/share/nginx/html/.github \
  /usr/share/nginx/html/.tests

EXPOSE 80

VOLUME ["/uploads"]
