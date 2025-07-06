FROM debian:bullseye

RUN     apt update -y && \
        apt install -y redis-server && \
        rm -rf /var/lib/apt/lists/*

COPY    /entrypoint.redis.sh /
RUN     chmod +x ./entrypoint.redis.sh


COPY    ./redis.conf /etc/redis/

EXPOSE 6379

ENTRYPOINT ["/entrypoint.redis.sh"]
