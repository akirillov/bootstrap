Zookeeper via Exhibitor Bootstrap
=========

This bash script provides initial bootstrapping for Debian cluter node dedicated to run Zookeeper via Exhibitor.
You need to have Java and Maven to be installed to run zkbootstrap.sh. Otherwise You can run zkbootstrap-nojava.sh it will download and install Java and Maven for You.

Sample script `start-exhibitor-s3.sh` provided as example of startup script in case of configuration stored in Amazon S3.
In addition to this script You should provide property file which contains Your S3 credentials. Config filename should be modified as well.

Tested with Ubuntu Server 12.04.
You need test and may be modify script in case of different platform.

It is highly reccommended to test bootstrapping with KVM or any other virtual environment.

