#!/usr/bin/env bash

wget http://repo.zabbix.com/zabbix/2.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_2.0-1precise_all.deb

dpkg -i zabbix-release_2.0-1precise_all.deb

apt-get update

printf "Checking mysql presence on the node\n"

if [ "$(dpkg-query -l | grep mysql-server | wc -l)" == 0 ]; then
        printf "mysql not found. installing\n"
        apt-get install mysql-server
else
        printf "mysql found\n"
fi

service mysql start

apt-get install -f zabbix-server-mysql zabbix-frontend-php
