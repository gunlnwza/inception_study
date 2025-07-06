#!/bin/bash

set -e

mkdir   -p data/

chown   redis:redis /data

exec redis-server /etc/redis/redis.conf --protected-mode no


## to check
## >redis-cli
## KEYS *
## MONITOR