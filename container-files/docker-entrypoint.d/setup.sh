#!/usr/bin/env sh

# Initialize database if needed, add users if none

cd /var/www/html || exit 1

# Update setup script to read from environment variables instead
# of POST or GET variables

sed -i -f - scripts/setup.php <<- SED
  s/^\(\s*\$enabled = \)false;/\1getenv('ULOGGER_setup');/;
  s/^\(\s*\$\(.*\) = \)uUtils::.*;/\1getenv('ULOGGER_\2');/;
SED

echo "Checking installation"
if ! php -r 'if (!defined("ROOT_DIR")) { define("ROOT_DIR", __DIR__); }
  require_once(ROOT_DIR . "/helpers/user.php");
  (uUser::getAll()===false) ? exit(1) : exit(0);'; then

  echo "Configuring uLogger database"
  ULOGGER_command=setup \
  ULOGGER_setup=1 \
  php scripts/setup.php \
  | sed -n '/<p>/,/<\/p>/ s/<[^>]*>//g p'

  if [ -n "$(ls -A /var/run/secrets/users 2>/dev/null)" ]; then
    for file in /var/run/secrets/users/*; do
      if [ -f "${file}" ]; then
        echo "Adding users from ${file}..."

        while read -r ULOGGER_login ULOGGER_pass; do
          echo "Adding user $ULOGGER_login"

          export ULOGGER_login ULOGGER_pass

          ULOGGER_command=adduser \
          ULOGGER_setup=1 \
          php scripts/setup.php \
          | sed -n '/<p>/,/<\/p>/ s/<[^>]*>//g p'
        done < "${file}"

        echo "done"
      else
        echo "Error: ${file} is not a file"
      fi
    done
  else
    echo "Not adding users: No users file found"
  fi
fi

echo "Done!"
