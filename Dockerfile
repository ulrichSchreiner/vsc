#FROM jess/chromium
#MAINTAINER Jessica Frazelle <jess@docker.com>
FROM debian:sid
MAINTAINER Jessica Frazelle <jess@docker.com>

#ADD https://dl.google.com/linux/direct/google-talkplugin_current_amd64.deb /src/google-talkplugin_current_amd64.deb

#ADD https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb /src/google-chrome-stable_current_amd64.deb

# Install Chromium
RUN mkdir -p /usr/share/icons/hicolor && \
	apt-get update && apt-get install -y \
	ca-certificates \
	build-essential \
	curl \
	git \
	mercurial \
	fonts-liberation \
	gconf-service \
	hicolor-icon-theme \
	libappindicator1 \
	libasound2 \
	libcanberra-gtk-module \
	libcurl3 \
	libexif-dev \
	libgconf-2-4 \
	libgl1-mesa-dri \
	libgl1-mesa-glx \
	libnspr4 \
	libnss3 \
	libpango1.0-0 \
	libv4l-0 \
	libxss1 \
	libxtst6 \
        libgnome-keyring-dev \
        libgtk2.0-0 \
        libpci3 \
        libxtst6 \
	wget \
	unzip \
	openssh-client \
	xdg-utils \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /src/*.deb

RUN curl -sSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/chrome.deb
RUN dpkg -i /tmp/chrome.deb

COPY local.conf /etc/fonts/local.conf


ENV GO_VERSION 1.5.1
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
    github.com/redefiance/go-find-references \
    github.com/redefiance/go-outline \
    sourcegraph.com/sqs/goreturns \
    github.com/constabulary/gb/...



env vsc_version 0.10.1

# download the source
RUN curl -sSL https://az764295.vo.msecnd.net/public/${vsc_version}-release/VSCode-linux64.zip -o /tmp/vs.zip \
        && unzip /tmp/vs.zip -d /usr/src/ \
        && rm -rf /tmp/vs.zip \
        && ln -snf /usr/src/VSCode-linux-x64/Code /usr/local/bin/code


# install node
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get update && apt-get install -y \
	nodejs \
	npm \
	&& rm -rf /var/lib/apt/lists/* \
	&& npm update -g

RUN ln -sf /go/bin/* /usr/bin/
RUN ln -sf /usr/bin/nodejs /usr/bin/node

COPY startup.sh /usr/local/bin/startup.sh
COPY code.sh /usr/local/bin/code.sh
RUN mkdir /devhome
#WORKDIR $HOME
VOLUME /work
ENTRYPOINT [ "/usr/local/bin/startup.sh" ]

