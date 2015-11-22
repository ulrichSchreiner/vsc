#!/bin/bash

groupadd -g $HOSTGROUPID $HOSTGROUP
useradd $HOSTUSER -u $HOSTUSERID -g $HOSTGROUP -M -d /devhome
chown -R $HOSTUSER:$HOSTGROUP /devhome

if [ ! -d "/config/vsc$WORKSPACE" ]; then
su $HOSTUSER -c "mkdir -p /config/vsc$WORKSPACE"
fi
ln -s /config/vsc$WORKSPACE /devhome/.config

su $HOSTUSER -c /usr/local/bin/code.sh

