FROM ubuntu:17.10
LABEL maintainer "ulrich.schreiner@gmail.com"

ENV GO_VERSION=1.10.1 \
    DOCKER_CLIENT=17.12.1-ce \
    GOPATH=/go \
    VSC_VERSION=1.21.1 \
    GOSU_VERSION=1.10

RUN apt-get update && apt-get install -y \
	apt-transport-https \
	build-essential \
	ca-certificates \
	chromium-browser \
	curl \
	dbus \
	dbus-x11 \
	direnv \
	gcc \
	git \
	gnupg \
	gnupg2 \
	kmod \
	less \
	libc6-dev \
	libgtk2.0-0 \
	libgconf-2-4 \
	libasound2 \
	libnotify-bin \
	libxtst6 \
	libnss3 \
	libglu1-mesa \
        libsecret-1-0 \
	libxkbfile1 \
	locales \
	mercurial \
	openssh-client \
	python-pip \
	unzip \
	vim \
	wget \
	xdg-utils \
	xz-utils \
	zsh && \
  apt-get clean && rm -rf /var/lib/apt/*

RUN cd /tmp && wget -r -l1 --no-parent -A "code_${VSC_VERSION}-*.deb" -q https://packages.microsoft.com/repos/vscode/pool/main/c/code/ \
    && curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
    && echo 'deb https://deb.nodesource.com/node_9.x artful main' > /etc/apt/sources.list.d/nodesource.list \
    && curl https://download.docker.com/linux/static/edge/x86_64/docker-${DOCKER_CLIENT}.tgz | tar -C /usr/local/bin -xz --strip 1 \
    && curl https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz |tar -C /usr/local -xz \
    && ln -sf /usr/local/go/bin/* /usr/bin/ \
    && mkdir /go && cd /go && mkdir src pkg bin \
    && echo "PATH=/go/bin:$PATH" > /etc/profile.d/go.sh \
    && /usr/local/go/bin/go get -u -v \
        github.com/derekparker/delve/cmd/dlv \
        github.com/fatih/gomodifytags \
        github.com/tylerb/gotype-live \
        golang.org/x/tools/cmd/goimports \
        github.com/sourcegraph/go-langserver \
        github.com/alecthomas/gometalinter \
        github.com/haya14busa/goplay/cmd/goplay \
        github.com/nsf/gocode \
        github.com/rogpeppe/godef \
        github.com/zmb3/gogetdoc \
        github.com/golang/dep/cmd/dep \
        github.com/golang/lint/golint \
        github.com/ramya-rao-a/go-outline \
        github.com/josharian/impl \
        sourcegraph.com/sqs/goreturns \
        golang.org/x/tools/cmd/gorename \
        github.com/uudashr/gopkgs/cmd/gopkgs \
        github.com/acroca/go-symbols \
        golang.org/x/tools/cmd/guru \
        github.com/cweill/gotests/... \
        golang.org/x/tools/cmd/godoc \
        honnef.co/go/tools/... \
        github.com/davidrjenni/reftools/cmd/fillstruct \
    && /go/bin/gometalinter --install \
    && curl -o /usr/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture)" \
    && chmod +x /usr/bin/gosu \
    && ln -sf /go/bin/* /usr/bin/ \
    && rm -rf /go/pkg/* && rm -rf /go/src/* \
    && mkdir /devhome \
    && mkdir -p /usr/local/share/fonts/firacode \
    && curl -sSL https://github.com/tonsky/FiraCode/raw/master/distr/ttf/FiraCode-Regular.ttf -o /usr/local/share/fonts/firacode/FiraCode-Regular.ttf \
    && pip install pylint \
    && apt-get update \
    && apt-get install -y \
      nodejs \
      --no-install-recommends \
    && apt-get clean \
    && dpkg -i /tmp/packages.microsoft.com/repos/vscode/pool/main/c/code/code_${VSC_VERSION}*.deb \
    && rm -rf /var/lib/apt/* /tmp/* /var/tmp/* \
    && git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git /devhome/.oh-my-zsh \
    && cd /devhome && git clone --depth=1 https://github.com/powerline/fonts.git \
    && cd /devhome/fonts \
    && HOME=/devhome ./install.sh \
    && cd .. \
    && rm -rf fonts

COPY startup.sh /usr/local/bin/startup.sh
COPY code.sh /usr/local/bin/code.sh
COPY projectsettings.json /devhome/projectsettings.json
COPY zshrc /devhome/zshrc
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

ENV SHELL /usr/bin/zsh
VOLUME /work

ENTRYPOINT [ "/usr/local/bin/startup.sh" ]
