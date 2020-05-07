#!/bin/bash
sudo apt-get update -y
sudo apt-get dist-upgrade -y
wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
sudo add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
sudo apt-get install -y adoptopenjdk-8-hotspot net-tools jq dos2unix

wget -qO zk.tar.gz http://www.gtlib.gatech.edu/pub/apache/zookeeper/zookeeper-3.6.1/apache-zookeeper-3.6.1-bin.tar.gz
tar zxf zk.tar.gz
sudo mv apache-zookeeper-* /opt/zookeeper
rm zk.tar.gz

sudo useradd --system --home /opt/zookeeper --shell /bin/false zookeeper
sudo mkdir -p /opt/zookeeper/data
sudo mkdir -p /opt/zookeeper/certs
sudo chown -R zookeeper:zookeeper /opt/zookeeper

sudo tee /etc/systemd/system/zookeeper.service > /dev/null <<EOF
[Unit]
Description=ZooKeeper Service
Documentation=http://zookeeper.apache.org
Requires=network.target
After=network.target

[Service]
User=zookeeper
Group=zookeeper
ExecStart=/opt/zookeeper/bin/zkServer.sh start-foreground
WorkingDirectory=/opt/zookeeper/data
SuccessExitStatus=143

[Install]
WantedBy=default.target
EOF

sudo systemctl daemon-reload
sudo systemctl disable zookeeper
sudo systemctl stop zookeeper

sudo -u zookeeper tee /opt/zookeeper/conf/zoo.cfg > /dev/null <<EOF
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/opt/zookeeper/data
clientPort=2181
# secureClientPort=2281
autopurge.snapRetainCount=3
autopurge.purgeInterval=1
metricsProvider.className=org.apache.zookeeper.metrics.prometheus.PrometheusMetricsProvider
metricsProvider.httpPort=7000
metricsProvider.exportJvmInfo=true

zookeeper.electionPortBindRetry=30

server.1=zk-1.private.${domain}:2888:3888
server.2=zk-2.private.${domain}:2888:3888
server.3=zk-3.private.${domain}:2888:3888

# https://zookeeper.apache.org/doc/r3.6.1/zookeeperAdmin.html#Quorum+TLS
# sslQuorum=true
# serverCnxnFactory=org.apache.zookeeper.server.NettyServerCnxnFactory
# ssl.quorum.keyStore.location=/opt/zookeeper/conf/keystore.jks
# ssl.quorum.keyStore.password=password
# ssl.quorum.trustStore.location=/opt/zookeeper/conf/truststore.jks
# ssl.quorum.trustStore.password=password

# ssl.keyStore.location=/opt/zookeeper/conf/keystore.jks
# ssl.keyStore.password=password
# ssl.trustStore.location=/opt/zookeeper/conf/truststore.jks
# ssl.trustStore.password=password

# admin.portUnification=true

# https://github.com/apache/zookeeper/blob/release-3.6.1/zookeeper-server/src/main/java/org/apache/zookeeper/common/X509Util.java#L106-L115
# ssl.clientAuth=none
# ssl.quorum.clientAuth=none
EOF

myid=$(hostname | cut -d- -f 2)
sudo -u zookeeper tee /opt/zookeeper/data/myid > /dev/null <<EOF
$myid
EOF

localIP=$(ip addr show eth1 | grep 'inet ' | awk '{print $2}' | cut -f1 -d'/')

# auto-generate our keystore.jks
sudo -u zookeeper keytool -genkeypair -alias $(hostname).private.${domain} \
  -keyalg RSA -keysize 2048 -dname "cn=$(hostname).private.${domain}" \
  -keypass password \
  -keystore /opt/zookeeper/conf/keystore.jks \
  -storepass password \
  -ext san=ip:$localIP,dns:$(hostname).private.${domain},dns:localhost

# automatically pull out our certificate for the truststore we'll build
sudo -u zookeeper keytool -exportcert -alias $(hostname).private.${domain} \
  -keystore /opt/zookeeper/conf/keystore.jks \
  -file /opt/zookeeper/conf/$(hostname).private.${domain}.cer -storepass password -rfc

# Gets rid of ^M characters at the end of every line of the cert
# This probably isn't needed but it makes me feel better.
sudo -u zookeeper dos2unix /opt/zookeeper/conf/$(hostname).private.${domain}.cer
