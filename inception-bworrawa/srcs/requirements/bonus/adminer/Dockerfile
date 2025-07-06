FROM debian:bullseye

RUN     apt-get update -y && \
        apt-get install -y php7.4-fpm && \
        apt-get install -y php7.4-cli && \
        apt-get install -y php7.4-mbstring && \
        apt-get install -y php7.4-xml && \
        apt-get install -y php7.4-curl && \
        apt-get install -y php7.4-json && \
        apt-get install -y php7.4-tokenizer && \
        apt-get install -y php7.4-mysql && \
        apt-get install -y php7.4-pgsql && \
        apt-get install -y php7.4-sqlite3 && \
        apt-get install -y php7.4-odbc && \
        apt-get install -y php7.4-pdo && \
        apt-get install -y wget

RUN     useradd -m -s /bin/bash adminer

COPY    www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY    entrypoint.adminer.sh /

RUN     chmod +x ./entrypoint.adminer.sh 

RUN     mkdir -p /var/www/adminer
RUN     wget -O /var/www/adminer/index.php "https://www.adminer.org/latest.php"
RUN     chmod 755 /var/www/adminer && chown -R adminer:adminer /var/www/adminer/


RUN     mkdir -p /run/php/
RUN     chown -R adminer:adminer /run/php


RUN     ln -s /usr/sbin/php-fpm7.4 /usr/sbin/php-fpm


ENTRYPOINT ["/entrypoint.adminer.sh"]