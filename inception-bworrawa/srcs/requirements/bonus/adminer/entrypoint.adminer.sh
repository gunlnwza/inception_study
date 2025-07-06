#!/bin/bash
set -e

touch   /var/log/php7.4-fpm.log
chown   adminer:adminer /var/log/php7.4-fpm.log

exec su -c "php-fpm --nodaemonize" adminer

# exec sleep infinity