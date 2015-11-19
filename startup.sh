#!/bin/bash

groupadd -g $HOSTGROUPID $HOSTGROUP
useradd $HOSTUSER -u $HOSTUSERID -g $HOSTGROUP -m -d /devhome
#chown -R $HOSTUSER:$HOSTGROUP /devhome

su - $HOSTUSER -c code

