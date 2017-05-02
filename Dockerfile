FROM lsiobase/alpine:3.5
MAINTAINER sparklyballs

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# install packages
RUN \
 apk add --no-cache \
	apache2 \
	apache2-utils \
	curl \
	php5-apache2 \
	php5-apcu \
	php5-bcmath \
	php5-bz2 \
	php5-cli \
	php5-ctype \
	php5-curl \
	php5-dom \
	php5-gd \
	php5-gettext \
	php5-gmp \
	php5-iconv \
	php5-json \
	php5-mcrypt \
	php5-memcache \
	php5-mssql \
	php5-mysql \
	php5-odbc \
	php5-openssl \
	php5-pdo \
	php5-pdo_dblib \
	php5-pdo_mysql \
	php5-pdo_odbc \
	php5-phar \
	php5-soap \
	php5-xcache \
	php5-xmlreader \
	php5-xmlrpc \
	php5-zip \
	tar \
	wget && \

# configure apache2
 sed -i \
	-e 's#User apache#User abc#g' \
	-e 's#Group apache#Group abc#g' \
	-e 's#AllowOverride none#AllowOverride All#' \
	-e 's/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/' \
		/etc/apache2/httpd.conf && \
 sed -i 's#PidFile "/run/.*#Pidfile "/var/run/apache2/httpd.pid"#g'  /etc/apache2/conf.d/mpm.conf && \

# install projectsend
 rm /var/www/localhost/htdocs/index.html && \
 curl -o \
 tmp/ProjectSend.tar.gz -L \
	"https://codeload.github.com/ignacionelson/ProjectSend/tar.gz/r756" && \
 tar -zxf \
	/tmp/ProjectSend.tar.gz --strip-components=1 -C /var/www/localhost/htdocs/ && \
 mv /var/www/localhost/htdocs/upload /defaults/ && \
 mv /var/www/localhost/htdocs/img/custom /defaults/  && \
 mv /var/www/localhost/htdocs/includes/sys.config.sample.php /defaults/sys.config.php && \

# cleanup
 rm -rf \
	/tmp/*

# add local files
COPY root/ /
