#!/usr/bin/env bash

LICENSE_KEY=$1

if [ -z "$LICENSE_KEY" ]
then
	echo "You must provide Your NewRelic license key as script argument"
	exit
fi

wget http://3legs.com.ar/downloads/newrelic/newrelic_3legs_plugin-0.0.2-cassandra.tar.gz

dir=newrelic-cassandra-plugin
mkdir -p $dir
tar -C $dir -xzf newrelic_3legs_plugin-0.0.2-cassandra.tar.gz

cd $dir

echo "$LICENSE_KEY" >> config/newrelic.properties

echo "#!/bin/bash\njava -jar newrelic_3legs_plugin-0.0.2.jar &" >> start.sh

chmod +x start.sh

echo "Configure application.conf before start. Enjoy!\n"
