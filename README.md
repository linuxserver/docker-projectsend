[linuxserverurl]: https://linuxserver.io
[forumurl]: https://forum.linuxserver.io
[ircurl]: https://www.linuxserver.io/irc/
[podcasturl]: https://www.linuxserver.io/podcast/
[appurl]: http://www.projectsend.org
[hub]: https://hub.docker.com/r/linuxserver/projectsend/

[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)][linuxserverurl]

The [LinuxServer.io][linuxserverurl] team brings you another container release featuring easy user mapping and community support. Find us for support at:
* [forum.linuxserver.io][forumurl]
* [IRC][ircurl] on freenode at `#linuxserver.io`
* [Podcast][podcasturl] covers everything to do with getting the most from your Linux Server plus a focus on all things Docker and containerisation!

# linuxserver/projectsend
[![](https://images.microbadger.com/badges/version/linuxserver/projectsend.svg)](https://microbadger.com/images/linuxserver/projectsend "Get your own version badge on microbadger.com")[![](https://images.microbadger.com/badges/image/linuxserver/projectsend.svg)](https://microbadger.com/images/linuxserver/projectsend "Get your own image badge on microbadger.com")[![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/projectsend.svg)][hub][![Docker Stars](https://img.shields.io/docker/stars/linuxserver/projectsend.svg)][hub][![Build Status](https://ci.linuxserver.io/buildStatus/icon?job=Docker-Builders/x86-64/x86-64-projectsend)](https://ci.linuxserver.io/job/Docker-Builders/job/x86-64/job/x86-64-projectsend/)

[ProjectSend][appurl] is a self-hosted application that lets you upload files and assign them to specific clients that you create yourself! Secure, private and easy. No more depending on external services or e-mail to send those files!

[![projectsend](http://www.projectsend.org/wp-content/themes/projectsend/img/screenshots.png)][appurl]

## Usage

```
docker create \
  --name=projectsend \
  -v <path to data>:/config \
  -v <path to data>:/data \
  -e PGID=<gid> -e PUID=<uid>  \
  -e MAX_UPLOAD=<5000> \
  -p 80:80 \
  linuxserver/projectsend
```

## Parameters

`The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side. 
For example with a port -p external:internal - what this shows is the port mapping from internal to external of the container.
So -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080
http://192.168.x.x:8080 would show you what's running INSIDE the container on port 80.`



* `-p 80` - the port(s)
* `-v /config` - where to store projectsend config files
* `-v /data` - where to store files to share.
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation
* `-e MAX_UPLOAD` to set maximum upload size (in MB), default if unset is 5000.

It is based on alpine linux with s6 overlay, for shell access whilst the container is running do `docker exec -it projectsend /bin/bash`.

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application

Requires a user and database in either mssql, mysql or mariadb.

On first run go to `<your-ip>/install/make-config.php` and enter your database details.

More info at [ProjectSend][appurl].

## Info

* Shell access whilst the container is running: `docker exec -it projectsend /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f projectsend`

* container version number 

`docker inspect -f '{{ index .Config.Labels "build_version" }}' projectsend`

* image version number

`docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/projectsend`

## Versions

+ **11.06.17:** Fetch version from github.
+ **09.12.17:** Rebase to alpine 3.7.
+ **13.06.17:** Initial Release.
