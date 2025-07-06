FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    wget \
    gnupg \
    lsb-release \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce-cli

RUN mkdir -p /opt/portainer \
    && curl -L https://github.com/portainer/portainer/releases/download/2.19.1/portainer-2.19.1-linux-amd64.tar.gz -o pt.tar.gz \
    && tar xzf pt.tar.gz -C /opt/portainer --strip-components=1 \
    && rm pt.tar.gz

EXPOSE 8000 9000 

WORKDIR /opt/portainer

VOLUME /data



COPY ./entrypoint.portainer.sh /opt/portainer/

RUN chmod +x /opt/portainer/entrypoint.portainer.sh

ENTRYPOINT ["/opt/portainer/entrypoint.portainer.sh"]