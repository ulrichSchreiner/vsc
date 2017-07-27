FROM ubuntu:17.04
LABEL maintainer "ulrich.schreiner@gmail.com"


RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    chromium-browser \
    curl \
    dbus \
    dbus-x11 \
    gcc \
    git \
    kmod \
    mercurial \
    wget \
    unzip \
    openssh-client \
    xdg-utils \
    xz-utils \
    libc6-dev \
    libgtk2.0-0 \
    libgconf-2-4 \
    libasound2 \
    libnotify-bin \
    libxtst6 \
    libnss3 \
    libglu1-mesa \
    libxkbfile1 \
    locales \
    --no-install-recommends && rm -rf /var/lib/apt/*

ENV GO_VERSION=1.8.3 \
    GOPATH=/go \
    VSC_VERSION=1.14.2

RUN curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
    && echo 'deb https://deb.nodesource.com/node_7.x yakkety main' > /etc/apt/sources.list.d/nodesource.list \
    && apt-get update && apt-get install -y nodejs --no-install-recommends \
    && curl https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz |tar -C /usr/local -xz \
    && ln -sf /usr/local/go/bin/* /usr/bin/ \
    && mkdir /go && cd /go && mkdir src pkg bin \
    && echo "PATH=/go/bin:$PATH" > /etc/profile.d/go.sh \
    && /usr/local/go/bin/go get \
	github.com/derekparker/delve/cmd/dlv \
	github.com/fatih/gomodifytags \
	github.com/tylerb/gotype-live \
	golang.org/x/tools/cmd/goimports \
	github.com/sourcegraph/go-langserver \
	github.com/alecthomas/gometalinter \
	github.com/nsf/gocode \
	github.com/rogpeppe/godef \
	github.com/zmb3/gogetdoc \
	github.com/golang/lint/golint \
        github.com/ramya-rao-a/go-outline \
        github.com/josharian/impl \
	sourcegraph.com/sqs/goreturns \
	golang.org/x/tools/cmd/gorename \
	github.com/tpng/gopkgs \
	github.com/acroca/go-symbols \
	golang.org/x/tools/cmd/guru \
	github.com/cweill/gotests/... \
	golang.org/x/tools/cmd/godoc \
	honnef.co/go/tools/cmd/megacheck \
    && /go/bin/gometalinter --install \
    && curl -o /usr/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.7/gosu-$(dpkg --print-architecture)" \
    && chmod +x /usr/bin/gosu \
    && ln -sf /go/bin/* /usr/bin/ \
    && rm -rf /go/pkg/* && rm -rf /go/src/* \
    && ln -sf /usr/bin/nodejs /usr/bin/node \
    && curl -sSL https://vscode-update.azurewebsites.net/${VSC_VERSION}/linux-deb-x64/stable > /tmp/code.deb \
    && dpkg -i /tmp/code.deb \
    && rm -rf /tmp/code.deb \
    && mkdir /devhome \
    && mkdir /usr/local/share/fonts/firacode \
    && curl -sSL https://github.com/tonsky/FiraCode/raw/master/distr/ttf/FiraCode-Regular.ttf -o /usr/local/share/fonts/firacode/FiraCode-Regular.ttf \
    && apt-get clean && rm -rf /var/lib/apt/* /tmp/* /var/tmp/*

COPY startup.sh /usr/local/bin/startup.sh
COPY code.sh /usr/local/bin/code.sh
COPY projectsettings.json /devhome/projectsettings.json
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

ENV SHELL /bin/bash
VOLUME /work
ENTRYPOINT [ "/usr/local/bin/startup.sh" ]
