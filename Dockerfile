FROM ubuntu:16.04
MAINTAINER Ulrich Schreiner <ulrich.schreiner@gmail.com>


RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    git \
    gcc \
    mercurial \
    wget \
    unzip \
    openssh-client \
    xdg-utils \
    libgtk2.0-0 \
    libgconf-2-4 \
    libasound2 \
    libnotify-bin \
    libxtst6 \
    libnss3 \
    dbus-x11 \
    screen \
    --no-install-recommends

RUN curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN echo 'deb https://deb.nodesource.com/node_5.x vivid main' > /etc/apt/sources.list.d/nodesource.list
RUN apt-get update && apt-get install -y nodejs --no-install-recommends

ENV GO_VERSION 1.6.2
RUN curl https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz |tar -C /usr/local -xz
RUN ln -sf /usr/local/go/bin/go /usr/bin/go

RUN mkdir /go && cd /go && mkdir src pkg bin
ENV GOPATH /go
RUN echo "PATH=/usr/local/go/bin:/go/bin:$PATH" > /etc/profile.d/go.sh

RUN /usr/local/go/bin/go get \
    github.com/nsf/gocode \
    github.com/derekparker/delve/cmd/dlv \
    github.com/golang/lint/golint \
    github.com/rogpeppe/godef \
    github.com/lukehoban/go-outline \
    sourcegraph.com/sqs/goreturns \
    github.com/tpng/gopkgs \
    github.com/newhook/go-symbols \
    github.com/constabulary/gb/... \
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
    golang.org/x/tools/cmd/guru

RUN curl -o /usr/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.7/gosu-$(dpkg --print-architecture)" && chmod +x /usr/bin/gosu

ENV VSC_VERSION 1.1.1
ENV VSCODE_URL https://vscode-update.azurewebsites.net/latest/linux-x64/stable 

# download the source
RUN curl -sSL ${VSCODE_URL} -o /tmp/vs.zip \
        && unzip /tmp/vs.zip -d /usr/src/ \
        && rm -rf /tmp/vs.zip \
        && ln -snf /usr/src/VSCode-linux-x64/Code /usr/local/bin/code

RUN ln -sf /go/bin/* /usr/bin/
RUN ln -sf /usr/bin/nodejs /usr/bin/node

COPY startup.sh /usr/local/bin/startup.sh
COPY code.sh /usr/local/bin/code.sh
RUN mkdir /devhome
COPY projectsettings.json /devhome/projectsettings.json
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

VOLUME /work
ENTRYPOINT [ "/usr/local/bin/startup.sh" ]
