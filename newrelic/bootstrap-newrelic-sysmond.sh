#!/usr/bin/env bash

LICENSE_KEY=$1

if [ -z "$LICENSE_KEY" ]
then
	echo "You must provide Your NewRelic license key as script argument"
	exit
fi

echo "deb http://apt.newrelic.com/debian/ newrelic non-free" >> /etc/apt/sources.list

wget -O- https://download.newrelic.com/548C16BF.gpg | apt-key add -

apt-get update

nrsysmond-config --set license_key=$LICENSE_KEY

service newrelic-sysmond start
