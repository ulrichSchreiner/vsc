#!/bin/sh

export GOPATH=$WORKSPACE
/go/bin/gocode set package-lookup-mode go
/go/bin/gocode set autobuild true

mkdir -p $WORKSPACE/bin

mkdir -p $HOME/.config/extensions
mkdir -p $HOME/.vscode
ln -snf $HOME/.config/extensions $HOME/.vscode/

mkdir -p $WORKSPACE/.vscode
if [ ! -f $WORKSPACE/.vscode/settings.json ]; then
    cp /devhome/projectsettings.json $WORKSPACE/.vscode/settings.json
fi

cd $HOME/.vscode/extensions
if [ ! -d "$HOME/.vscode/extensions/vscode-go" ]; then
    git clone https://github.com/Microsoft/vscode-go
    cd vscode-go
    npm install
    npm run vscode:prepublish
else
    cd vscode-go
    git pull
    npm install
    npm run vscode:prepublish
fi

/usr/src/VSCode-linux-x64/code $WORKSPACE
