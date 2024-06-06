# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.20

# set version label
ARG BUILD_DATE
ARG VERSION
ARG PROJECTSEND_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="TheSpad"

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    php83-bcmath \
    php83-bz2 \
    php83-cli \
    php83-dom \
    php83-gd \
    php83-gettext \
    php83-gmp \
    php83-mysqli \
    php83-pdo \
    php83-pdo_dblib \
    php83-pdo_mysql \
    php83-pecl-apcu \
    php83-pecl-mcrypt \
    php83-pecl-memcached \
    php83-soap \
    php83-xmlreader && \
  echo "**** install projectsend ****" && \
  mkdir -p /app/www/public && \
  if [ -z ${PROJECTSEND_VERSION+x} ]; then \
    PROJECTSEND_VERSION=$(curl -s https://api.github.com/repos/projectsend/projectsend/releases/latest | jq -r '. | .tag_name'); \
  fi && \
  curl -fso \
    /tmp/projectsend.zip -L \
    "https://github.com/projectsend/projectsend/releases/download/${PROJECTSEND_VERSION}/projectsend-${PROJECTSEND_VERSION}.zip" || \
  curl -fso \
    /tmp/projectsend.zip -L \
    "https://github.com/projectsend/projectsend/releases/download/${PROJECTSEND_VERSION}/projectsend.zip" && \
  unzip \
    /tmp/projectsend.zip -d \
    /app/www/public && \
  mv /app/www/public/upload /defaults/ && \
  mv /app/www/public /app/www/public-tmp && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** cleanup ****" && \
    rm -rf \
    /tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config
