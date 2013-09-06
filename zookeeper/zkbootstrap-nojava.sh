#!/usr/bin/env bash

add-apt-repository ppa:webupd8team/java -y && apt-get update && apt-get install oracle-java7-installer -y

apt-get install maven -y

wget http://apache-mirror.rbc.ru/pub/apache/zookeeper/zookeeper-3.4.5/zookeeper-3.4.5.tar.gz

tar -xzvf zookeeper-3.4.5.tar.gz

mkdir exhibitor
cd exhibitor

wget https://raw.github.com/Netflix/exhibitor/master/exhibitor-standalone/src/main/resources/buildscripts/standalone/maven/pom.xml

mvn assembly:single

#Generating startup script for exhibitor
echo -e "local_ip=`ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | cut -d' ' -f1`\necho \$local_ip \njava -jar target/exhibitor-war-1.0-jar-with-dependencies.jar -c file --hostname \$local_ip &" >> start.sh

chmod +x start.sh

./start.sh
