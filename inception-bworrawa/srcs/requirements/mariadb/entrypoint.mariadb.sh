#!/bin/bash

# returns as soon as first fail found
set -e

mariadb_root_password=$(cat /run/secrets/mariadb_root_password)
mariadb_wp_user=$(cat /run/secrets/mariadb_wp_user)
mariadb_wp_password=$(cat /run/secrets/mariadb_wp_password)


echo "check file availibility ?"
# using mysql_install_db if the required driectories weren't there
[ ! -d "/var/lib/mysql/mysql" ] && mysql_install_db

# sometimes this directories weren't there and could cause some error, make sure it exists and has necessary permissions
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld    


echo "it's ok here"

# start basic service & wait til ready 
mysqld_safe &

until mysqladmin ping --silent; do 
    sleep 1
done 


echo "- checking for root access " 

if mysql -u root -e "SELECT 1;" >/dev/null 2>&1; then
    echo "root password has not been changed yet, try updating to secret one ..."
    mysql -uroot -p"" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$mariadb_root_password';"
    mysql -uroot -p"$mariadb_root_password" -e "FLUSH PRIVILEGES;"
    echo "done"
else
    echo "root password is currently not blank, proceed normally"
fi 



echo "- checking if the mariadb service has started " 

DB_EXISTS=$(mysql -u root -p"$mariadb_root_password" -e "SHOW DATABASES LIKE '$MARIADB_DATABASE';")
if [ -z "$DB_EXISTS" ]; then

    echo "DB requires initialize & populate.."
    
    mysql -uroot -p"$mariadb_root_password" -e "CREATE DATABASE IF NOT EXISTS $MARIADB_DATABASE;"
    echo " - done create default database"
    mysql -uroot -p"$mariadb_root_password" -e "CREATE USER IF NOT EXISTS '$mariadb_wp_user'@'%' IDENTIFIED BY '$mariadb_wp_password';"
    echo " - done create default user"
    mysql -uroot -p"$mariadb_root_password" -e "GRANT ALL PRIVILEGES ON $MARIADB_DATABASE.* TO '$mariadb_wp_user'@'%';"
    echo " - done grant privileges"
    mysql -uroot -p"$mariadb_root_password" -e "FLUSH PRIVILEGES;"
    echo "- done flush privileges"
else
    echo "DB was there, skip population"
fi


echo "- shutting down temporary service, try to run in exec mode"
mysqladmin -uroot -p"$mariadb_root_password" shutdown    


exec mysqld_safe