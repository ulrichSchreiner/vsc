#!/bin/sh

export XAUTHORITY=/.XAUTHORITY

WORKDIR=""

mkdir -p $WORKSPACE/.vscode
if [ ! -f $WORKSPACE/.vscode/settings.json ]; then
    cp /devhome/projectsettings.json $WORKSPACE/.vscode/settings.json
    WORKDIR="$WORKSPACE"
fi

echo 0 | ${CODE_ENTRY} --install-extension ms-vscode.Go
echo 0 | ${CODE_ENTRY} --install-extension haaaad.ansible
echo 0 | ${CODE_ENTRY} --install-extension donjayamanne.githistory
echo 0 | ${CODE_ENTRY} --install-extension PeterJausovec.vscode-docker
echo 0 | ${CODE_ENTRY} --install-extension waderyan.gitblame
echo 0 | ${CODE_ENTRY} --install-extension eamodio.gitlens
echo 0 | ${CODE_ENTRY} --install-extension MS-vsliveshare.vsliveshare
echo 0 | ${CODE_ENTRY} --install-extension MS-vsliveshare.vsliveshare-pack
echo 0 | ${CODE_ENTRY} --install-extension humao.rest-client

export GOPATH=${GOPATH:-${WORKSPACE}}

cd $WORKSPACE

${CODE_ENTRY} --verbose $DISABLE_GPU -p $WORKDIR
