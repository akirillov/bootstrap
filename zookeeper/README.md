Zookeeper via Exhibitor Bootstrap
=========

This bash script provides initial bootstrapping for Debian cluter node dedicated to run Zookeeper via Exhibitor.
You need to have Java and Maven to be installed to run zkbootstrap.sh. Otherwise You can run zkbootstrap-nojava.sh it will download and install Java and Maven for You.

Sample script `start-exhibitor-s3.sh` provided as example of startup script in case of configuration stored in Amazon S3.
In addition to this script You should provide property file which contains Your S3 credentials. Config filename should be modified as well.

Tested with Ubuntu Server 12.04 and MacOs X
You need test and may be modify script in case of different platform.

### Initial ZK Config

Here is example of values you need to provide for proper ZK node start

Here is example of values you need to provide for proper ZK node start


`ZooKeeper Install Dir` - is your ZK installation dir

`ZooKeeper Snapshot Dir` `ZooKeeper Transaction Dir` is up to you

`Servers` must have at least one address `S:1:127.0.0.1` where `S` is prefix, `1` is server ID and `127.0.0.1` is IP address of the node

**Additional Config** enough for proper functioning:

    syncLimit=2
    tickTime=2000
    initLimit=5

**Ports** is up to you, but they should remain consistent across ZK cluster

**Automatic Server List Add/Remove** is up to you if you know what you're doing ;)

**Miscellaneous** values good enough for proper functioning:

    Log Index Dir = /opt/zk/logs
    Live Check (ms) = 10000
    Cleanup Period (ms) = 10000
    Cleanup: Max Log Files = 10

It is highly recommended to test bootstrapping with KVM or any other virtual environment.
