#!/bin/bash
sudo apt-get update -y
sudo apt-get dist-upgrade -y
wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
sudo add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
sudo apt-get install -y adoptopenjdk-8-hotspot

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
sudo systemctl start zookeeper
sudo systemctl enable zookeeper

sudo -u zookeeper tee /opt/zookeeper/conf/zoo.cfg > /dev/null <<EOF
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/opt/zookeeper/data
clientPort=2281
autopurge.snapRetainCount=3
autopurge.purgeInterval=1
metricsProvider.className=org.apache.zookeeper.metrics.prometheus.PrometheusMetricsProvider
metricsProvider.httpPort=7000
metricsProvider.exportJvmInfo=true

# https://zookeeper.apache.org/doc/r3.6.1/zookeeperAdmin.html#Quorum+TLS
zookeeper.serverCnxnFactory=org.apache.zookeeper.server.NettyServerCnxnFactory
zookeeper.ssl.keyStore.location=/opt/zookeeper/certs/KeyStore.jks
zookeeper.ssl.keyStore.password=testpass
zookeeper.ssl.trustStore.location=/opt/zookeeper/certs/testTrustStore.jks
zookeeper.ssl.trustStore.password=testpass
EOF
