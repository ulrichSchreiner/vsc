FROM ubuntu:18.10
LABEL maintainer "ulrich.schreiner@gmail.com"

ENV GO_VERSION=1.12.2 \
    DOCKER_CLIENT=18.06.1-ce \
    HELM_VERSION=2.9.1 \
    VSC_VERSION=1.33.0 \
    GOSU_VERSION=1.11 \
    RIPGREP_VERSION=0.10.0 \
    KUBEFWD_VERSION=1.8.0 \
    FIRACODE_RELEASE=1.206

RUN apt-get update && apt-get install -y \
	apt-transport-https \
	bc \
	build-essential \
	ca-certificates \
	curl \
	dbus \
	dbus-x11 \
	desktop-file-utils \
	direnv \
	firefox \
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
	python-pip \
	sudo \
	unzip \
	vim \
	wget \
	xdg-utils \
	xz-utils \
	zlib1g \
	zsh && \
  apt-get clean && rm -rf /var/lib/apt/*

RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb

RUN cd /tmp && wget -r -l1 --no-parent -A "code_${VSC_VERSION}-*.deb" -q https://packages.microsoft.com/repos/vscode/pool/main/c/code/ \
    && curl -sSL https://github.com/BurntSushi/ripgrep/releases/download/0.10.0/ripgrep_0.10.0_amd64.deb >/tmp/ripgrep.deb \
    && curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
    && echo 'deb https://deb.nodesource.com/node_10.x bionic main' > /etc/apt/sources.list.d/nodesource.list \
    && mkdir -p /usr/local/share/fonts/firacode \
    && curl -sSL https://github.com/tonsky/FiraCode/blob/${FIRACODE_RELEASE}/distr/ttf/FiraCode-Regular.ttf?raw=true -o /usr/local/share/fonts/firacode/FiraCode-Regular.ttf \
    && pip install pylint \
    && apt-get update \
    && apt-get install -y \
      nodejs \
      --no-install-recommends \
    && apt-get clean \
    && dpkg -i /tmp/packages.microsoft.com/repos/vscode/pool/main/c/code/code_${VSC_VERSION}*.deb \
    && dpkg -i /tmp/ripgrep.deb \
    && wget -O ~/vsls-reqs https://aka.ms/vsls-linux-prereq-script && chmod +x ~/vsls-reqs && ~/vsls-reqs \
    && rm -rf /var/lib/apt/* /tmp/* /var/tmp/* \
    && curl https://download.docker.com/linux/static/edge/x86_64/docker-${DOCKER_CLIENT}.tgz | tar -C /usr/local/bin -xz --strip 1 \
    && curl https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar -C /usr/local/bin -xz --strip 1 \
    && curl -sSL https://github.com/txn2/kubefwd/releases/download/1.8.0/kubefwd_linux_amd64.tar.gz | tar -C /usr/local/bin -xz \
    && chown root:root /usr/local/bin/kubefwd && chmod u+s /usr/local/bin/kubefwd \
    && curl https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz |tar -C /usr/local -xz \
    && ln -sf /usr/local/go/bin/* /usr/bin/ \
    && mkdir /devhome \
    && curl -sSL https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git /devhome/.oh-my-zsh \
    && cd /devhome && git clone --depth=1 https://github.com/powerline/fonts.git \
    && cd /devhome/fonts \
    && HOME=/devhome ./install.sh \
    && cd .. \
    && rm -rf font

ADD installGoTools.py /tmp/
RUN mkdir /go && cd /go && mkdir src pkg bin \
    && GOPATH=/go python3 -u /tmp/installGoTools.py \
    && GOPATH=/go /go/bin/gometalinter --install \
    && curl -o /usr/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture)" \
    && chmod +x /usr/bin/gosu \
    && ln -sf /go/bin/* /usr/bin/ \
    && rm -rf /go/pkg/* && rm -rf /go/src/*

COPY startup.sh /usr/local/bin/startup.sh
COPY code.sh /usr/local/bin/code.sh
COPY projectsettings.json /devhome/projectsettings.json
COPY zshrc /devhome/zshrc
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

ENV SHELL /usr/bin/zsh
VOLUME /work

ENTRYPOINT [ "/usr/local/bin/startup.sh" ]
