#!/bin/bash
port=9000
## ABSOLUTE path to the spawn-fcgi binary
SPAWNFCGI="/usr/bin/spawn-fcgi"
SPAWNPID="$HOME/dev/log/spawn.pid"

## ABSOLUTE path to the PHP binary
FCGIPROGRAM="$HOME/dev/bin/php-cgi"
## TCP port to which to bind on localhost
FCGIPORT="$port"

## number of PHP children to spawn
PHP_FCGI_CHILDREN=3

## maximum number of requests a single PHP process can serve before it is restarted
PHP_FCGI_MAX_REQUESTS=1000

## IP addresses from which PHP should access server connections
FCGI_WEB_SERVER_ADDRS="127.0.0.1"

# allowed environment variables, separated by spaces
ALLOWED_ENV="ORACLE_HOME PATH USER"

## if this script is run as root, switch to the following user
USERID=$USER
GROUPID=$USER


################## no config below this line

if test x$PHP_FCGI_CHILDREN = x; then
  PHP_FCGI_CHILDREN=5
fi

export PHP_FCGI_MAX_REQUESTS
export FCGI_WEB_SERVER_ADDRS

ALLOWED_ENV="$ALLOWED_ENV PHP_FCGI_MAX_REQUESTS FCGI_WEB_SERVER_ADDRS"

if test x$UID = x0; then
  EX="$SPAWNFCGI -p $FCGIPORT -f $FCGIPROGRAM -u $USERID -g $GROUPID -C $PHP_FCGI_CHILDREN -P $SPAWNPID"

else
  EX="$SPAWNFCGI -p $FCGIPORT -f $FCGIPROGRAM -C $PHP_FCGI_CHILDREN -P $SPAWNPID"
fi

# copy the allowed environment variables
E=

for i in $ALLOWED_ENV; do
  E="$E $i=${!i}"
done

# clean the environment and set up a new one
env - $E $EX
