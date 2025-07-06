FROM debian:bullseye

RUN     apt update -y && \
        apt install -y vsftpd \
        gettext \
        ftp

COPY  /entrypoint.ftp.sh /

RUN  chmod +x /entrypoint.ftp.sh

COPY  /vsftpd.conf.template /etc/vsftpd.conf.template


# ENTRYPOINT ["sleep", "infinity"]
ENTRYPOINT ["/entrypoint.ftp.sh"]
