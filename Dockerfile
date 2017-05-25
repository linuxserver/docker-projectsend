FROM lsiobase/alpine:3.5
MAINTAINER sparklyballs

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# add repositories
RUN \
 echo "@3.5  http://dl-cdn.alpinelinux.org/alpine/v3.5/main" >> /etc/apk/repositories && \

# install packages
 apk add --no-cache \
	apache2 \
	apache2-utils \
	curl \
	php5-apache2@3.5 \
	php5-apcu@3.5 \
	php5-bcmath@3.5 \
	php5-bz2@3.5 \
	php5-cli@3.5 \
	php5-ctype@3.5 \
	php5-curl@3.5 \
	php5-dom@3.5 \
	php5-gd@3.5 \
	php5-gettext@3.5 \
	php5-gmp@3.5 \
	php5-iconv@3.5 \
	php5-json@3.5 \
	php5-mcrypt@3.5 \
	php5-memcache@3.5 \
	php5-mssql@3.5 \
	php5-mysql@3.5 \
	php5-odbc@3.5 \
	php5-openssl@3.5 \
	php5-pdo_dblib@3.5 \
	php5-pdo@3.5 \
	php5-pdo_mysql@3.5 \
	php5-pdo_odbc@3.5 \
	php5-phar@3.5 \
	php5-soap@3.5 \
	php5-xcache@3.5 \
	php5-xmlreader@3.5 \
	php5-xmlrpc@3.5 \
	php5-zip@3.5 \
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
 cp /var/www/localhost/htdocs/includes/sys.config.sample.php /defaults/sys.config.php && \

# cleanup
 rm -rf \
	/tmp/*

# add local files
COPY root/ /
