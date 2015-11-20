#!/bin/sh

export GOPATH=/work
export GO15VENDOREXPERIMENT=1
/go/bin/gocode set package-lookup-mode gb

#ugly hack: vscode-go does not support multiple-gopath
#i'd like to put the tools in the PATH or in a second part of the GOPATH so
# these tools won't be visible outside of the container
mkdir -p /work/bin
ln -sf /go/bin/* /work/bin/

mkdir -p /work/.vscode/extensions
mkdir -p $HOME/.vscode
ln -snf /work/.vscode/extensions $HOME/.vscode/extensions
cd $HOME/.vscode/extensions
if [ ! -d "$HOME/.vscode/extensions/vscode-go" ]; then
    git clone https://github.com/Microsoft/vscode-go
    cd vscode-go
    npm install
    ./node_modules/.bin/tsc
fi

code /work
