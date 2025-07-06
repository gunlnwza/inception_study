FROM debian:bullseye


RUN     apt-get update && \
        apt-get install -y wget \
        php7.4-fpm \
        php7.4-mysql \
        php7.4-cli \
        php7.4-common \
        php7.4-curl \
        php7.4-json \
        php7.4-xml \
        php7.4-mbstring \
        php7.4-zip \
        curl \
        default-mysql-client \
        systemctl \
        rsync \
        redis-tools \
        iproute2 \
        git \
        && rm -rf /var/lib/apt/lists/*

WORKDIR /

COPY    ./entrypoint.wordpress.sh /
RUN     chmod +x /entrypoint.wordpress.sh

#COPY    ./redis.wordpress.sh /
#RUN     chmod +x /redis.wordpress.sh

RUN     useradd -m -s /bin/bash wpuser

RUN     mkdir -p /var/www/
RUN     mkdir -p /var/www/html
RUN     mkdir -p /var/www/wp

RUN     mkdir -p /run/php/
RUN     chown -R wpuser:wpuser /run/php

RUN     chown -R wpuser:wpuser /var/www
RUN     chown -R wpuser:wpuser /var/www/html
RUN     chown -R wpuser:wpuser /var/www/wp

RUN     chmod 755 /run/php


RUN     chown wpuser:wpuser /var/log
RUN     chmod 755 /var/log


RUN     ln -s /usr/sbin/php-fpm7.4 /usr/sbin/php-fpm

        
RUN     curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN     chmod +x wp-cli.phar && cp wp-cli.phar /usr/local/bin/wp-cli.phar 

RUN     /usr/local/bin/wp-cli.phar  core download --path=/var/www/wp --allow-root


COPY    ./www.conf /etc/php/7.4/fpm/pool.d/www.conf

ENTRYPOINT ["/entrypoint.wordpress.sh"]

#  redis-cli -h redis ping
