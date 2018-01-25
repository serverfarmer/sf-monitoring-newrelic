#!/bin/bash
. /opt/farm/scripts/init

cfg="/etc/local/.config/newrelic.license"

if [ ! -f $cfg ]; then
	if [ "$NEWRELIC_LICENSE" = "" ]; then
		read -p "newrelic.com license key: " NEWRELIC_LICENSE
	fi

	if [ "$NEWRELIC_LICENSE" != "" ]; then
		if [ ${#NEWRELIC_LICENSE} != 40 ]; then
			echo "error: invalid license key length, aborting"
			exit 1
		elif ! [[ $NEWRELIC_LICENSE =~ ^[a-z0-9]+$ ]]; then
			echo "error: license key contains invalid characters, aborting"
			exit 1
		fi
	fi

	echo -n "$NEWRELIC_LICENSE" >$cfg
	chmod 0600 $cfg
fi
