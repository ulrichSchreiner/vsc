#!/bin/bash

groupadd -g $HOSTGROUPID $HOSTGROUP
useradd $HOSTUSER -u $HOSTUSERID -g $HOSTGROUP -M -d /devhome
chown -R $HOSTUSER:$HOSTGROUP /devhome

su - $HOSTUSER -c /usr/local/bin/code.sh

