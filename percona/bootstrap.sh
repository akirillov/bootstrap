#!/usr/bin/env bash

#Help message to make our script friendly:
usage()
{
cat << EOF
usage: $0 options

This script runs installation of Percona XtraDB Cluster on Ubuntu 12.04 64bit server 

OPTIONS:
   -h      	Show this message
   -b           Setup of initial node in cluster (bootstrap)
   -c           Comma-delimited set of the cluster's ip addresses
   -p           Root password for MySQL

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

if [[ $BOOTSTRAP ]] && [[ $CLUSTER ]]
then
	printf "[ERROR] Both bootstrap and cluster IP addresses presented but they are mutually exclusive.\n"
	exit 1
fi

if { [[ -z $BOOTSTRAP ]] && [[ -z $CLUSTER ]] ;} || [[ -z $PASSWD ]]
then
     printf "[ERROR] Incorrect parameters set\n"
     usage
     exit 1
fi

#Getting and installing conflicting packages for libmysqlclient
printf "========> Preparing to install Percona XtraDB Cluster : downloading libmysqlclient\n"
wget http://www.percona.com/redir/downloads/Percona-XtraDB-Cluster/LATEST/deb/precise/x86_64/libmysqlclient-dev_5.5.30-23.7.4-405.precise_amd64.deb
wget http://www.percona.com/redir/downloads/Percona-XtraDB-Cluster/LATEST/deb/precise/x86_64/libmysqlclient18_5.5.30-23.7.4-405.precise_amd64.deb

#Adding Percona deb repository for XtraDB Cluster packages
printf "========> Preparing to install Percona XtraDB Cluster : adding Percona public repository\n"
gpg --keyserver  hkp://keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
gpg -a --export CD2EFD2A | sudo apt-key add -

echo deb http://repo.percona.com/apt precise main >> /etc/apt/sources.list
echo deb-src http://repo.percona.com/apt precise main >> /etc/apt/sources.list


#Refreshing the repo with substitution for libmysql
printf "========> Preparing to install Percona XtraDB Cluster : updating repository\n"

apt-get update 

printf "========> Preparing to install Percona XtraDB Cluster : installing gdebi\n"

apt-get install --yes gdebi-core

printf "========> Preparing to install Percona XtraDB Cluster : installing libmysqlclient\n"
gdebi -n libmysqlclient*.deb

rm libmysqlclient*.deb

printf "========> Preparing to install Percona XtraDB Cluster : [SUCCESS]\n"

#Installing packages
printf "========> Starting Installation of Percona XtraDB Cluster\n"
export DEBIAN_FRONTEND=noninteractive
apt-get install -f -y percona-xtradb-cluster-server-5.5 percona-xtradb-cluster-client-5.5 percona-xtrabackup

printf "========> Starting Installation of Percona XtraDB Cluster: [SUCCESS]\n"

#Bootstrapping initial mysql tables structure

#1. init mysql tables
printf "===================> Configuring: creating MySQL system tables\n"
mysql_install_db
chown -R mysql:mysql /var/lib/mysql

#2 setting mysql root password
printf "===================> Configuring: setting root password\n"
mysqladmin -u root password $PASSWD


#3. edit my.cnf
printf "===================> Configuring: updating my.cnf\n"
cp -f my.cnf.bootstrap /etc/mysql/my.cnf

<<<<<<< HEAD
=======

#3. replace debian.conf to allow galera capabilities (username and password)
#cp -f debian.cnf.bootstrap /etc/mysql/debian.cnf

#4. grant privileges
#service mysql start

#mysql -uroot -p$PASSWD -e "GRANT ALL PRIVILEGES on *.* TO 'debian-sys-maint'@'localhost' IDENTIFIED BY 'NeEgkqhvPcwlDEPN' WITH GRANT OPTION; FLUSH PRIVILEGES;"

>>>>>>> 9fdb340b9ec929b1ffab56e2fb2b16267be4c2a5
#* Percona Server is distributed with several useful UDF (User Defined Function) from Percona Toolkit.
# * Run the following commands to create these functions:

printf "===================> Configuring: creating Percona stored procedures\n"

mysql -uroot -p$PASSWD -e "CREATE FUNCTION fnv1a_64 RETURNS INTEGER SONAME 'libfnv1a_udf.so'"
mysql -uroot -p$PASSWD -e "CREATE FUNCTION fnv_64 RETURNS INTEGER SONAME 'libfnv_udf.so'"
mysql -uroot -p$PASSWD -e "CREATE FUNCTION murmur_hash RETURNS INTEGER SONAME 'libmurmur_udf.so'"

printf "===================> Configuring: restarting\n"

if [[ $CLUSTER ]]
then
	printf "===================> Configuring: swap of cluster address to %s\n" $CLUSTER
	sed -i "/wsrep_cluster_address/c\wsrep_cluster_address=gcomm://$CLUSTER" /etc/mysql/my.cnf 	
fi

service mysql restart

printf "\nInstallation of Percona XtraDB Cluster completed !\nYou may want to configure cluster name and node name in /etc/mysql/my.cnf\n\n"

