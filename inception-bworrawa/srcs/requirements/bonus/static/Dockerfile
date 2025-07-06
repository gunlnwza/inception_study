FROM    debian:bullseye

RUN     apt-get update && apt-get install -y lighttpd


RUN     mkdir -p /var/www/html

COPY    ./html/* /var/www/html
RUN     chown -R 1000:1000 /var/www/html
RUN     chmod -R 777 /var/www/html

COPY    ./lighttpd.conf /etc/lighttpd/

EXPOSE 8081

# apt-install -y procps 
# apt-install inetutils-ping
# CMD  ["sleep", "infinity"]

ENTRYPOINT ["lighttpd", "-D" , "-f", "/etc/lighttpd/lighttpd.conf"]