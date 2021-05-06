FROM ghcr.io/linuxserver/baseimage-alpine:3.13

# set version label
ARG BUILD_DATE
ARG VERSION
ARG PROJECTSEND_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

RUN \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	apache2 \
	apache2-utils \
	curl \
	jq \
	php7-apache2 \
	php7-bcmath \
	php7-bz2 \
	php7-cli \
	php7-ctype \
	php7-curl \
	php7-dom \
	php7-gd \
	php7-gettext \
	php7-gmp \
	php7-iconv \
	php7-json \
	php7-mcrypt \
	php7-mysqli \
	php7-odbc \
	php7-openssl \
	php7-pdo \
	php7-pdo_dblib \
	php7-pdo_mysql \
	php7-pdo_odbc \
	php7-pecl-apcu \
	php7-pecl-memcached \
	php7-phar \
	php7-soap \
	php7-xmlreader \
	php7-xmlrpc \
	php7-zip \
	re2c \
	tar \
	unrar \
	unzip \
	wget && \
 echo "**** configure php and apache2 ****" && \
 ln -sf /usr/bin/php7 /usr/bin/php && \
 sed -i \
	-e 's#User apache#User abc#g' \
	-e 's#Group apache#Group abc#g' \
	-e 's#AllowOverride none#AllowOverride All#' \
	-e 's/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/' \
		/etc/apache2/httpd.conf && \
 sed -i 's#PidFile "/run/.*#Pidfile "/var/run/apache2/httpd.pid"#g'  /etc/apache2/conf.d/mpm.conf && \
 echo "**** install projectsend ****" && \
 rm /var/www/localhost/htdocs/index.html && \
 curl -o \
 /tmp/ProjectSend.zip -L \
	"https://www.projectsend.org/download/387/" && \
 unzip \
	/tmp/ProjectSend.zip -d /var/www/localhost/htdocs/ && \
 mv /var/www/localhost/htdocs/upload /defaults/ && \
 #cp /var/www/localhost/htdocs/includes/sys.config.sample.php /defaults/sys.config.php && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config /data
