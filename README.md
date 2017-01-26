# Piwik

[![Build Status](https://travis-ci.org/piwik/docker-piwik.svg?branch=master)](https://travis-ci.org/piwik/docker-piwik)

Piwik is the leading open-source analytics platform that gives you more than just powerful analytics:

- Free open-source software
- 100% data ownership
- User privacy protection
- User-centric insights
- Customisable and extensible

![logo](https://rawgit.com/piwik/docker-piwik/master/logo.svg)

## Runtime

You can run the Piwik container and service like so:

```bash
docker run -d --link some-mysql:db piwik
```

This assumes you've already launched a suitable MySQL or MariaDB database container.

You'll now need to use a suitable reverse proxy to access the user interface; which is available on TCP port 9000. Nginx provides the necessary functions for translation between HTTP and FastCGI and you can find a suitable configuration file [here](https://github.com/indiehosters/piwik/blob/master/nginx.conf).

## Piwik Installation

Once you're up and running, you'll arrive at the configuration wizard page. If you're using the compose file, at the `Database Setup` step, please enter the following:

- Database Server: `db`
- Login: `root`
- Password: MYSQL_ROOT_PASSWORD
- Database Name: piwik (or you can choose)

And leave the rest as default.

Then you can continue the installation with the super user.


## GeoIP

This product includes GeoLite data created by MaxMind, available from [http://www.maxmind.com](http://www.maxmind.com).

## Backup and restore

This Image comes with some helpfull utility scripts for backipngup and restoring the database.

### Backup

In order to backup all the required info please follo theese steps:

```bash
docker ps | grep ^piwik container name^ | awk '{print $1}'
docker exec -ti bash
#Inside the container exec
docker 
```
