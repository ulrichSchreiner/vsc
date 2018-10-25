#!/bin/bash

locale-gen $LANG

groupadd -g $HOSTGROUPID $HOSTGROUP
useradd $HOSTUSER -u $HOSTUSERID -g $HOSTGROUP -G audio,video -M -d /devhome -s /usr/bin/zsh
if [ ! -f /devhome/.zshrc ]; then
  cp /devhome/zshrc /devhome/.zshrc
fi

if [ -S /run/docker.sock ]; then
  dgroup=`stat /run/docker.sock -c "%g"`
  groupadd -g $dgroup docker
  usermod -a -G docker $HOSTUSER
fi

chown -R $HOSTUSER:$HOSTGROUP /devhome

if [ ! -d "/config/vscode" ]; then
  gosu $HOSTUSER bash -c "mkdir -p /config/vscode/.config/Code/User /config/vscode/.vscode/extensions"
fi

ln -s /config/vscode/.config /devhome/.config
ln -s /config/vscode/.vscode /devhome/.vscode

GO111MODULE=${GO111MODULE:-auto} gosu $HOSTUSER /usr/local/bin/code.sh "$@"
