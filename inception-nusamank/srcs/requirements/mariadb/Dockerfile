FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server && apt-get clean

COPY ./my.cnf /etc/mysql/my.cnf
COPY ./tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 3306
ENTRYPOINT ["/init.sh"]
