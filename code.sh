#!/bin/sh

export GOPATH=$WORKSPACE
export GO15VENDOREXPERIMENT=1
/go/bin/gocode set package-lookup-mode gb

#ugly hack: vscode-go searches the debugger in the GOPATH/bin directory
#remove this when this is fixed
mkdir -p $WORKSPACE/bin
#ln -sf /go/bin/dlv $WORKSPACE/bin/

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
fi

code $WORKSPACE
