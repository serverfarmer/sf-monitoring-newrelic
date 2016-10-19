#!/bin/bash
. /opt/farm/scripts/init

if [ -x /usr/sbin/nrsysmond ]; then
	echo "newrelic-sysmond already installed"
	exit 0
fi

cfg="/etc/local/.config/newrelic.license"

if [ ! -f $cfg ]; then
	if [ "$NEWRELIC_LICENSE" = "" ]; then
		read -p "newrelic.com license key: " NEWRELIC_LICENSE
	fi

	if [ "$NEWRELIC_LICENSE" != "" ]; then
		if [ ${#NEWRELIC_LICENSE} != 40 ]; then
			echo "error: invalid license key length, aborting newrelic-sysmond setup"
			exit 1
		elif ! [[ $NEWRELIC_LICENSE =~ ^[a-z0-9]+$ ]]; then
			echo "error: license key contains invalid characters, aborting newrelic-sysmond setup"
			exit 1
		fi
	fi

	echo -n "$NEWRELIC_LICENSE" >$cfg
	chmod 0600 $cfg
fi

if [ ! -s $cfg ]; then
	echo "skipping newrelic-sysmond configuration (no license key configured)"
	exit 0
fi

if [ "$OSTYPE" = "netbsd" ]; then
	echo "skipping newrelic-sysmond setup, unsupported system"
	exit 0
fi

if [ "$OSTYPE" = "debian" ]; then
	wget -O /etc/apt/sources.list.d/newrelic.list http://download.newrelic.com/debian/newrelic.list
	apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-keys 548C16BF
	apt-get update
	apt-get install newrelic-sysmond
elif [ "$OSTYPE" = "redhat" ]; then
	rpm -Uvh https://download.newrelic.com/pub/newrelic/el5/i386/newrelic-repo-5-3.noarch.rpm
	yum install newrelic-sysmond
fi

license="`cat $cfg`"
nrsysmond-config --set license_key=$license
nrsysmond-config --set ssl=true

/etc/init.d/newrelic-sysmond start
