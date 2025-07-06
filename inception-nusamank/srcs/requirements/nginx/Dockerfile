FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y nginx openssl

COPY ./conf/default.conf /etc/nginx/sites-available/default
COPY ./tools/nginx-init.sh /nginx-init.sh
RUN chmod +x /nginx-init.sh && /nginx-init.sh

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
