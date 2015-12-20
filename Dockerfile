FROM ubuntu:15.10
MAINTAINER Ulrich Schreiner <ulrich.schreiner@gmail.com>

RUN apt-get update && apt-get install -y \
  ca-certificates \
	curl \
	git \
	gcc \
	mercurial \
	wget \
	unzip \
	openssh-client \
	xdg-utils \
	nodejs npm \
	libgtk2.0-0 \
	libgconf-2-4 \
	libasound2 \
	libxtst6 \
	libnss3 \
	dbus-x11 \
	screen \
	--no-install-recommends

ENV GO_VERSION 1.5.2
RUN curl https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz |tar -C /usr/local -xz
RUN ln -sf /usr/local/go/bin/go /usr/bin/go

RUN mkdir /go && cd /go && mkdir src pkg bin
ENV GOPATH /go
RUN echo "PATH=/usr/local/go/bin:/go/bin:$PATH" > /etc/profile.d/go.sh

RUN /usr/local/go/bin/go get \
    github.com/nsf/gocode \
    github.com/derekparker/delve/cmd/dlv \
    github.com/golang/lint/golint \
    golang.org/x/tools/cmd/goimports \
    github.com/rogpeppe/godef \
    golang.org/x/tools/cmd/oracle \
    golang.org/x/tools/cmd/stringer \
    github.com/josharian/impl \
    golang.org/x/tools/cmd/gorename \
    github.com/lukehoban/go-find-references \
    github.com/lukehoban/go-outline \
    sourcegraph.com/sqs/goreturns \
    github.com/constabulary/gb/...

RUN curl -o /usr/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.7/gosu-$(dpkg --print-architecture)" && chmod +x /usr/bin/gosu

ENV VSC_VERSION 0.10.3

# download the source
RUN curl -sSL https://az764295.vo.msecnd.net/public/${VSC_VERSION}/VSCode-linux64.zip -o /tmp/vs.zip \
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
