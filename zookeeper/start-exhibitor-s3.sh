#Alternative startup script for exhibitor which uses Amazon S3 for configuration storage

#
# You have to provide file s3creds.properties in the script's dir which must contain two fields:
#
#	com.netflix.exhibitor.s3.access-key-id 		=AKIAJSWFWTRQNHA
#	com.netflix.exhibitor.s3.access-secret-key	=Zh4GSMJ234tr5fdqqwer43qr5243r96bgPsiB2AGBepuhm6clB
#
# Warning: values on the right side of the properties are examples, you should provide your own credentials

local_ip=`ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | cut -d' ' -f1`

echo $local_ip 

java -jar target/exhibitor-1.0-jar-with-dependencies.jar -c s3 --s3credentials s3creds.properties --s3config ZK-config:zoo.cfg --hostname $local_ip >> exhibitor.out &


