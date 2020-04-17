---
id: handson_zookeeper
title: Let's Play With Zookeeper
sidebar_label: Zookeeper
---
import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

## Run Zookeeper Locally

You can get Zookeeper a few ways:

* [Releases Page](https://zookeeper.apache.org/releases.html)
* [Docker Hub](https://hub.docker.com/_/zookeeper)

We're going to use the `tar.gz` from the Releases Page, and we're using version 3.6.x

Also, here's a [semi-official guide](https://cwiki.apache.org/confluence/display/ZOOKEEPER/ZooKeeper+SSL+User+Guide).

## Create ZK Keystores

Create SSL keystore JKS to store local credentials, one keystore should be created for each ZK instance.

In this example we generate a self-signed certificate and store it together with the private key in keystore.jks.
This is suitable for testing purposes, but you probably need an official certificate to sign your keys in a production environment.

:::note
The alias (-alias) and the distinguished name (-dname) must match the hostname of the machine that is associated with, otherwise hostname verification won't work.
:::

```text
keytool -genkeypair -alias $(hostname -f) \
  -keyalg RSA -keysize 2048 -dname "cn=$(hostname -f)" \
  -keypass password \
  -keystore /opt/apache-zookeeper-3.6.0-bin/conf/keystore.jks \
  -storepass password
```

Extract the signed public key (certificate) from keystore, this step might only necessary for self-signed certificates.

```bash
keytool -exportcert -alias $(hostname -f) \
  -keystore /opt/apache-zookeeper-3.6.0-bin/conf/keystore.jks \
  -file /opt/apache-zookeeper-3.6.0-bin/conf/$(hostname -f).cer -rfc
```

Create a `truststore.jks` with all our certificates.

```bash
keytool -importcert -alias host1 -file /opt/apache-zookeeper-3.6.0-bin/conf/ip-10-0-0-58.us-east-2.compute.internal.cer \
    -keystore /opt/apache-zookeeper-3.6.0-bin/conf/truststore.jks -storepass password
keytool -importcert -alias host2 -file /opt/apache-zookeeper-3.6.0-bin/conf/ip-10-0-0-244.us-east-2.compute.internal.cer \
    -keystore /opt/apache-zookeeper-3.6.0-bin/conf/truststore.jks -storepass password
keytool -importcert -alias host3 -file /opt/apache-zookeeper-3.6.0-bin/conf/ip-10-0-0-247.us-east-2.compute.internal.cer \
    -keystore /opt/apache-zookeeper-3.6.0-bin/conf/truststore.jks -storepass password
```

List certs:

```bash
keytool -list -v -keystore /opt/apache-zookeeper-3.6.0-bin/conf/truststore.jks
# Enter keystore password:  
# Keystore type: PKCS12
# Keystore provider: SUN
# 
# Your keystore contains 3 entries
# 
# Alias name: host1
# Creation date: Apr 17, 2020
# Entry type: trustedCertEntry
# 
# Owner: CN=ip-10-0-0-58.us-east-2.compute.internal
# Issuer: CN=ip-10-0-0-58.us-east-2.compute.internal
# Serial number: 75066579
# Valid from: Fri Apr 17 15:15:30 UTC 2020 until: Thu Jul 16 15:15:30 UTC 2020
# Certificate fingerprints:
# 	 SHA1: 3F:AD:A6:8F:D8:E3:FF:51:20:0B:7E:50:3B:7D:C8:B5:C5:CB:50:8E
# 	 SHA256: FB:D5:BA:32:44:3D:DD:56:EF:63:78:AB:B3:CE:2C:9B:6A:13:D9:3B:96:6E:27:73:27:CD:A9:21:C2:DC:5C:D4
# Signature algorithm name: SHA256withRSA
# Subject Public Key Algorithm: 2048-bit RSA key
# Version: 3
# 
# Extensions: 
# 
# #1: ObjectId: 2.5.29.14 Criticality=false
# SubjectKeyIdentifier [
# KeyIdentifier [
# 0000: <data>
# 0010: <data>
# ]
# ]
# 
# 
# 
# *******************************************
# *******************************************
# 
# 
# Alias name: host2
# Creation date: Apr 17, 2020
# Entry type: trustedCertEntry
# 
# Owner: CN=ip-10-0-0-244.us-east-2.compute.internal
# Issuer: CN=ip-10-0-0-244.us-east-2.compute.internal
# Serial number: 1cbfd1d3
# Valid from: Fri Apr 17 15:15:26 UTC 2020 until: Thu Jul 16 15:15:26 UTC 2020
# Certificate fingerprints:
# 	 SHA1: 3F:DB:32:EA:C8:A1:79:58:65:76:43:3C:EC:37:9F:60:5C:49:71:5F
# 	 SHA256: D4:D6:D3:90:20:63:C0:04:C9:9E:05:E3:9F:21:54:FD:70:D1:C1:9D:2D:7F:85:C0:A2:0E:10:68:10:DC:B9:F2
# Signature algorithm name: SHA256withRSA
# Subject Public Key Algorithm: 2048-bit RSA key
# Version: 3
# 
# Extensions: 
# 
# #1: ObjectId: 2.5.29.14 Criticality=false
# <SubjectKeyIdentifier [
# KeyIdentifier [
# 0000: <data>
# 0010: <data>
# ]
# ]>
# 
# 
# 
# *******************************************
# *******************************************
# 
# 
# Alias name: host3
# Creation date: Apr 17, 2020
# Entry type: trustedCertEntry
#
# Owner: CN=ip-10-0-0-247.us-east-2.compute.internal
# Issuer: CN=ip-10-0-0-247.us-east-2.compute.internal
# Serial number: 2cbb3e2f
# Valid from: Fri Apr 17 15:15:28 UTC 2020 until: Thu Jul 16 15:15:28 UTC 2020
# Certificate fingerprints:
# 	 SHA1: EF:7F:6B:C0:AB:CD:BA:49:C1:30:22:E3:0C:3E:85:5C:04:F9:97:7E
# 	 SHA256: 17:80:A3:7E:57:49:16:C5:02:D3:E9:CC:6D:7F:FB:FD:61:65:9F:5E:98:A1:1F:E7:AD:6F:57:D4:AC:FA:E1:CF
# Signature algorithm name: SHA256withRSA
# Subject Public Key Algorithm: 2048-bit RSA key
# Version: 3
#
# Extensions: 
#
# #1: ObjectId: 2.5.29.14 Criticality=false
# SubjectKeyIdentifier [
# KeyIdentifier [
# 0000: <data>
# 0010: <data>
# ]
# ]
#
#
#
# *******************************************
# *******************************************
```

Configure our server with some new properties:

```text
sslQuorum=true
serverCnxnFactory=org.apache.zookeeper.server.NettyServerCnxnFactory
ssl.quorum.keyStore.location=/opt/apache-zookeeper-3.6.0-bin/conf/keystore.jks
ssl.quorum.keyStore.password=password
ssl.quorum.trustStore.location=/opt/apache-zookeeper-3.6.0-bin/conf/truststore.jks
ssl.quorum.trustStore.password=password
```
