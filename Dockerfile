FROM node:12-alpine

ENV AWS_CLI_VERSION 1.16.83
ENV DOCKER_COMPOSE_VERSION 1.23.2
ENV WATCHMAN_VERSION 4.9.0

RUN set -ex \
    && apk add --no-cache bash git openssl-dev openssh-client ca-certificates curl g++ libc6-compat \
      linux-headers make autoconf automake libtool python3 python3-dev libc6-compat \
    # Upgrade pip
    && python3 -m ensurepip \
    && rm -r /usr/lib/python*/ensurepip \
    && pip3 install --no-cache-dir --upgrade pip setuptools \
    # Install AWS CLI
    && pip3 install awscli==${AWS_CLI_VERSION} \
    && aws --version \
    # Install Docker
    && apk add --no-cache docker \
    # Install Docker Compose
    && pip3 install docker-compose==${DOCKER_COMPOSE_VERSION} \
    # Install Watchman
    && cd /tmp; curl -LO https://github.com/facebook/watchman/archive/v${WATCHMAN_VERSION}.tar.gz \
    && tar xzf v${WATCHMAN_VERSION}.tar.gz; rm v${WATCHMAN_VERSION}.tar.gz \
    && cd watchman-${WATCHMAN_VERSION} \
    && ./autogen.sh; ./configure; make && make install \
    && cd /tmp; rm -rf watchman-${WATCHMAN_VERSION} \
    # Fix Yarn configuration
    && npm config set scripts-prepend-node-path true \
    && yarn --version
RUN yarn global add cypress@latest
