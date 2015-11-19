#!/bin/sh

export GOPATH=/work
mkdir -p /work/.vscode/extensions
mkdir -p $HOME/.vscode
ln -snf /work/.vscode/extensions $HOME/.vscode/extensions
cd $HOME/.vscode/extensions
if [ ! -d "$HOME/.vscode/extensions/vscode-go" ]; then
    git clone https://github.com/Microsoft/vscode-go
fi


code /work
