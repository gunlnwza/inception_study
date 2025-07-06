FROM    debian:bullseye

ENV     DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y software-properties-common  && \ 
    apt-get install -y mariadb-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


COPY    ./entrypoint.mariadb.sh /
RUN     chmod +x /entrypoint.mariadb.sh

COPY    ./50-server.conf /etc/mysql/mariadb.conf.d/50-server.cnf 

ENTRYPOINT ["/entrypoint.mariadb.sh"]

# CMD ["sleep" , "infinity"]
