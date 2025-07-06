#!/bin/bash

if [ ! -f /etc/nginx/ssl/nginx.crt ]; then
    mkdir -p /etc/nginx/ssl
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out /etc/nginx/ssl/nginx.crt \
        -subj "/CN=*.$DOMAIN_NAME"
fi

if [ ! -f /etc/nginx/ssl/nginx_lh.crt ]; then
    mkdir -p /etc/nginx/ssl
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/nginx_lh.key \
        -out /etc/nginx/ssl/nginx_lh.crt \
        -subj "/CN=localhost"
fi


echo "Staring nginx service..."

exec nginx -g 'daemon off;'
