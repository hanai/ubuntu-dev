FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive
ENV NODE_VERSION 16.17.1

#RUN sed -i 's|http:\/\/ports.ubuntu.com|http:\/\/mirrors.aliyun.com|g' /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    locales \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8
ENV LC_ALL=$LANG

RUN apt-get update && apt-get install -y --no-install-recommends \
    g++ \
    gcc \
    git \
    tar \
    vim \
    zsh \
    curl \
    htop \
    less \
    llvm \
    lsof \
    make \
    sudo \
    wget \
    patch \
    dialog \
    openssl \
    iproute2 \
    iputils-ping \
    openssh-server \
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
    && nvm cache clear \
    && corepack enable \
    && node --version \
    && npm --version \
    && yarn --version

ENV PY_VERSION 3.10.8
ENV PYENV_ROOT "/home/dev/.pyenv"
ENV PATH "$PYENV_ROOT/bin:${PATH}"
RUN bash -c "$(curl -fsSL https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer)" \
    && echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc \
    && echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc \
    && echo 'eval "$(pyenv init -)"' >> ~/.bashrc

USER root

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 22
