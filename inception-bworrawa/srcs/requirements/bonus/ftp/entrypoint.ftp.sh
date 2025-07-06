#!/bin/bash
set -e

FTP_USER=$(cat /run/secrets/ftp_user)
FTP_PASSWORD=$(cat /run/secrets/ftp_password)


if ! id "$FTP_USER" &>/dev/null; then

    envsubst < /etc/vsftpd.conf.template > /etc/vsftpd.conf


    # useradd -m -s /bin/bash "$FTP_USER" || log "User already exists."
    useradd -d /home/wpuser/wp-content -s /bin/bash "wpuser"

    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

    chmod 755 "/home/wpuser"

    touch /etc/vsftpd.userlist
    echo "$FTP_USER" > /etc/vsftpd.userlist
    chmod 644 /etc/vsftpd.userlist

    echo "$FTP_USER" > /etc/vsftpd.chroot_list
    chmod 644 /etc/vsftpd.chroot_list


    mkdir -p /var/run/vsftpd/empty

    chmod 755 /var/run/vsftpd/empty

fi  


exec vsftpd

### TO TEST 
### > ftp localhost
### ftp > send 