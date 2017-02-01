#!/bin/bash
set -e

if [ ! -e /var/www/html/piwik.php ]; then
  cp -r /usr/src/piwik/* /var/www/html/
	chown -R www-data:www-data .
  chmod +w /var/www/html/config
fi

exec "$@"
