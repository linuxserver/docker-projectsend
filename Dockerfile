FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.14

# set version label
ARG BUILD_DATE
ARG VERSION
ARG PROJECTSEND_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="TheSpad"

RUN \
  echo "**** install runtime packages ****" && \
  apk add -U --upgrade --no-cache \
  curl \
  php7-bcmath \
  php7-bz2 \
  php7-cli \
  php7-ctype \
  php7-curl \
  php7-dom \
  php7-fileinfo \
  php7-gd \
  php7-gettext \
  php7-gmp \
  php7-json \
  php7-iconv \
  php7-mbstring \
  php7-mcrypt \
  php7-mysqli \
  php7-openssl \
  php7-pdo \
  php7-pdo_dblib \
  php7-pdo_mysql \
  php7-pecl-apcu \
  php7-pecl-memcached \
  php7-phar \
  php7-soap \
  php7-xmlreader \
  php7-xmlrpc \
  php7-zip \
  unzip && \
  echo "**** install projectsend ****" && \
  mkdir -p /app/projectsend && \
  if [ -z ${PROJECTSEND_VERSION+x} ]; then \
    PROJECTSEND_VERSION=$(curl -sX GET "https://api.github.com/repos/projectsend/projectsend/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -s -o \
    /tmp/projectsend.zip -L \
    "https://github.com/projectsend/projectsend/releases/download/${PROJECTSEND_VERSION}/projectsend-${PROJECTSEND_VERSION}.zip" && \
  unzip \
    /tmp/projectsend.zip -d \
    /app/projectsend && \
  mv /app/projectsend/upload /defaults/ && \
  echo "**** cleanup ****" && \
    rm -rf \
    /tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config /data
