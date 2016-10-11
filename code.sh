#!/bin/sh

export GOPATH=$WORKSPACE
/go/bin/gocode set package-lookup-mode go
/go/bin/gocode set autobuild true

mkdir -p $WORKSPACE/bin

mkdir -p $WORKSPACE/.vscode
if [ ! -f $WORKSPACE/.vscode/settings.json ]; then
    cp /devhome/projectsettings.json $WORKSPACE/.vscode/settings.json
fi

code --install-extension lukehoban.Go
code --install-extension haaaad.ansible
code --install-extension donjayamanne.githistory
code --install-extension vscodevim.vim

/usr/bin/code --verbose -w $WORKSPACE
