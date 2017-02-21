FROM ubuntu:16.10
MAINTAINER Ulrich Schreiner <ulrich.schreiner@gmail.com>


RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    chromium-browser \
    dbus \
    dbus-x11 \
    curl \
    git \
    gcc \
    kmod \
    mercurial \
    wget \
    unzip \
    openssh-client \
    xdg-utils \
    xz-utils \
    libgtk2.0-0 \
    libgconf-2-4 \
    libasound2 \
    libnotify-bin \
    libxtst6 \
    libnss3 \
    libglu1-mesa \
    --no-install-recommends 

RUN curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN echo 'deb https://deb.nodesource.com/node_7.x yakkety main' > /etc/apt/sources.list.d/nodesource.list
RUN apt-get update && apt-get install -y nodejs --no-install-recommends

ENV GO_VERSION=1.8 \
    GOPATH=/go
RUN curl https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz |tar -C /usr/local -xz \
    && ln -sf /usr/local/go/bin/* /usr/bin/ \
    && mkdir /go && cd /go && mkdir src pkg bin \
    && echo "PATH=/go/bin:$PATH" > /etc/profile.d/go.sh \
    && /usr/local/go/bin/go get \
       github.com/nsf/gocode \
       github.com/derekparker/delve/cmd/dlv \
       github.com/golang/lint/golint \
       github.com/rogpeppe/godef \
       github.com/lukehoban/go-outline \
       sourcegraph.com/sqs/goreturns \
       github.com/tpng/gopkgs \
       github.com/newhook/go-symbols \
       github.com/constabulary/gb/... \
       github.com/cweill/gotests/... \
       golang.org/x/tools/cmd/goimports \
       golang.org/x/tools/cmd/gorename \
       golang.org/x/tools/cmd/guru/serial \
       golang.org/x/tools/go/ast/astutil \
       golang.org/x/tools/go/buildutil \
       golang.org/x/tools/go/types/typeutil \
       golang.org/x/tools/container/intsets \
       golang.org/x/tools/refactor/importgraph \
       golang.org/x/tools/go/ssa \
       golang.org/x/tools/go/loader \
       golang.org/x/tools/go/callgraph \
       golang.org/x/tools/go/ssa/ssautil \
       golang.org/x/tools/go/pointer \
       golang.org/x/tools/go/callgraph/static \
       golang.org/x/tools/cmd/guru \
    && curl -o /usr/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.7/gosu-$(dpkg --print-architecture)" \
    && chmod +x /usr/bin/gosu \
    && ln -sf /go/bin/* /usr/bin/ \
    && rm -rf /go/pkg/* && rm -rf /go/src/* \
    && ln -sf /usr/bin/nodejs /usr/bin/node

ENV VSC_VERSION=1.9.1

# download the deb package
RUN curl -sSL https://vscode-update.azurewebsites.net/${VSC_VERSION}/linux-deb-x64/stable > /tmp/code.deb \
	&& dpkg -i /tmp/code.deb \
	&& rm -rf /tmp/code.deb \
	&& mkdir /devhome \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY startup.sh /usr/local/bin/startup.sh
COPY code.sh /usr/local/bin/code.sh
COPY projectsettings.json /devhome/projectsettings.json
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

ENV SHELL /bin/bash
VOLUME /work
ENTRYPOINT [ "/usr/local/bin/startup.sh" ]
