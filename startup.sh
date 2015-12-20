#!/bin/bash

locale-gen $LANG

groupadd -g $HOSTGROUPID $HOSTGROUP
useradd $HOSTUSER -u $HOSTUSERID -g $HOSTGROUP -G video -M -d /devhome
chown -R $HOSTUSER:$HOSTGROUP /devhome

if [ "$1" == "cleanconfig" ]; then
  echo Clean configuration in /config/vsc$WORKSPACE
  rm -rf /config/vsc$WORKSPACE
fi

if [ ! -d "/config/vsc$WORKSPACE" ]; then
  gosu $HOSTUSER bash -c "mkdir -p /config/vsc$WORKSPACE"
fi
ln -s /config/vsc$WORKSPACE /devhome/.config

screen gosu $HOSTUSER dbus-launch /usr/local/bin/code.sh "$@"
