#!/bin/bash

if [ ! -e piwik.php ]; then
  cp -R /usr/src/piwik/* /var/www/html
  chown -R www-data:www-data .
fi


: ${PIWIK_DB_HOST:=$DB_PORT_3306_TCP_ADDR}
echo "Mariadb Addr:"$DB_PORT_3306_TCP_ADDR
: ${PIWIK_DB_PORT:=${DB_PORT_3306_TCP_PORT}}
COUNTER=0
  echo "Waiting for mysql to start at ${PIWIK_DB_HOST} using port ${PIWIK_DB_PORT}..."
  while ! mysqladmin ping -h"$PIWIK_DB_HOST" -P $PIWIK_DB_PORT --silent; do
    if [ $COUNTER -gt 10 ] ; then
      exit 1
    fi
      echo "Connecting to ${PIWIK_DB_HOST} Failed"
      COUNTER=$[COUNTER+1]
      sleep 1
  done

  echo "Setting up the database connection info"
: ${PIWIK_DB_USER:=${DB_ENV_MYSQL_USER:-root}}
: ${PIWIK_DB_NAME:=${DB_ENV_MYSQL_DATABASE:-'piwik'}}

  if [ "$PIWIK_DB_USER" = 'root' ]; then
: ${PIWIK_DB_PASSWORD:=$DB_ENV_MYSQL_ROOT_PASSWORD}
  else
: ${PIWIK_DB_PASSWORD:=$DB_ENV_MYSQL_PASSWORD}
  fi

if ! mysql -h"$PIWIK_DB_HOST" -P $PIWIK_DB_PORT -u ${PIWIK_DB_USER} -p${PIWIK_DB_PASSWORD}  -e ";" ; then
  echo "The user does not exist to the mysql server: ${PIWIK_DB_HOST}"
  exit 1
fi

php console config:set --section="database" --key="host" --value=${PIWIK_DB_HOST}
php console config:set --section="database" --key="port" --value=${PIWIK_DB_PORT}
php console config:set --section="database" --key="username" --value=${PIWIK_DB_USER}
php console config:set --section="database" --key="password" --value=${PIWIK_DB_PASSWORD}
php console config:set --section="database" --key="tables_prefix" --value="piwik_"

php index.php

exec "$@"
