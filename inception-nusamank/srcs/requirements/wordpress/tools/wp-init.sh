#!/bin/bash

if [ ! -d "/var/www/html" ]; then
  mkdir -p /var/www/html
fi

cd /var/www/html
# chmod -R 755 /var/www/html

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

sed -i '36 s/\/run\/php\/php7.4-fpm.sock/9000/' /etc/php/7.4/fpm/pool.d/www.conf

echo "Waiting for MariaDB..."
until mariadb -h ${DB_HOST} -P 3306 -u ${DB_USER} -p${DB_PASSWORD} -e "SELECT 1" > /dev/null 2>&1; do
  echo "MariaDB is not up yet, retrying..."
  sleep 3
done

echo "MariaDB is up, configuring WordPress..."

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASS=$(cat /run/secrets/wp_admin_pass)
WP_USER_PASS=$(cat /run/secrets/wp_user_pass)

# Check if WordPress is already installed
if ! wp core is-installed --allow-root > /dev/null 2>&1; then
  echo "Cleaning up /var/www/html..."
  rm -rf /var/www/html/*

  echo "Downloading WordPress..."
  wp core download --locale=en_US --allow-root

  echo "Configuring wp-config.php..."

  wp config create --dbname="${DB_NAME}" --dbuser="${DB_USER}" \
    --dbpass="${DB_PASSWORD}" --dbhost="${DB_HOST}" --allow-root

  echo "Installing WordPress..."
  wp core install --url=${INCEPTION_LOGIN}.42.fr --title="My WordPress Site" \
    --admin_user=${WP_ADMIN} --admin_password=${WP_ADMIN_PASS} --admin_email=${WP_ADMIN_EMAIL} --allow-root
else
    echo "WordPress is already installed, skipping download and installation."
fi

if ! wp user get ${WP_USER_NAME} --allow-root > /dev/null 2>&1; then
  echo "Creating user..."
  wp user create ${WP_USER_NAME} ${WP_USER_EMAIL} \
      --user_pass=${WP_USER_PASS} \
      --role=${WP_USER_ROLE} --allow-root
else
  echo "User is already exists."
fi

if ! wp theme is-installed twentytwentyfour --allow-root; then
  echo "Installing theme..."
  wp theme install twentytwentyfour --activate --allow-root
fi



echo "Setting permissions..."
chown -R www-data:www-data /var/www/html
echo "WordPress setup completed!"

echo "Starting PHP-FPM..."
mkdir -p /run/php
/usr/sbin/php-fpm7.4 -F
