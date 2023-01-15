# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.17

# set version label
ARG BUILD_DATE
ARG VERSION
ARG PROJECTSEND_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="TheSpad"

RUN \
  echo "**** install runtime packages ****" && \
  apk add -U --upgrade --no-cache \
  php81-bcmath \
  php81-bz2 \
  php81-cli \
  php81-ctype \
  php81-curl \
  php81-dom \
  php81-fileinfo \
  php81-gd \
  php81-gettext \
  php81-gmp \
  php81-iconv \
  php81-json \
  php81-mbstring \
  php81-mysqli \
  php81-openssl \
  php81-pdo \
  php81-pdo_dblib \
  php81-pdo_mysql \
  php81-pecl-apcu \
  php81-pecl-memcached \
  php81-phar \
  php81-soap \
  php81-xmlreader \
  php81-zip && \
  apk add --no-cache \
    --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    php81-pecl-xmlrpc && \
  echo "**** install projectsend ****" && \
  mkdir -p /app/www/public && \
  if [ -z ${PROJECTSEND_VERSION+x} ]; then \
    PROJECTSEND_VERSION=$(curl -s https://api.github.com/repos/projectsend/projectsend/releases/latest | jq -r '. | .tag_name'); \
  fi && \
  curl -s -o \
    /tmp/projectsend.zip -L \
    "https://github.com/projectsend/projectsend/releases/download/${PROJECTSEND_VERSION}/projectsend-${PROJECTSEND_VERSION}.zip" && \
  unzip \
    /tmp/projectsend.zip -d \
    /app/www/public && \
  mv /app/www/public/upload /defaults/ && \
  mv /app/www/public /app/www/public-tmp && \
  echo "**** cleanup ****" && \
    rm -rf \
    /tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config
