#!/usr/bin/env sh
exit
cd /var/www/html || exit

ULOGGER_setup=1
GATEWAY_INTERFACE="CGI/1.1"
CONTENT_TYPE="application/x-www-form-urlencoded"
REMOTE_HOST=127.0.0.1
HTTP_ACCEPT="text/html"
CONTENT_LENGTH=6
SCRIPT_FILENAME=post.php
REQUEST_URI=/scripts/setup.php
SERVER_PROTOCOL=HTTP/1.1
REDIRECT_STATUS=200
REQUEST_METHOD=POST
SCRIPT_NAME=setup.php
SCRIPT_FILENAME=scripts/setup.php
SERVER_NAME=example.com
POST_DATA="command=setup"
CONTENT_LENGTH="$(printf "%s" "$POST_DATA" | wc -m)"

export ULOGGER_setup GATEWAY_INTERFACE CONTENT_TYPE REMOTE_HOST HTTP_ACCEPT \
  CONTENT_LENGTH SCRIPT_FILENAME REQUEST_URI SERVER_PROTOCOL REDIRECT_STATUS \
  REQUEST_METHOD SCRIPT_NAME SCRIPT_FILENAME SERVER_NAME POST_DATA CONTENT_LENGTH

# Back up the tracks and positions for sqlite
DBTYPE="$(printf "%s" "$ULOGGER_dbdsn" | cut -d: -f1)"
DBFILE="$(printf "%s" "$ULOGGER_dbdsn" | cut -d: -f2)"

if [ "$DBTYPE" = "sqlite" ]; then
  sqlite3 "$DBFILE" ".dump --data-only tracks positions" > "$DBFILE.sql"
fi

# Re-setup the app
printf "%s" $POST_DATA | php-cgi | sed -n 's:.*<span.*>\(.*\)</span>.*:\1:p'

# Add users
if [ -f "users" ]; then
  while IFS= read -r line; do
    POST_DATA="$line"
    CONTENT_LENGTH="$(printf "%s" "$POST_DATA" | wc -m)"

    export POST_DATA CONTENT_LENGTH

    printf "%s" "$POST_DATA" | php-cgi | sed -n 's:.*<span.*>\(.*\)</span>.*:\1:p'
  done < "users"
fi

# Restore the backed up data
if [ -f "$DBFILE.sql" ]; then
  sqlite3 "$DBFILE" "$DBFILE.sql"
fi
