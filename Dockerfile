FROM php:5.6-apache

MAINTAINER pc_magas@openmailbox.org
EXPOSE 80

RUN apt-get update && apt-get install -y \
      libjpeg-dev \
      libfreetype6-dev \
      libgeoip-dev \
      libpng12-dev \
      libldap2-dev \
      zip \
      mysql-client \
 && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype-dir=/usr --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
 	&& docker-php-ext-install -j$(nproc) gd mbstring mysql pdo_mysql zip ldap opcache

RUN pecl install APCu geoip

ENV PIWIK_VERSION 3.0.1

RUN curl -fsSL -o piwik.tar.gz \
      "https://builds.piwik.org/piwik-${PIWIK_VERSION}.tar.gz" \
 && curl -fsSL -o piwik.tar.gz.asc \
      "https://builds.piwik.org/piwik-${PIWIK_VERSION}.tar.gz.asc" \
 && export GNUPGHOME="$(mktemp -d)" \
 && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 814E346FA01A20DBB04B6807B5DBD5925590A237 \
 && gpg --batch --verify piwik.tar.gz.asc piwik.tar.gz \
 && rm -r "$GNUPGHOME" piwik.tar.gz.asc \
 && tar -xzf piwik.tar.gz -C /usr/src/ \
 && rm piwik.tar.gz

COPY php.ini /usr/local/etc/php/php.ini

RUN curl -fsSL -o /usr/src/piwik/misc/GeoIPCity.dat.gz http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz \
 && gunzip /usr/src/piwik/misc/GeoIPCity.dat.gz

COPY docker-entrypoint.sh /entrypoint.sh

# WORKDIR is /var/www/html (inherited via "FROM php")
# "/entrypoint.sh" will populate it at container startup from /usr/src/piwik
VOLUME /var/www/html

ENV PIWIK_DB_HOST ""
ENV PIWIK_DB_PORT "3306"
ENV PIWIK_DB_USER ""
ENV PIWIK_DB_PASSWORD ""
ENV PIWIK_DB_NAME "piwik"

#Create backup and restore foolders
RUN mkdir /var/backup && \
chmod 665 /var/backup && \
mkdir /var/restore && \
chmod 665 /var/restore

#Export Backup Folder
VOLUME /var/backup

#Export restore foolder
VOLUME /var/restore

COPY backup.php /tmp/backup.php

RUN cp /tmp/backup.php /usr/local/bin/piwik_backup && \
chown root:root /usr/local/bin/piwik_backup && \
chmod 733 /usr/local/bin/piwik_backup && \
rm -rf /tmp/backup

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
