#!/bin/sh

export GOPATH=/work
export GO15VENDOREXPERIMENT=1
/go/bin/gocode set package-lookup-mode gb

mkdir -p /work/.vscode/extensions
mkdir -p /devhome/.vscode

#symlink the extions from the home to the workspace, so every
#workspace has its own extensions
ln -s /work/.vscode/extensions /devhome/.vscode/

# TODO if settings.json does not exist, copy one
cp /devhome/projectsettings.json /work/.vscode/settings.json

cd /work/.vscode/extensions
if [ ! -d "/work/.vscode/extensions/vscode-go" ]; then
    git clone https://github.com/Microsoft/vscode-go
    cd vscode-go
    npm install
    #./node_modules/.bin/tsc
    npm run vscode:prepublish
fi

code /work
