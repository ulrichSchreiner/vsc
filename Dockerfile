FROM jess/chromium
MAINTAINER Jessica Frazelle <jess@docker.com>
maintainer ulrich.schreiner@gmail.com

RUN apt-get update && apt-get install -y \
        build-essential \
        ca-certificates \
        curl \
        git \
        libasound2 \
        libgconf-2-4 \
        libgnome-keyring-dev \
        libgtk2.0-0 \
        libnss3 \
        libpci3 \
        libxtst6 \
        unzip \
        --no-install-recommends

ENV GO_VERSION 1.5.1
RUN curl https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz |tar -C /usr/local -xz

RUN mkdir /go && cd /go && mkdir src pkg bin
ENV GOPATH /go

RUN /usr/local/go/bin/go get \
    github.com/nsf/gocode \
    github.com/golang/lint/golint \
    golang.org/x/tools/cmd/goimports \
    github.com/rogpeppe/godef \
    golang.org/x/tools/cmd/oracle \
    golang.org/x/tools/cmd/stringer \
    github.com/josharian/impl \
    golang.org/x/tools/cmd/gorename \
    github.com/constabulary/gb/...

RUN echo "PATH=/usr/local/go/bin:/go/bin:$PATH" > /etc/profile.d/go.sh

env vsc_version 0.10.1

# download the source
RUN curl -sSL https://az764295.vo.msecnd.net/public/${vsc_version}-release/VSCode-linux64.zip -o /tmp/vs.zip \
        && unzip /tmp/vs.zip -d /usr/src/ \
        && rm -rf /tmp/vs.zip \
        && ln -snf /usr/src/VSCode-linux-x64/Code /usr/local/bin/code



COPY startup.sh /usr/local/bin/startup.sh
#WORKDIR $HOME

ENTRYPOINT [ "/usr/local/bin/startup.sh" ]

