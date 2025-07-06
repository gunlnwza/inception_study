FROM    debian:bullseye

WORKDIR /app

RUN apt-get update && \
    apt-get install -y openssl && \ 
    apt-get install -y nginx-full && \ 
    rm -rf /var/lib/aft/lists/* 

RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html

COPY ./default.conf /etc/nginx/conf.d/default.conf

COPY entrypoint.nginx.sh /entrypoint.nginx.sh

RUN chmod +x /entrypoint.nginx.sh 


RUN chown -R www-data:www-data /var/www/html

# COPY test.html /var/www/html/test.html


# CMD ["/bin/bash"]
# CMD ["nginx", "-g", "daemon off;"]
ENTRYPOINT ["/entrypoint.nginx.sh"]

