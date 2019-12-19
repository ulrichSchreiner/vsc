FROM ubuntu:19.10
LABEL maintainer "ulrich.schreiner@gmail.com"

ENV FIRACODE_RELEASE=1.206 \
    GOSU_VERSION=1.11

ARG CODE_START=/usr/bin/code
ARG VSC_EXT
ARG VSC_URL

ENV CODE_ENTRY=${CODE_START}
ENV VSC_EXT=${VSC_EXT}

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    apt-transport-https \
    bc \
    ca-certificates \
    curl \
    dbus \
    dbus-x11 \
    desktop-file-utils \
    direnv \
    docker.io \
    docker-compose \
    firefox \
    fonts-powerline \
    gcc \
    gettext \
    git \
    gnome-keyring \
    gnupg \
    gnupg2 \
    kmod \
    less \
    libasound2 \
    libc6-dev \
    libcurl4 \
    libgtk2.0-0 \
    libgconf-2-4 \
    libgles2-mesa \
    libicu?? \
    libkrb5-3 \
    libnotify-bin \
    libxtst6 \
    libnss3 \
    libglu1-mesa \
    libsecret-1-0 \
    libssl1.?.? \
    liblttng-ust0 \
    libpcap-dev \
    libunwind8 \
    libuuid1 \
    libxkbfile1 \
    libxss1 \
    locales \
    lsof \
    mercurial \
    openssh-client \
    sudo \
    tmux \
    tzdata \
    unzip \
    vim \
    wget \
    xdg-utils \
    xz-utils \
    zlib1g \
    zsh \
    && apt-get clean && rm -rf /var/lib/apt/*

RUN curl -sSL ${VSC_URL} >/tmp/code.deb \
    && mkdir -p /usr/local/share/fonts/firacode \
    && curl -sSL https://github.com/tonsky/FiraCode/blob/${FIRACODE_RELEASE}/distr/ttf/FiraCode-Regular.ttf?raw=true -o /usr/local/share/fonts/firacode/FiraCode-Regular.ttf \
    && git clone https://github.com/powerline/fonts.git /usr/local/share/fonts/powerline \
    && fc-cache -f /usr/local/share/fonts/ \
    && dpkg -i /tmp/code.deb

COPY startup.sh /usr/local/bin/startup.sh
COPY code.sh /usr/local/bin/code.sh
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
ENTRYPOINT [ "/usr/local/bin/startup.sh" ]
