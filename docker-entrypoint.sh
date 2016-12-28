#!/bin/bash
set -e

# if [ ! -e piwik.php ]; then
# 	tar cf - --one-file-system -C /usr/src/piwik . | tar xf -
# 	chown -R www-data .
# fi

cp -R /usr/src/piwik/* /var/www/html
chown -R www-data:www-data .

exec "$@"
