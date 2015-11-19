#!/bin/sh

export GOPATH=/go:/work
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

echo $GOPATH

code /work
