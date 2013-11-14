#!/usr/bin/env bash

LICENSE_KEY=$1

if [ -z "$LICENSE_KEY" ]
then
        echo "You must provide Your NewRelic license key as script argument"
        exit
fi

groupadd newrelic
useradd -s -g newrelic newrelic

apt-get install python-pip

apt-get update

pip install newrelic-plugin-agent
pip install newrelic_plugin_agent[postgresql]

sed -e "s/REPLACE_WITH_REAL_KEY/$LICENSE_KEY/g" /opt/newrelic_plugin_agent/newrelic_plugin_agent.cfg > /tmp/newrelic_plugin_agent.cfg.tmp
mv /tmp/newrelic_plugin_agent.cfg.tmp /opt/newrelic_plugin_agent/newrelic_plugin_agent.cfg

mkdir -p /var/log/newrelic
mkdir -p /var/run/newrelic

chown -R newrelic:newrelic /var/log/newrelic /var/run/newrelic /opt/newrelic_plugin_agent

echo "Now You need to edit newrelic_plugin_agent.cfg for proper configuration of monitred services."
echo "Enjoy!"

