#!/bin/bash

# Read config from env variables

HOST=0.0.0.0
ALT_HOST=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)

# default opts for jvm
if [ "$XMX" == "" ]; then
    XMX=-Xmx1g
fi
if [ "$XMS" == "" ]; then
    XMS=-Xms1g
fi
if [ "$JAVA_OPTS"  == "" ]; then
    JAVA_OPTS='-XX:+UseG1GC -XX:MaxGCPauseMillis=50'
fi
# Create properties file dynamically

cat > /opt/datomic/config/transactor.properties <<EOF
################################################################

protocol=free
host=$HOST
port=4334
alt-host=$ALT_HOST


## OPTIONAL ####################################################
# The dev: and free: protocols typically use three ports
# starting with the selected :port, but you can specify the
# other ports explicitly, e.g. for virtualization environs
# that do not issue contiguous ports.

# h2-port=4335
# h2-web-port=4336

################################################################
# See http://docs.datomic.com/capacity.html


# Recommended settings for -Xmx4g production usage.
# memory-index-threshold=32m
# memory-index-max=512m
# object-cache-max=1g

# Recommended settings for -Xmx1g usage, e.g. dev laptops.
memory-index-threshold=32m
memory-index-max=64m
object-cache-max=32m

## OPTIONAL ####################################################


# Set to false to disable SSL between the peers and the transactor.
# Default: true
# encrypt-channel=true

# Data directory is used for dev: and free: storage, and
# as a temporary directory for all storages.
data-dir=/var/datomic/data

# Transactor will log here, see bin/logback.xml to configure logging.
log-dir=/var/datomic/log

# Transactor will write process pid here on startup
# pid-file=transactor.pid



## OPTIONAL ####################################################
# See http://docs.datomic.com/capacity.html


# Soft limit on the number of concurrent writes to storage.
# Default: 4, Miniumum: 2
# write-concurrency=4

# Soft limit on the number of concurrent reads to storage.
# Default: 2 times write-concurrency, Miniumum: 2
# read-concurrency=8

EOF

# Start transactor with config

/opt/datomic/bin/transactor $XMX $XMS $JAVA_OPTS /opt/datomic/config/transactor.properties
