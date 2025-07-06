#!/bin/bash
set -e

mariadb_wp_user=$(cat /run/secrets/mariadb_wp_user)
mariadb_wp_password=$(cat /run/secrets/mariadb_wp_password)

wp_admin_user=$(cat /run/secrets/wp_admin_user)
wp_admin_password=$(cat /run/secrets/wp_admin_password)
wp_admin_email=$(cat /run/secrets/wp_admin_email)

wp_author_user=$(cat /run/secrets/wp_author_user)
wp_author_password=$(cat /run/secrets/wp_author_password)
wp_author_email=$(cat /run/secrets/wp_author_email)


# Ensure MySQL is ready before proceeding
echo "Checking if MySQL is ready..."
until mysql -h mariadb -u"$mariadb_wp_user" -p"$mariadb_wp_password" -e "SELECT 1;" &>/dev/null; do
    echo -n "."
    sleep 1
done

# Fix permissions for WP-CLI
chmod -R 755 /usr/local/bin/wp-cli.phar

# # Check if wp-config.php exists
if [ ! -f /var/www/html/.setup-complete ]; then

    echo "Creating wp-config.php..."
    wp-cli.phar core config --allow-root --path=/var/www/wp \
        --dbname="$MARIADB_DATABASE" \
        --dbuser="$mariadb_wp_user" \
        --dbpass="$mariadb_wp_password" \
        --dbhost=mariadb

    echo "Installing WordPress...with 2 users"
    wp-cli.phar core install --allow-root \
        --path=/var/www/wp \
        --url="https://$DOMAIN_NAME" \
        --title="$WP_PAGE_TITLE" \
        --admin_user="$wp_admin_user" \
        --admin_password="$wp_admin_password" \
        --admin_email="$wp_admin_email" 

    wp-cli.phar user create --allow-root \
        "$wp_author_user" "$wp_author_email" \
        --path=/var/www/wp \
        --role=author \
        --user_pass="$wp_author_password"
        

    echo "Adding redis constants to wp-config"
    if ! grep -q "WP_REDIS_HOST" /var/www/wp/wp-config.php; then
        sed -i "/\/\* That's all, stop editing! Happy publishing. \*\//i define('WP_REDIS_HOST', 'redis');\ndefine('WP_REDIS_PORT', $REDIS_PORT);\n" /var/www/wp/wp-config.php
    fi

    echo "install redis plugins"
    wp-cli.phar plugin --allow-root --path=/var/www/wp install redis-cache 
    rsync --quiet -av --remove-source-files /var/www/wp/ /var/www/html/    

    until redis-cli -h "redis" -p "$REDIS_PORT" ping | grep -q PONG; do
        echo "Waiting for Redis to be ready..."
        sleep 1
    done


    if ! wp-cli.phar redis status --allow-root --path=/var/www/html | grep -q "Status: Connected"; then
        wp-cli.phar plugin activate redis-cache --allow-root --path=/var/www/html
        echo "*** redis Plugin activation done"
        wp-cli.phar redis enable --allow-root --path=/var/www/html
        echo "*** redis plugin enable done"
    else 
        echo "skipping redis activation"    
    fi


    chown -R wpuser:wpuser /var/www/html
    chmod -R 755 /var/www/html

    touch /var/log/php7.4-fpm.log
    chown wpuser:wpuser /var/log/php7.4-fpm.log
    chmod 755 /var/log
    chmod 644 /var/log/php7.4-fpm.log
fi 


# create a flag file
touch /var/www/html/.setup-complete

## Start the WordPress FPM service
exec su -c "php-fpm --nodaemonize" wpuser

# [NOTE] to ping redis service:
# redis-cli -h redis ping 