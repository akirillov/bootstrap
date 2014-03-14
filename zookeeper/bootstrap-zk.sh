#!/usr/bin/env bash

wget http://apache-mirror.rbc.ru/pub/apache/zookeeper/zookeeper-3.4.5/zookeeper-3.4.5.tar.gz

tar -xzvf zookeeper-3.4.5.tar.gz

mkdir exhibitor
cd exhibitor

wget https://raw.github.com/Netflix/exhibitor/master/exhibitor-standalone/src/main/resources/buildscripts/standalone/maven/pom.xml

mvn assembly:single

#Generating startup script for exhibitor
echo -e "local_ip=`ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'`\necho \$local_ip \njava -jar target/exhibitor-1.0-jar-with-dependencies.jar -c file --hostname \$local_ip > /dev/null 2> /dev/null &" >> start.sh

chmod +x start.sh

./start.sh >> exhibitor.out &
