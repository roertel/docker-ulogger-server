#!/usr/bin/env sh

if [ "${ULOGGER_ENABLE_SETUP}" = "1" ]; then
  sed -i "s/\$enabled = false;/\$enabled = true;/" /var/www/html/scripts/setup.php;
  echo "ulogger setup script enabled"
  echo "----------------------------"
fi

# show config variables
echo "ulogger configuration"
echo "---------------------"
grep '^\$' /var/www/html/config.php

# start services
nginx
php-fpm -F
