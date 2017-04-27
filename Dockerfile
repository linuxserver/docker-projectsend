FROM lsiobase/alpine.nginx:3.5
MAINTAINER sparklyballs

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# set default root password for database
ENV MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-root}

# install packages
RUN \
 apk add --no-cache \
	curl \
	mariadb \
	mariadb-client \
	tar && \
	apk add --no-cache \
	--repository http://nl.alpinelinux.org/alpine/edge/community \
	php7-pdo_mysql && \

# install projectsend
 mkdir -p \
	/usr/share/webapps/projectsend && \
 PROJECTSEND_VER=$(curl -sX GET "https://api.github.com/repos/ignacionelson/ProjectSend/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]') && \
 curl -o \
 /tmp/projectsend.tar.gz -L \
	"https://github.com/ignacionelson/ProjectSend/archive/${PROJECTSEND_VER}.tar.gz" && \
 tar xf \
 /tmp/projectsend.tar.gz -C \
	/usr/share/webapps/projectsend --strip-components=1 && \

# cleanup
 rm -rf \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80
VOLUME /config
