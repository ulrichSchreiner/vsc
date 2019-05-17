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

echo $HOSTUSER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$HOSTUSER
chmod 0440 /etc/sudoers.d/$HOSTUSER

chown -R $HOSTUSER:$HOSTGROUP /devhome

if [ ! -d "/config/vscode$VSC_EXT/.config" ]; then
  gosu $HOSTUSER bash -c "mkdir -p /config/vscode$VSC_EXT/.config/Code/User"
fi

if [ ! -d "/config/vscode$VSC_EXT/.vscode" ]; then
  gosu $HOSTUSER bash -c "mkdir -p /config/vscode$VSC_EXT/.vscode/extensions"
fi

if [ ! -d "/config/vsc-mozilla" ]; then
  gosu $HOSTUSER bash -c "mkdir -p /config/vsc-mozilla"
fi

ln -s /config/vscode$VSC_EXT/.config /devhome/.config
ln -s /config/vscode$VSC_EXT/.vscode /devhome/.vscode$VSC_EXT
ln -s /config/vsc-mozilla /devhome/.mozilla

GO111MODULE=${GO111MODULE:-auto} gosu $HOSTUSER /usr/local/bin/code.sh "$@"
