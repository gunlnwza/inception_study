#!/bin/bash

DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

echo "Starting MariaDB..."
mysqld_safe --skip-grant-tables --datadir=/var/lib/mysql &

until mysqladmin ping --silent; do
    echo "Waiting for MariaDB..."
    sleep 1
done

echo "Setting up database and user..."
mariadb <<EOF
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}'; 
FLUSH PRIVILEGES;
EOF

mysqladmin -u root -p${DB_ROOT_PASSWORD} shutdown

echo "Starting MariaDB in foreground..."
exec mysqld --user=root
