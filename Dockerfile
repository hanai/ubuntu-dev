FROM ubuntu:22.04

RUN export LC_ALL="en_US.UTF-8" && export LANG="en_US.UTF-8" && export TERM="xterm-color"

#RUN sed -i 's|http:\/\/ports.ubuntu.com|http:\/\/mirrors.aliyun.com|g' /etc/apt/sources.list

RUN apt-get update && apt-get install -y --no-install-recommends build-essential openssh-server locales git vim tar wget curl ca-certificates python3-minimal less zsh apt-utils iputils-ping libssl-dev sudo

RUN locale-gen en_US.UTF-8

RUN useradd -m -G adm,users,sudo,audio,video -p $(echo password | openssl passwd -1 -stdin) -s /usr/bin/zsh dev

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 22
