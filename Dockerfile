FROM lsiobase/alpine:3.7

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

# copy patches
COPY patches/ /tmp/patches/

# package versions
ARG APCU_VER="4.0.11"
ARG MEMCACHE_VER="3.0.8"
ARG XCACHE_VER="3.2.0"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	autoconf \
	automake \
	bison \
	file \
	flex \
	g++ \
	gawk \
	gcc \
	make \
	php5-dev \
	zlib-dev && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	apache2 \
	apache2-utils \
	curl \
	php5-apache2 \
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
	php5-xmlreader \
	php5-xmlrpc \
	php5-zip \
	re2c \
	tar \
	wget && \
 echo "**** configure php and apache2 ****" && \
 ln -sf /usr/bin/php5 /usr/bin/php && \
 sed -i \
	-e 's#User apache#User abc#g' \
	-e 's#Group apache#Group abc#g' \
	-e 's#AllowOverride none#AllowOverride All#' \
	-e 's/#LoadModule\ rewrite_module/LoadModule\ rewrite_module/' \
		/etc/apache2/httpd.conf && \
 sed -i 's#PidFile "/run/.*#Pidfile "/var/run/apache2/httpd.pid"#g'  /etc/apache2/conf.d/mpm.conf && \
 echo "**** compile php modules ****" && \
 mkdir -p \
	/tmp/apcu-src && \
 curl -o \
 /tmp/apcu.tgz -L \
	"http://pecl.php.net/get/apcu-${APCU_VER}.tgz" && \
 tar xf \
 /tmp/apcu.tgz -C \
	/tmp/apcu-src --strip-components=1 && \
 cd /tmp/apcu-src && \
 phpize5 && \
 ./configure \
	--prefix=/usr \
	--with-php-config=/usr/bin/php-config5 && \
 make && \
 make install && \
 echo "extension=apcu.so" > /etc/php5/conf.d/apcu.ini && \
 mkdir -p \
	/tmp/memcache-src && \
 curl -o \
 /tmp/memcache.tgz -L \
	"http://pecl.php.net/get/memcache-${MEMCACHE_VER}.tgz" && \
 tar xf \
 /tmp/memcache.tgz -C \
	/tmp/memcache-src --strip-components=1 && \
 cd /tmp/memcache-src && \
 patch -p1 -i /tmp/patches/memcache-faulty-inline.patch && \
 phpize5 && \
 ./configure \
	--prefix=/usr \
	--with-php-config=/usr/bin/php-config5 && \
 make && \
 make install && \
 echo "extension=memcache.so" > /etc/php5/conf.d/memcache.ini && \
 mkdir -p \
 /tmp/xcache-src && \
 curl -o \
 /tmp/xcache.tar.gz -L \
	"http://xcache.lighttpd.net/pub/Releases/${XCACHE_VER}/xcache-${XCACHE_VER}.tar.gz" && \
 tar xf \
 /tmp/xcache.tar.gz -C \
	/tmp/xcache-src --strip-components=1 && \
 cd /tmp/xcache-src && \
 phpize5 --clean && \
 phpize5 && \
./configure \
	--enable-xcache \
	--enable-xcache-constant \
	--enable-xcache-coverager \
	--enable-xcache-optimizer \
	--prefix=/usr \
	--with-php-config=/usr/bin/php-config5 && \
 make && \
 make install && \
 install -Dm644 /tmp/patches/xcache.ini /etc/php5/conf.d/xcache.ini && \
 echo "**** install projectsend ****" && \
 rm /var/www/localhost/htdocs/index.html && \
 PROJS_TAG=$(curl -sX GET "https://api.github.com/repos/projectsend/projectsend/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]') && \
 curl -o \
 /tmp/ProjectSend.tar.gz -L \
	"https://github.com/projectsend/projectsend/archive/$PROJS_TAG.tar.gz" && \
 tar -zxf \
	/tmp/ProjectSend.tar.gz --strip-components=1 -C /var/www/localhost/htdocs/ && \
 mv /var/www/localhost/htdocs/upload /defaults/ && \
 mv /var/www/localhost/htdocs/img/custom /defaults/  && \
 cp /var/www/localhost/htdocs/includes/sys.config.sample.php /defaults/sys.config.php && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config /data
