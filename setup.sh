#!/bin/bash

if [ -x /usr/sbin/nrsysmond ]; then
	echo "newrelic-sysmond already installed"
	exit 0
fi

if [ "$NEWRELIC_LICENSE" = "" ]; then
	read -p "newrelic.com license key: " NEWRELIC_LICENSE
fi

if [ ${#NEWRELIC_LICENSE} != 40 ]; then
	echo "error: invalid license key length"
	exit 1
elif ! [[ $NEWRELIC_LICENSE =~ ^[a-z0-9]+$ ]]; then
	echo "error: license key contains invalid characters"
	exit 1
fi

wget -O /etc/apt/sources.list.d/newrelic.list http://download.newrelic.com/debian/newrelic.list
apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-keys 548C16BF

apt-get update
apt-get install newrelic-sysmond

nrsysmond-config --set license_key=$NEWRELIC_LICENSE
nrsysmond-config --set ssl=true

/etc/init.d/newrelic-sysmond start
