Cassandra Bootstrap
=========

This bash script provides initial bootstrapping for Cassandra NoSQL storage.
Script uses deb package sources for installation. As far as available 2.0 package has bug in init.d script an appropriate replacement provided alongside with current bootstrap script.

Tested with Ubuntu Server 12.04 and Cassandra 2.0 Debian package.
You need test and may be modify script in case of different platform.

It is highly reccommended to test bootstrapping with KVM or any other virtual environment.

