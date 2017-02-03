# Piwik

[![Build Status](https://travis-ci.org/piwik/docker-piwik.svg?branch=master)](https://travis-ci.org/piwik/docker-piwik)

Piwik is the leading open-source analytics platform that gives you more than just powerful analytics:

- Free open-source software
- 100% data ownership
- User privacy protection
- User-centric insights
- Customisable and extensible

![logo](https://rawgit.com/piwik/docker-piwik/master/logo.svg)

This is the apache variation of the oficial piwik image.

## Build

You can Build this image By

## Runtime

You can run the Piwik container and service like so:

```bash
docker run -d --link some-mysql:db --volume ^local_dir^:/var/www/data --volume ^backup_dir^:/var/backup --volume ^restore_dir^:/var/restore -p ^some_port^:80 piwik
```

This assumes you've already launched a suitable MySQL or MariaDB database container.

You'll now need to use a suitable reverse proxy to access the user interface; which is available on TCP port 9000. Nginx provides the necessary functions for translation between HTTP and FastCGI and you can find a suitable configuration file [here](https://github.com/indiehosters/piwik/blob/master/nginx.conf).

## Piwik Installation

Once you're up and running, you'll arrive at the configuration wizard page. If you're using the compose file, at the `Database Setup` step, please enter the following:

- Database Server: `db` (or the name you specified during the image container)
- Login: `root`
- Password: MYSQL_ROOT_PASSWORD
- Database Name: piwik (or you can choose)

And leave the rest as default.

Then you can continue the installation with the super user.

# Volumes

The Image Exports The following Volumes:

Volume Path | Description
--- | ---
*/var/www/html* | The direstory that piwik data exists. Please DO NOT delete the volume mount point.
*/var/backup* | The directory path that backups are taken.
*/var/restore* | The directory that restored backups are provided.

## GeoIP

This product includes GeoLite data created by MaxMind, available from [http://www.maxmind.com](http://www.maxmind.com).

## Backup and restore

This Image comes with some helpfull utility scripts for backipngup and restoring the database.

### Backup

In order to backup all the required info please follo theese steps:

```bash
docker ps | grep ^piwik container name^ | awk '{print $1}'
docker exec -ti ^id_of_the_container^ bash

#Inside the container run
piwik_backup

```

And inside in the volume that is mounnted on `/var/backup` you will see all the backups.
