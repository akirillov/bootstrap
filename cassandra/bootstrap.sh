#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#Help message to make our script friendly:
usage()
{
cat << EOF
usage: $0 options

This script runs installation of Cassandra Storage Server on Ubuntu 12.04 64bit server 

OPTIONS:
   -h      	Show this message
EOF
}

BOOTSTRAP=
CLUSTER=
PASSWD=
while getopts “hbc:p:” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         b)
             BOOTSTRAP=true
             ;;
         c)
             CLUSTER=$OPTARG
             ;;
         p)
             PASSWD=$OPTARG
             ;;
         ?)
#             usage
             exit
             ;;
     esac
done

#Adding Cassandra deb repository from DataStax
printf "========> Preparing to install Cassandra : adding DataStax public repository\n"
gpg --keyserver pgp.mit.edu --recv-keys F758CE318D77295D
gpg --export --armor F758CE318D77295D | sudo apt-key add -

gpg --keyserver pgp.mit.edu --recv-keys 2B5C1B00
gpg --export --armor 2B5C1B00 | sudo apt-key add -


#Adding to sources list only if not present
grep -q 'deb http://www.apache.org/dist/cassandra/debian 20x main' /etc/apt/sources.list || echo deb http://www.apache.org/dist/cassandra/debian 20x main  >> /etc/apt/sources.list
grep -q 'deb-src http://www.apache.org/dist/cassandra/debian 20x main' /etc/apt/sources.list || echo deb-src http://www.apache.org/dist/cassandra/debian 20x main  >> /etc/apt/sources.list


#echo deb-src http://www.apache.org/dist/cassandra/debian 20x main >> /etc/apt/sources.list

#Refreshing the repo with substitution for libmysql
printf "========> Preparing to install Cassandra : updating repository\n"

apt-get update 

printf "========> Starting Installation of Cassandra\n"

export DEBIAN_FRONTEND=noninteractive

apt-get install -f -y --force-yes cassandra

printf "========> Cassandra Installation Status: [SUCCESS]\n"

sudo cp -f $CURRENT_DIR/cassandra /etc/init.d/cassandra

sudo service cassandra status

printf "To start service use command\n sudo service cassandra start\n"
