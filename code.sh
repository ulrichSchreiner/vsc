#!/bin/sh

export XAUTHORITY=/.XAUTHORITY

WORKDIR=""

mkdir -p $WORKSPACE/.vscode
if [ ! -f $WORKSPACE/.vscode/settings.json ]; then
    cp /devhome/projectsettings.json $WORKSPACE/.vscode/settings.json
    WORKDIR="$WORKSPACE"
fi

echo 0 | code --install-extension ms-vscode.Go
echo 0 | code --install-extension haaaad.ansible
echo 0 | code --install-extension donjayamanne.githistory
echo 0 | code --install-extension PeterJausovec.vscode-docker
echo 0 | code --install-extension waderyan.gitblame
echo 0 | code --install-extension eamodio.gitlens

export GOPATH=$WORKSPACE
export GO111MODULE=on

cd $WORKSPACE
/usr/bin/code --verbose $DISABLE_GPU -p $WORKDIR
