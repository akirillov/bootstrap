#!/usr/bin/env bash

#Help message to make our script friendly:
usage()
{
cat << EOF

This script runs installation of MeetMe NewRelic plugins 

Usage: $0 [OPTIONS]

OPTIONS:
   -h           Show this message
   -p           Setup for PostgreSQL monitoring
   -r           Setup for Redis monitoring
   -k           New Relic license key

EOF
}

POSTGRES=
REDIS=
LICENSE_KEY=
while getopts “hprk:” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         p)
             POSTGRES=true
             ;;
         r)
             REDIS=true
             ;;
         k)
             LICENSE_KEY=$OPTARG
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

if [[ ! $POSTGRES ]] && [[ ! $REDIS ]]
then
        echo "You must provide at least one key for target system!"
        usage
        exit
fi

if [ -z "$LICENSE_KEY" ]
then
        echo "You must provide Your NewRelic license key as script argument"
	usage
        exit
fi

groupadd newrelic
useradd -s -g newrelic newrelic

if [ $POSTGRES ]
then
	sudo apt-get install python2.7-dev
	apt-get install postgresql-server-dev-all
fi

apt-get install python-pip

apt-get upgrade

pip install newrelic-plugin-agent

if [ $POSTGRES ] 
then
	pip install newrelic_plugin_agent[postgresql]
fi


sed -e "s/REPLACE_WITH_REAL_KEY/$LICENSE_KEY/g" /opt/newrelic_plugin_agent/newrelic_plugin_agent.cfg > /tmp/newrelic_plugin_agent.cfg.tmp
mv /tmp/newrelic_plugin_agent.cfg.tmp /opt/newrelic_plugin_agent/newrelic_plugin_agent.cfg

mkdir -p /var/log/newrelic
mkdir -p /var/run/newrelic

chown -R newrelic:newrelic /var/log/newrelic /var/run/newrelic /opt/newrelic_plugin_agent

echo "Now You need to edit newrelic_plugin_agent.cfg for proper configuration of monitred services."
echo "Enjoy!"
