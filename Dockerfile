FROM node:14-alpine

ENV DOCKER_COMPOSE_VERSION 1.23.2
ENV WATCHMAN_VERSION 4.9.0

RUN set -ex
RUN apk add --no-cache bash git openssl-dev openssh-client ca-certificates curl g++ libc6-compat \
      linux-headers make autoconf automake libtool python3 python3-dev libc6-compat
    # Upgrade pip
RUN python3 -m ensurepip \
    && rm -r /usr/lib/python*/ensurepip \
    && pip3 install --no-cache-dir --upgrade pip setuptools
    # Install AWS CLI
RUN pip3 install awscli && aws --version
    # Install Docker
RUN apk add --no-cache docker
    # Install Docker Compose
RUN pip3 install docker-compose==${DOCKER_COMPOSE_VERSION}
    # Install Watchman
RUN mkdir -p /usr/local/var/run/watchman
ADD watchman-v2021.02.01.00-linux/bin/watchman /usr/local/bin/
ADD watchman-v2021.02.01.00-linux/lib/libgflags.so.2.2 /usr/local/lib/
ADD watchman-v2021.02.01.00-linux/lib/libglog.so.0 /usr/local/lib/
RUN chmod 755 /usr/local/bin/watchman
RUN chmod 2777 /usr/local/var/run/watchman
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib

RUN npm config set scripts-prepend-node-path true \
    && yarn --version
