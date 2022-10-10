FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive
ENV NODE_VERSION 16.17.1

#RUN sed -i 's|http:\/\/ports.ubuntu.com|http:\/\/mirrors.aliyun.com|g' /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    locales \
    && locale-gen en_US.UTF-8 \
    && apt-get install -y --no-install-recommends \
    git \
    tar \
    vim \
    zsh \
    curl \
    less \
    sudo \
    wget \
    apt-utils \
    libssl-dev \
    iputils-ping \
    openssh-server \
    build-essential \
    ca-certificates \
    python3-minimal \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -G adm,users,sudo,audio,video -p $(echo password | openssl passwd -1 -stdin) -s /usr/bin/zsh dev

USER dev

RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ENV NVM_DIR "/home/dev/.nvm"
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh)" \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && nvm cache clear

USER root

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 22
