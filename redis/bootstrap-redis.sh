#!/usr/bin/env bash

wget http://download.redis.io/releases/redis-2.6.16.tar.gz

apt-get update
apt-get install gcc --yes
apt-get install make --yes

tar xzf redis-2.6.16.tar.gz

cd redis-2.6.16

make

cd src

for file in `find . -executable` ; do
        cp $file /usr/local/bin/
done
