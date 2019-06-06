#!/bin/bash

locale-gen $LANG
su $HOSTUSER /usr/local/bin/code.sh "$@"
